//
//  JKRealmAdapter.m
//  Pods
//
//  Created by Cristian Bica on 02/04/15.
//
//

#import "JKRealmAdapter.h"
#import <Realm/Realm.h>
#import "JKRealmJobRecord.h"

@interface JKRealmAdapter ()
@property (readonly) RLMRealm *realm;
@end

@implementation JKRealmAdapter

- (instancetype)init {
  if (self = [super init]) {
    [self setup];
  }
  return self;
}

- (void)setup {
}


- (RLMRealm *)realm {
  if ([[NSThread currentThread].threadDictionary objectForKey:@"JobKitRealm"]==nil) {
    [[NSThread currentThread].threadDictionary setObject:[self createRealm] forKey:@"JobKitRealm"];
  }
  return [[NSThread currentThread].threadDictionary objectForKey:@"JobKitRealm"];
}

- (RLMRealm *)createRealm {
  NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
  path = [path stringByAppendingString:@"/jobkit.realm"];
  return [RLMRealm realmWithPath:path];
}

- (void)dealloc {
}

- (id)pushJob:(JKJob *)job {
  JKRealmJobRecord *record = [JKRealmJobRecord recordFromJob:job];
  NSLog(@"Realm Adapter: enqueing job %@ in record %@", job, record);
  [self.realm transactionWithBlock:^{
    [self.realm addObject:record];
  }];
  return record.guid;
}

- (JKJob *)popJob {
  JKRealmJobRecord *record = [[[JKRealmJobRecord objectsInRealm:self.realm where:@"locked == false"]
                               sortedResultsUsingProperty:@"enqueuedAt" ascending:YES] firstObject];
  NSLog(@"Realm Adapter: poping job %@ from record %@", record.job, record);
  [self.realm transactionWithBlock:^{
    record.locked = YES;
    record.lockedAt = [NSDate date];
  }];
  return record.job;
}

- (JKJob *)peek {
  JKRealmJobRecord *record = [[[JKRealmJobRecord objectsInRealm:self.realm where:@"locked == false"]
                               sortedResultsUsingProperty:@"enqueuedAt" ascending:YES] firstObject];
  return record.job;
}

- (NSArray *)peek:(NSUInteger)count {
  NSMutableArray *results = [NSMutableArray arrayWithCapacity:count];
  RLMResults *rmResults = [[JKRealmJobRecord objectsInRealm:self.realm where:@"locked == false"]
                           sortedResultsUsingProperty:@"enqueuedAt" ascending:YES];
  for (int i=0; i<count; i++) {
    if (rmResults.count>i) {
      [results addObject:[rmResults objectAtIndex:i]];
    }
  }
  return [NSArray arrayWithArray:results];
}


- (BOOL)hasJobs {
  return [[[JKRealmJobRecord objectsInRealm:self.realm where:@"locked == false"]
           sortedResultsUsingProperty:@"enqueuedAt" ascending:YES] count]>0;
}

- (BOOL)supportsNotifications {
  return NO;
}

@end
