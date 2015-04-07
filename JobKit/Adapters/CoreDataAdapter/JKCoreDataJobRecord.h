//
//  JKCoreDataJobRecord.h
//  Pods
//
//  Created by Cristian Bica on 06/04/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JKJob;

@interface JKCoreDataJobRecord : NSManagedObject

@property (nonatomic, retain) NSDate * enqueuedAt;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSData * jobData;
@property (nonatomic, retain) NSString * jobIdentifier;
@property (nonatomic, retain) NSNumber * locked;
@property (nonatomic, retain) NSDate * lockedAt;


+ (instancetype)createRecordFromJob:(JKJob *)job inContext:(NSManagedObjectContext *)context;
- (JKJob *)job;

@end
