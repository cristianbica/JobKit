//
//  JobKit.m
//  Pods
//
//  Created by Cristian Bica on 02/04/15.
//
//

#import "JobKit.h"
#import "JKRealmAdapter.h"
#import "JKWorker.h"

static JobKit *_defaultManager;

@interface JobKit ()
@property (strong) id<JKStorageAdapter> storage;
@property (strong) JKWorker *worker;
@property BOOL paused;
@property id storageNotificationToken;
@property dispatch_queue_t queue;
@property dispatch_source_t timer;
@end

@implementation JobKit

- (instancetype)initWithStorageProvider:(Class)storageProviderClass  {
  if (self = [super init]) {
    self.queue = dispatch_queue_create("com.jobkit.main", NULL);
    self.storage = [[storageProviderClass alloc] init];
    self.paused = YES;
    self.tickInterval = 1;
    self.concurrentJobsLimit = 1;
    self.worker = [[JKWorker alloc] init];
    self.worker.maxConcurrentOperationCount = self.concurrentJobsLimit;
  }
  return self;
}


+ (instancetype)setupDefaultManagerWithStorageProvider:(Class)storageProviderClass {
  [self setDefaultManager:[[self alloc] initWithStorageProvider:storageProviderClass]];
  return [self defaultManager];
}

+ (instancetype)defaultManager {
  if (_defaultManager==nil) {
    _defaultManager = [[self alloc] initWithStorageProvider:[JKRealmAdapter class]];
  }
  return _defaultManager;
}

+ (void)setDefaultManager:(JobKit *)manager {
  if (_defaultManager) {
    [_defaultManager stopAndCancelCurrentJobs];
  }
  _defaultManager = manager;
}

+ (void)start {
  [[self defaultManager] start];
}

+ (void)stop {
  [[self defaultManager] stop];
}

+ (void)stopAndCancelCurrentJobs {
  [[self defaultManager] stopAndCancelCurrentJobs];
}


+ (void)enqueueJob:(JKJob *)job {
  [[self defaultManager] enqueueJob:job];
}

- (void)start {
  if (self.paused) {
    self.paused = NO;
    //[self tick];
    dispatch_resume(self.timer);
  }
}

- (void)stop {
  if (!self.paused) {
    dispatch_suspend(self.timer);
    self.paused = YES;
  }
}

- (void)setTickInterval:(NSTimeInterval)tickInterval {
  _tickInterval = tickInterval;
  if (self.timer) {
    dispatch_source_cancel(self.timer);
    //dispatch_release(self.timer);
  }
  self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
  dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, self.tickInterval*NSEC_PER_SEC, 0);
  dispatch_source_set_event_handler(self.timer, ^{ [self tick]; });
}

- (void)stopAndCancelCurrentJobs {
  [self stop];
  [self.worker cancelAllOperations];
}

- (void)tick {
  NSLog(@"Ticking");
  dispatch_async(self.queue, ^{
    @synchronized(self) {
      if (![self.storage hasJobs]) {
        return;
      }
      JKJob *job = [self.storage popJob];
      [self.worker executeJob:job completion:^(BOOL success, NSException *exception) {
        //TODO
      }];
    }
  });
}


-(void)enqueueJob:(JKJob *)job {
  dispatch_async(self.queue, ^{
    [self.storage pushJob:job];
  });
}


@end
