//
//  JKWorker.h
//  Pods
//
//  Created by Cristian Bica on 02/04/15.
//
//

#import <Foundation/Foundation.h>
#import "JKJob.h"

FOUNDATION_EXPORT NSString * JKWorkerJobWillStart;
FOUNDATION_EXPORT NSString * JKWorkerJobDidFinish;
FOUNDATION_EXPORT NSString * JKWorkerJobDidFail;
FOUNDATION_EXPORT NSString * JKWorkerJobDidSucceeded;


typedef NS_ENUM(NSUInteger, JKWorkerState) {
  JKWorkerStateIdle = 1,
  JKWorkerStateWorking
};

@class JobKit;


@interface JKWorker : NSOperationQueue

- (instancetype)initWithManager:(JobKit *)manager index:(NSUInteger)index;
- (void)executeJob:(JKJob *)job completion:(void (^)(BOOL success, NSException *exception))completion;

@end

