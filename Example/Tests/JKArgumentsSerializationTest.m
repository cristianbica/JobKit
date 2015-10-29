//
//  JKArgumentsSerializationTest.m
//  JobKit
//
//  Created by Cristian Bica on 09/04/15.
//  Copyright (c) 2015 Cristian Bica. All rights reserved.
//

#import <Specta/Specta.h>
#import <JobKit/JobKit.h>
#import "JKTestJob.h"
#import "JKTestClass.h"
#import <JobKit/JKMemoryAdapter.h>
#import <JobKit/JKRealmAdapter.h>



SpecBegin(Arguments)

sharedExamplesFor(@"serialization and deserialization", ^(NSDictionary *data) {
  
  
  describe(@"JKJob subclass", ^{
    it(@"works with no args 1", ^{
      expect(^{
        [JKTestJob performLater:nil];
      }).will.notify([NSNotification notificationWithName:@"JKTestJobExecuted"
                                                   object:nil
                                                 userInfo:@{@"arguments" : @[]}]);
    });
    
    it(@"works with no args 2", ^{
      expect(^{
        [JKTestJob performLater:@[]];
      }).will.notify([NSNotification notificationWithName:@"JKTestJobExecuted"
                                                   object:nil
                                                 userInfo:@{@"arguments" : @[]}]);
    });
    
    it(@"works with single arg", ^{
      expect(^{
        [JKTestJob performLater:@[@1]];
      }).will.notify([NSNotification notificationWithName:@"JKTestJobExecuted"
                                                   object:nil
                                                 userInfo:@{@"arguments" : @[@1]}]);
    });
    
    it(@"works with nested arguments", ^{
      expect(^{
        [JKTestJob performLater:@[@1, @"1", @[@1], @{@(1) : @"1"}]];
      }).will.notify([NSNotification notificationWithName:@"JKTestJobExecuted"
                                                   object:nil
                                                 userInfo:@{@"arguments" : @[@1, @"1", @[@1], @{@(1) : @"1"}]}]);
    });
    
    it(@"should fail with non-serializable args", ^{
      expect(^{
        [JKTestJob performLater:@[[NSObject new]]];
      }).to.raise(@"NSInternalInconsistencyException");
    });
  });

  
  describe(@"Object class method", ^{
    it(@"works with no args", ^{
      expect(^{
        [JKTestClass jk_performLater:@selector(aClassMethod) arguments:nil];
      }).will.notify(@"JKTestClassClassMethodExecuted");
    });

    it(@"works with one args", ^{
      expect(^{
        [JKTestClass jk_performLater:@selector(aClassMethodWithArgument:) arguments:@[@(1)]];
      }).will.notify([NSNotification notificationWithName:@"JKTestClassClassMethodExecuted"
                                                   object:nil
                                                 userInfo:@{@"arg" : @(1)}]);
    });

    it(@"works with two args", ^{
      expect(^{
        [JKTestClass jk_performLater:@selector(aClassMethodWithArgument:andAnotherArgument:) arguments:@[@(1), @"2"]];
      }).will.notify([NSNotification notificationWithName:@"JKTestClassClassMethodExecuted"
                                                   object:nil
                                                 userInfo:@{@"arg1" : @(1), @"arg2" : @"2"}]);
    });
  });

  
  describe(@"Object instance method", ^{
    it(@"works with no args 1", ^{
      expect(^{
        JKTestClass *obj = [[JKTestClass alloc] init];
        obj.var = @"X";
        [obj jk_performLater:@selector(anInstanceMethod) arguments:nil];
      }).will.notify([NSNotification notificationWithName:@"JKTestClassInstanceMethodExecuted"
                                                   object:nil
                                                 userInfo:@{@"var" : @"X"}]);
    });
    
    it(@"works with no args 2", ^{
      expect(^{
        JKTestClass *obj = [[JKTestClass alloc] init];
        obj.var = @"X";
        [obj jk_performLater:@selector(anInstanceMethod) arguments:@[]];
      }).will.notify([NSNotification notificationWithName:@"JKTestClassInstanceMethodExecuted"
                                                   object:nil
                                                 userInfo:@{@"var" : @"X"}]);
    });
    
    it(@"works with one arg", ^{
      expect(^{
        JKTestClass *obj = [[JKTestClass alloc] init];
        obj.var = @"X";
        [obj jk_performLater:@selector(anInstanceMethodWithArgument:) arguments:@[@(1)]];
      }).will.notify([NSNotification notificationWithName:@"JKTestClassInstanceMethodExecuted"
                                                   object:nil
                                                 userInfo:@{@"var" : @"X", @"arg" : @(1)}]);
    });

    it(@"works with two args", ^{
      expect(^{
        JKTestClass *obj = [[JKTestClass alloc] init];
        obj.var = @"X";
        [obj jk_performLater:@selector(anInstanceMethodWithArgument:andAnotherArgument:) arguments:@[@(1), @"2"]];
      }).will.notify([NSNotification notificationWithName:@"JKTestClassInstanceMethodExecuted"
                                                   object:nil
                                                 userInfo:@{@"var" : @"X", @"arg1" : @(1), @"arg2" : @"2"}]);
    });

    it(@"should fail with non-serializable args", ^{
      expect(^{
        JKTestClass *obj = [[JKTestClass alloc] init];
        [obj jk_performLater:@selector(anInstanceMethodWithArgument:) arguments:@[[NSObject new]]];
      }).to.raise(@"NSInternalInconsistencyException");
    });

    it(@"should fail with non-serializable object", ^{
      expect(^{
        [[NSObject new] jk_performLater:@selector(description) arguments:nil];
      }).to.raise(@"NSInternalInconsistencyException");
    });
  });
});


describe(@"Memory adapter", ^{
  beforeAll(^{
    [JobKit setupDefaultManagerWithStorageProvider:[JKMemoryAdapter class]];
    [JobKit defaultManager].tickInterval = .5;
  });
  beforeEach(^{
    [[JobKit defaultManager] start];
  });
  afterEach(^{
    [[JobKit defaultManager] stopAndCancelCurrentJobs];
  });
  afterAll(^{
    [JobKit setDefaultManager:nil];
  });
  
  itShouldBehaveLike(@"serialization and deserialization", @{});
});


describe(@"Realm adapter", ^{
  beforeAll(^{
    [JobKit setupDefaultManagerWithStorageProvider:[JKRealmAdapter class]];
    [JobKit defaultManager].tickInterval = .5;
  });
  beforeEach(^{
    [[JobKit defaultManager] start];
  });
  afterEach(^{
    [[JobKit defaultManager] stopAndCancelCurrentJobs];
  });
  afterAll(^{
    [JobKit setDefaultManager:nil];
  });
  
  itShouldBehaveLike(@"serialization and deserialization", @{});
});


describe(@"CoreData adapter", ^{
  beforeAll(^{
    [JobKit setupDefaultManagerWithStorageProvider:[JKRealmAdapter class]];
    [JobKit defaultManager].tickInterval = .5;
  });
  beforeEach(^{
    [[JobKit defaultManager] start];
  });
  afterEach(^{
    [[JobKit defaultManager] stopAndCancelCurrentJobs];
  });
  afterAll(^{
    [JobKit setDefaultManager:nil];
  });
  
  itShouldBehaveLike(@"serialization and deserialization", @{});
});

SpecEnd
