//
//  NSObject+JobKit.m
//  Pods
//
//  Created by Cristian Bica on 03/04/15.
//
//

#import "NSObject+JobKit.h"
#import "JKInvocationJob.h"
#import "JobKit.h"

@implementation NSObject (JobKit)

+ (JKJob *)jk_performLater:(SEL)selector arguments:(NSArray *)arguments {
  JKInvocationJob *job = [JKInvocationJob jobWithClass:self selector:selector arguments:arguments];
  [JobKit enqueueJob:job];
  return job;
}

- (JKJob *)jk_performLater:(SEL)selector arguments:(NSArray *)arguments {
  if (![self conformsToProtocol:@protocol(NSCoding)]) {
    [NSException raise:NSInternalInconsistencyException
                format:@"You are trying to enqueue a job with JobKit for an instance of class "
     "but this class (%@) does not conforms to the NSCoding protocol which "
     "is needed to serialize/deserialize your instance",
     NSStringFromClass([self class])];
  }
  JKInvocationJob *job = [JKInvocationJob jobWithObject:self selector:selector arguments:arguments];
  [JobKit enqueueJob:job];
  return job;
}

@end
