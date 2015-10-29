//
//  JKTestAdapter.m
//  Pods
//
//  Created by Cristian Bica on 03/04/15.
//
//

#import "JKMemoryAdapter.h"
#import <JKJob.h>

@interface JKMemoryAdapter ()
@property (nonatomic, strong) NSMutableDictionary *notificationListeners;
@property (strong) NSMutableDictionary *store;
@property (strong) NSMutableArray *storeIndex;
@end

@implementation JKMemoryAdapter

- (instancetype)init {
  if (self = [super init]) {
    [self setup];
  }
  return self;
}

- (void)setup {
  self.store = [NSMutableDictionary dictionary];
  self.storeIndex = [NSMutableArray array];
  self.notificationListeners = [NSMutableDictionary dictionary];
}

- (void)dealloc {
  [self.store removeAllObjects];
  [self.storeIndex removeAllObjects];
  [self.notificationListeners removeAllObjects];
}

- (void)notifyListeners {
  [self.notificationListeners enumerateKeysAndObjectsUsingBlock:^(id key, JKStorageAdapterNotificationBlock block, BOOL *stop) {
    block();
  }];
}

- (id)pushJob:(JKJob *)job {
  NSString *guid = [NSUUID UUID].UUIDString;
  [self.storeIndex addObject:guid];
  [self.store setObject:[NSKeyedArchiver archivedDataWithRootObject:job] forKey:guid];
  [self performSelector:@selector(notifyListeners) withObject:nil afterDelay:0.01];
  return guid;
}


- (JKJob *)popJob {
  NSString *guid = self.storeIndex.firstObject;
  if (guid) {
    [self.storeIndex removeObjectAtIndex:0];
    JKJob *job = [NSKeyedUnarchiver unarchiveObjectWithData:[self.store objectForKey:guid]];
    NSLog(@"Memory Adapter: poping job %@ with key %@", job, guid);
    [self.store removeObjectForKey:guid];
    return job;
  }
  return nil;
}

- (JKJob *)peek {
  NSString *guid = self.storeIndex.firstObject;
  if (guid) {
    [self.storeIndex removeObjectAtIndex:0];
    JKJob *job = [self.store objectForKey:guid];
    return job;
  }
  return nil;
}

- (NSArray *)peek:(NSUInteger)count {
  NSMutableArray *results = [NSMutableArray arrayWithCapacity:count];
  for (int i=0; i<count; i++) {
    if (self.storeIndex.count>i) {
      [results addObject:[self.store objectForKey:[self.storeIndex objectAtIndex:i]]];
    }
  }
  return [NSArray arrayWithArray:results];
}


- (BOOL)hasJobs {
  return [self.storeIndex count]>0;
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
