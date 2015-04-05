//
//  JKStorageAdapter.h
//  Pods
//
//  Created by Cristian Bica on 02/04/15.
//
//

#import "JKJob.h"

typedef void (^JKStorageAdapterNotificationBlock)();

@protocol JKStorageAdapter <NSObject>

@required
- (id)pushJob:(JKJob *)job;
- (JKJob *)popJob;
- (JKJob *)peek;
- (NSArray *)peek:(NSUInteger)count;
- (BOOL)hasJobs;
@end