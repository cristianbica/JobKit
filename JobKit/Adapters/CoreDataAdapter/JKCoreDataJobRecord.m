//
//  JKCoreDataJobRecord.m
//  Pods
//
//  Created by Cristian Bica on 06/04/15.
//
//

#import "JKCoreDataJobRecord.h"
#import "JKJob.h"

@implementation JKCoreDataJobRecord

@dynamic enqueuedAt;
@dynamic guid;
@dynamic jobData;
@dynamic jobIdentifier;
@dynamic locked;
@dynamic lockedAt;


+ (instancetype)createRecordFromJob:(JKJob *)job inContext:(NSManagedObjectContext *)context {
  __block JKCoreDataJobRecord *record;
  [context performBlockAndWait:^{
    record = [NSEntityDescription insertNewObjectForEntityForName:@"JKCoreDataJobRecord"
                                           inManagedObjectContext:context];
    record.jobIdentifier = job.identifier;
    record.jobData = [NSKeyedArchiver archivedDataWithRootObject:job];
    record.guid = [NSUUID UUID].UUIDString;
    record.enqueuedAt = [NSDate date];
    record.locked = @(NO);
    record.lockedAt = [NSDate distantPast];
  }];
  return record;
}

- (JKJob *)job {
  JKJob *job = [NSKeyedUnarchiver unarchiveObjectWithData:self.jobData];
  return job;
}

@end
