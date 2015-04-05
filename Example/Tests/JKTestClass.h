//
//  JKTestClass.h
//  JobKit
//
//  Created by Cristian Bica on 03/04/15.
//  Copyright (c) 2015 Cristian Bica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKTestClass : NSObject <NSCoding>
@property (strong) id var;

+ (void)aClassMethod;
+ (void)aClassMethodWithArgument:(id)arg;
+ (void)aClassMethodWithArgument:(id)arg1 andAnotherArgument:(id)arg2;
- (void)anInstanceMethod;
- (void)anInstanceMethodWithArgument:(id)arg;
- (void)anInstanceMethodWithArgument:(id)arg1 andAnotherArgument:(id)arg2;

@end
