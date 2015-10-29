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
#import "NSArray+JobKit.h"

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
  if (![job argumentsAreArchivable]) {
    [NSException raise:NSInternalInconsistencyException
                format:@"You are trying to enqueue a job with some arguments but not all arguments"
     "conforms to the NSCoding protocol which  is needed to serialize/deserialize  them"];
  }
  
  [JobKit enqueueJob:job];
  return job;
}

- (BOOL)argumentsAreArchivable {
  return [self.arguments jk_allConformsToProtocol:@protocol(NSCoding)];
}

- (void)perform {
  [NSException raise:NSInternalInconsistencyException
              format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];  
}

JK_NSCODING_MIXIN
@end

