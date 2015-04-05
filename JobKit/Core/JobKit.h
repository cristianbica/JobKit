//
//  JobKit.h
//  Pods
//
//  Created by Cristian Bica on 02/04/15.
//
//

#import <Foundation/Foundation.h>
#import "JKStorageAdapter.h"
#import "JKJob.h"
#import "NSObject+JobKit.h"
#import "Macros.h"

@interface JobKit : NSObject

@property (nonatomic) NSTimeInterval tickInterval;
@property (nonatomic) NSUInteger concurrentJobsLimit;

/**
 Retuns a new JobKit manager instance.
 
 @param storageProviderClass A class conforming to the JKStorageAdapter. The manager will call [[storageProviderClass alloc] init] on the class.
 @param numberOfWorkers Number of workers to start.
 */
- (instancetype)initWithStorageProvider:(Class)storageProviderClass NS_DESIGNATED_INITIALIZER;

/**
 Sets the default manager with a JobKit manager instance configured with the provided parameters and returns it.
 
 @param storageProviderClass A class conforming to the JKStorageAdapter. The manager will call ]alloc init] on the class.
 @param numberOfWorkers Number of workers to start.
 */
+ (instancetype)setupDefaultManagerWithStorageProvider:(Class)storageProviderClass;

/**
 Returns the shared network reachability manager. If no default manager is set it will initialize one
 with 1 worker and using the Realm storage adapter.
 */
+ (JobKit *)defaultManager;

/**
 Sets the default manager.
 */
+ (void)setDefaultManager:(JobKit *)manager;

/**
 Starts the defaultManager to process jobs.
 */
+ (void)start;

/**
 Stops the defaultManager from processing jobs after finishing current jobs.
 */
+ (void)stop;

/**
 Cancels current runnning jobs stops the defaultManager form processing jobs.
 */
+ (void)stopAndCancelCurrentJobs;

/**
 Enqueues a job to be executed on the default manager.
 
 @param job A JKJob (or subclass) instance to be enqueued.
 @return An identifier that can be used to check the job status
 */
+ (void)enqueueJob:(JKJob *)job;


/**
 Starts the manager to process jobs.
 */
- (void)start;

/**
 Stops the manager from processing jobs after finishing current jobs.
 */
- (void)stop;

/**
 Cancels current runnning jobs stops the manager form processing jobs.
 */
- (void)stopAndCancelCurrentJobs;

/**
 Enqueues a job to be executed.
 
 @param job A JKJob (or subclass) instance to be enqueued.
 @return An identifier that can be used to check the job status
 */
- (void)enqueueJob:(JKJob *)job;

@end
