//
//  JKCoreDataAdapter.m
//  Pods
//
//  Created by Cristian Bica on 06/04/15.
//
//

#import "JKCoreDataAdapter.h"
#import <CoreData/CoreData.h>
#import "JKCoreDataJobRecord.h"
#import "JobKit.h"

@interface JKCoreDataAdapter ()
@property (nonatomic, strong) NSMutableDictionary *notificationListeners;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *privateContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation JKCoreDataAdapter

- (instancetype)init {
  if (self = [super init]) {
    [self setup];
  }
  return self;
}

- (void)setup {
  [self setupCoreData];
  self.notificationListeners = [NSMutableDictionary dictionary];
}

- (void)cleanUp {
  [self.privateContext performBlockAndWait:^{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"JKCoreDataJobRecord"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"enqueuedAt" ascending:YES]];
    NSArray *jobs = [self.privateContext executeFetchRequest:fetchRequest error:nil];
    [jobs enumerateObjectsUsingBlock:^(JKCoreDataJobRecord *obj, NSUInteger idx, BOOL *stop) {
      [self.privateContext deleteObject:obj];
    }];
  }];
}

- (void)dealloc {
  [self.notificationListeners removeAllObjects];
}

- (void)notifyListeners {
  [self.notificationListeners enumerateKeysAndObjectsUsingBlock:^(id key, JKStorageAdapterNotificationBlock block, BOOL *stop) {
    block();
  }];
}

#pragma mark - Core Data stack

- (void)setupCoreData {
  //MoM
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"JobKit" withExtension:@"momd"];
  if (!modelURL) {
    modelURL = [[NSBundle bundleForClass:[JobKit class]] URLForResource:@"JobKit" withExtension:@"momd"];
  }
  NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  //Persistent Store
  NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
		NSDictionary *persistentStoreOptions = @{
                                             NSMigratePersistentStoresAutomaticallyOption: @YES,
                                             NSInferMappingModelAutomaticallyOption: @YES,
                                             NSSQLitePragmasOption:  @{ @"journal_mode":@"DELETE" }
                                             };
		NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"JobKit.sqlite"];
		[coordinator addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:storeURL
                                    options:persistentStoreOptions
                                      error:nil];
  //MoC
  self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  self.privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
  self.privateContext.persistentStoreCoordinator = coordinator;
  self.managedObjectContext.parentContext = self.privateContext;
  //Observe jobs
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didChangeObjects:)
                                               name:NSManagedObjectContextObjectsDidChangeNotification
                                             object:self.managedObjectContext];
}

- (void)didChangeObjects:(NSNotification *)notification {
  NSSet *insertedObjects = [[notification userInfo] objectForKey:NSInsertedObjectsKey];
  [insertedObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
    if ([obj isKindOfClass:[JKCoreDataJobRecord class]]) {
      [self notifyListeners];
      return;
    }
  }];
}

#pragma mark - Adapter Protocol Methods

- (id)pushJob:(JKJob *)job {
  JKCoreDataJobRecord *record = [JKCoreDataJobRecord createRecordFromJob:job inContext:self.privateContext];
  NSLog(@"CoreData Adapter: enqueing job %@ in record %@", job, record);
  return record.guid;
}

- (JKJob *)popJob {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"JKCoreDataJobRecord"];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"locked == false"];;
  fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"enqueuedAt" ascending:YES]];
  fetchRequest.fetchLimit = 1;
  NSArray *jobs = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  if (jobs.count > 0) {
    JKCoreDataJobRecord *record = [jobs firstObject];
    [self.privateContext performBlockAndWait:^{
      record.locked = @(YES);
      record.lockedAt = [NSDate date];
      [self.privateContext save:nil];
    }];
    JKJob *job = record.job;
    NSLog(@"CoreData Adapter: poping job %@ from record %@", job, record);
    return job;
  } else {
    return nil;
  }
}

- (JKJob *)peek {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"JKCoreDataJobRecord"];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"locked == false"];;
  fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"enqueuedAt" ascending:YES]];
  fetchRequest.fetchLimit = 1;
  NSArray *jobs = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  if (jobs.count > 0) {
    JKCoreDataJobRecord *job = [jobs firstObject];
    return job.job;
  } else {
    return nil;
  }
}

- (NSArray *)peek:(NSUInteger)count {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"JKCoreDataJobRecord"];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"locked == false"];;
  fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"enqueuedAt" ascending:YES]];
  fetchRequest.fetchLimit = count;
  NSArray *jobs = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  return jobs;
}


- (BOOL)hasJobs {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"JKCoreDataJobRecord"];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"locked == false"];;
  fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"enqueuedAt" ascending:YES]];
  return [self.managedObjectContext countForFetchRequest:fetchRequest error:nil]>0;
}

- (BOOL)supportsNotifications {
  return YES;
}

- (id)addNotificationBlock:(JKStorageAdapterNotificationBlock)block {
  NSString *guid = [NSUUID UUID].UUIDString;
  self.notificationListeners[guid] = block;
  return guid;
}

- (void)removeNotificationBlock:(id)token {
  [self.notificationListeners removeObjectForKey:token];
}

@end
