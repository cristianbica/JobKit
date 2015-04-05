//
//  JKJob.m
//  Pods
//
//  Created by Cristian Bica on 03/04/15.
//
//

#import "JKJob.h"
#import "JobKit.h"
#import <objc/runtime.h>

@implementation JKJob

- (instancetype)init {
  if (self = [super init]) {
    self.identifier = [NSUUID UUID].UUIDString;
  }
  return self;
}

+ (JKJob *)performLater:(NSArray *)arguments {
  JKJob *job = [[self alloc] init];
  job.arguments = arguments ?: @[];
  [JobKit enqueueJob:job];
  return job;
}

- (void)perform {
  [NSException raise:NSInternalInconsistencyException
              format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];  
}

JK_NSCODING_MIXIN
@end
