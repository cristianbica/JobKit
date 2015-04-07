//
//  JKJobRecord.h
//  Pods
//
//  Created by Cristian Bica on 02/04/15.
//
//

#import <Realm/RLMObject.h>
#import "JKJob.h"

@interface JKRealmJobRecord : RLMObject

@property NSString *guid;
@property NSString *jobIdentifier;
@property NSData *jobData;
@property NSDate *enqueuedAt;
@property BOOL locked;
@property NSDate *lockedAt;

+ (JKRealmJobRecord *)recordFromJob:(JKJob *)job;
- (JKJob *)job;

@end
