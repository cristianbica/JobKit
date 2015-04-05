//
//  JKJobKitTest.m
//  JobKit
//
//  Created by Cristian Bica on 03/04/15.
//  Copyright (c) 2015 Cristian Bica. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JobKit/JobKit.h>
#import <JobKit/JKTestAdapter.h>
#import "JKTestJob.h"
#import "JKTestClass.h"

@interface JKJobKitWithTestAdapterTest : XCTestCase
- (void)setupManager;
- (void)cleanupManager;
@end

@implementation JKJobKitWithTestAdapterTest

- (void)setUp {
  [super setUp];
  [self setupManager];
}

- (void)tearDown {
  [self cleanupManager];
  [super tearDown];
}

- (void)setupManager {
  [JobKit setupDefaultManagerWithStorageProvider:[JKTestAdapter class]];
  [JobKit defaultManager].tickInterval = .5;
  [JobKit start];
}

- (void)cleanupManager {
  [JobKit stopAndCancelCurrentJobs];
}

- (void)testRunningAJob {
  expect(^{
    [JKTestJob performLater:@[@1]];
  }).will.notify(@"JKTestJobExecuted");
}

- (void)testRunningAJobWithThePassedParams {
  expect(^{
    [JKTestJob performLater:@[@1, @"1", @[@1], @{@(1) : @"1"}]];
  }).will.notify([NSNotification notificationWithName:@"JKTestJobExecuted" object:nil userInfo:@{@"arguments" : @[@1, @"1", @[@1], @{@(1) : @"1"}]}]);
}

- (void)testRunningAJobWithoutParams {
  expect(^{
    [JKTestJob performLater:nil];
  }).will.notify([NSNotification notificationWithName:@"JKTestJobExecuted" object:nil userInfo:@{@"arguments" : @[]}]);
}

- (void)testRunningAJobWithoutParams2 {
  expect(^{
    [JKTestJob performLater:@[]];
  }).will.notify([NSNotification notificationWithName:@"JKTestJobExecuted" object:nil userInfo:@{@"arguments" : @[]}]);
}


- (void)testRunningAJobFromAPlainClassClassMethod {
  expect(^{
    [JKTestClass jk_performLater:@selector(aClassMethod) arguments:nil];
  }).will.notify(@"JKTestClassClassMethodExecuted");
}

- (void)testRunningAJobFromAPlainClassClassMethod2 {
  expect(^{
    [JKTestClass jk_performLater:@selector(aClassMethod) arguments:@[]];
  }).will.notify(@"JKTestClassClassMethodExecuted");
}

- (void)testRunningAJobFromAPlainClassClassMethodWithOneArg {
  expect(^{
    [JKTestClass jk_performLater:@selector(aClassMethodWithArgument:) arguments:@[@(1)]];
  }).will.notify([NSNotification notificationWithName:@"JKTestClassClassMethodExecuted" object:nil userInfo:@{@"arg" : @(1)}]);
}

- (void)testRunningAJobFromAPlainClassClassMethodWithTwoArgs {
  expect(^{
    [JKTestClass jk_performLater:@selector(aClassMethodWithArgument:andAnotherArgument:) arguments:@[@(1), @"2"]];
  }).will.notify([NSNotification notificationWithName:@"JKTestClassClassMethodExecuted" object:nil userInfo:@{@"arg1" : @(1), @"arg2" : @"2"}]);
}


- (void)testRunningAJobFromAPlainClassInstanceMethod {
  expect(^{
    JKTestClass *obj = [[JKTestClass alloc] init];
    obj.var = @"X";
    [obj jk_performLater:@selector(anInstanceMethod) arguments:nil];
  }).will.notify([NSNotification notificationWithName:@"JKTestClassInstanceMethodExecuted" object:nil userInfo:@{@"var" : @"X"}]);
}

- (void)testRunningAJobFromAPlainClassInstanceMethod2 {
  expect(^{
    JKTestClass *obj = [[JKTestClass alloc] init];
    obj.var = @"X";
    [obj jk_performLater:@selector(anInstanceMethod) arguments:@[]];
  }).will.notify([NSNotification notificationWithName:@"JKTestClassInstanceMethodExecuted" object:nil userInfo:@{@"var" : @"X"}]);
}

- (void)testRunningAJobFromAPlainClassInstanceMethodWithOneArg {
  expect(^{
    JKTestClass *obj = [[JKTestClass alloc] init];
    obj.var = @"X";
    [obj jk_performLater:@selector(anInstanceMethodWithArgument:) arguments:@[@(1)]];
  }).will.notify([NSNotification notificationWithName:@"JKTestClassInstanceMethodExecuted" object:nil userInfo:@{@"var" : @"X", @"arg" : @(1)}]);
}


@end
