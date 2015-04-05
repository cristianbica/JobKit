//
//  JKTestClass.m
//  JobKit
//
//  Created by Cristian Bica on 03/04/15.
//  Copyright (c) 2015 Cristian Bica. All rights reserved.
//

#import "JKTestClass.h"
#import <JobKit/JobKit.h>
#import <objc/runtime.h>

@implementation JKTestClass

+ (void)aClassMethod {
  NSLog(@"Posting notification JKTestClassClassMethodExecuted");
  [[NSNotificationCenter defaultCenter] postNotificationName:@"JKTestClassClassMethodExecuted"
                                                      object:nil
                                                    userInfo:nil];
}

+ (void)aClassMethodWithArgument:(id)arg {
  NSLog(@"Posting notification JKTestClassClassMethodExecuted with arguments: %@", @{@"arg" : arg});
  [[NSNotificationCenter defaultCenter] postNotificationName:@"JKTestClassClassMethodExecuted"
                                                      object:nil
                                                    userInfo:@{@"arg" : arg}];
}

+ (void)aClassMethodWithArgument:(id)arg1 andAnotherArgument:(id)arg2 {
  NSLog(@"Posting notification JKTestClassClassMethodExecuted with arguments: %@", @{@"arg1" : arg1, @"arg2" : arg2});
  [[NSNotificationCenter defaultCenter] postNotificationName:@"JKTestClassClassMethodExecuted"
                                                      object:nil
                                                    userInfo:@{@"arg1" : arg1, @"arg2" : arg2}];
}

- (void)anInstanceMethod {
  NSLog(@"Posting notification JKTestClassClassMethodExecuted with arguments: %@", @{@"var" : self.var});
  [[NSNotificationCenter defaultCenter] postNotificationName:@"JKTestClassInstanceMethodExecuted"
                                                      object:nil
                                                    userInfo:@{@"var" : self.var}];
}

- (void)anInstanceMethodWithArgument:(id)arg {
  NSLog(@"Posting notification JKTestClassClassMethodExecuted with arguments: %@", @{@"var" : self.var, @"arg" : arg});
  [[NSNotificationCenter defaultCenter] postNotificationName:@"JKTestClassInstanceMethodExecuted"
                                                      object:nil
                                                    userInfo:@{@"var" : self.var, @"arg" : arg}];
}

- (void)anInstanceMethodWithArgument:(id)arg1 andAnotherArgument:(id)arg2 {
  NSLog(@"Posting notification JKTestClassClassMethodExecuted with arguments: %@", @{@"var" : self.var, @"arg1" : arg1, @"arg2" : arg2});
  [[NSNotificationCenter defaultCenter] postNotificationName:@"JKTestClassInstanceMethodExecuted"
                                                      object:nil
                                                    userInfo:@{@"var" : self.var, @"arg1" : arg1, @"arg2" : arg2}];
}

JK_NSCODING_MIXIN
@end
