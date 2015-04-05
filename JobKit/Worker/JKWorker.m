//
//  JKWorker.m
//  Pods
//
//  Created by Cristian Bica on 02/04/15.
//
//

#import "JKWorker.h"

NSString * JKWorkerJobWillStart = @"com.jobkit.jkworker-job-start";
NSString * JKWorkerJobDidFinish = @"com.jobkit.jkworker-job-finish";
NSString * JKWorkerJobDidFail = @"com.jobkit.jkworker-job-fail";
NSString * JKWorkerJobDidSucceeded = @"com.jobkit.jkworker-job-success";


@interface JKWorker ()
@property (weak) JobKit *manager;
@property NSUInteger index;
@end

@implementation JKWorker

- (instancetype)initWithManager:(JobKit *)manager index:(NSUInteger)index  {
  if (self = [super init]) {
    self.manager = manager;
    self.index = index;
  }
  return self;
}

- (void)executeJob:(JKJob *)job completion:(void (^)(BOOL success, NSException *exception))block {
  [[NSNotificationCenter defaultCenter] postNotificationName:JKWorkerJobWillStart
                                                      object:self
                                                    userInfo:@{@"job" : job}];
  [self addOperationWithBlock:^{
    __block BOOL success = YES;
    @try {
      [job perform];
      [[NSNotificationCenter defaultCenter] postNotificationName:JKWorkerJobDidSucceeded
                                                          object:self
                                                        userInfo:@{@"job" : job}];
      if(block) block(YES, nil);
    }
    @catch (NSException *exception) {
      [[NSNotificationCenter defaultCenter] postNotificationName:JKWorkerJobDidFail
                                                          object:self
                                                        userInfo:@{@"job" : job}];
      if(block) block(NO, exception);
      success = NO;
    }
    @finally {
      [[NSNotificationCenter defaultCenter] postNotificationName:JKWorkerJobDidFinish
                                                          object:self
                                                        userInfo:@{@"job" : job, @"success" : @(success)}];
    }    
  }];
}

@end
