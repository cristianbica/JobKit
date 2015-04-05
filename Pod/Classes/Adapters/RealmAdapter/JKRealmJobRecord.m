//
//  JKJobRecord.m
//  Pods
//
//  Created by Cristian Bica on 02/04/15.
//
//

#import "JKRealmJobRecord.h"

@implementation JKRealmJobRecord

+ (NSString *)primaryKey {
  return @"guid";
}
+ (NSDictionary *)defaultPropertyValues {
  return @{
           @"guid" : [NSUUID UUID].UUIDString,
           @"enqueuedAt" : [NSDate date],
           @"locked" :     @(NO),
           @"lockedAt":    [NSDate distantPast]
           };
}

+ (JKRealmJobRecord *)recordFromJob:(JKJob *)job {
  JKRealmJobRecord *record = [[self alloc] init];
  record.jobIdentifier = job.identifier;
  record.jobData = [NSKeyedArchiver archivedDataWithRootObject:job];
  return record;
}

- (JKJob *)job {
  JKJob *job = [NSKeyedUnarchiver unarchiveObjectWithData:self.jobData];
  return job;
}

@end
