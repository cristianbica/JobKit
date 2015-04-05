//
//  JKTestJob.m
//  JobKit
//
//  Created by Cristian Bica on 03/04/15.
//  Copyright (c) 2015 Cristian Bica. All rights reserved.
//

#import "JKTestJob.h"

@implementation JKTestJob

- (void)perform {
  NSLog(@"Posting notification JKTestJobExecuted with arguments: %@", self.arguments);
  [[NSNotificationCenter defaultCenter] postNotificationName:@"JKTestJobExecuted"
                                                      object:nil
                                                    userInfo:@{@"arguments" : self.arguments}];
}
@end
