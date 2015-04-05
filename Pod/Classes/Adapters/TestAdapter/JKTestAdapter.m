//
//  JKTestAdapter.m
//  Pods
//
//  Created by Cristian Bica on 03/04/15.
//
//

#import "JKTestAdapter.h"
#import <JKJob.h>

@interface JKTestAdapter ()
@property (strong) NSMutableDictionary *store;
@property (strong) NSMutableArray *storeIndex;
@end

@implementation JKTestAdapter

- (instancetype)init {
  if (self = [super init]) {
    [self setup];
  }
  return self;
}

- (void)setup {
  self.store = [NSMutableDictionary dictionary];
  self.storeIndex = [NSMutableArray array];
}

- (void)dealloc {
  [self.store removeAllObjects];
  [self.storeIndex removeAllObjects];
}

- (id)pushJob:(JKJob *)job {
  NSString *guid = [NSUUID UUID].UUIDString;
  [self.storeIndex addObject:guid];
  [self.store setObject:[NSKeyedArchiver archivedDataWithRootObject:job] forKey:guid];
  return guid;
}


- (JKJob *)popJob {
  NSString *guid = self.storeIndex.firstObject;
  if (guid) {
    [self.storeIndex removeObjectAtIndex:0];
    JKJob *job = [NSKeyedUnarchiver unarchiveObjectWithData:[self.store objectForKey:guid]];
    NSLog(@"Test Adapter: poping job %@ with key %@", job, guid);
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

@end
