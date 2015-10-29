//
//  JKInvocationJob.m
//  Pods
//
//  Created by Cristian Bica on 03/04/15.
//
//

#import "JKInvocationJob.h"

@implementation JKInvocationJob

+ (instancetype)jobWithClass:(Class)klass selector:(SEL)selector arguments:(NSArray *)arguments {
  NSArray *args = @[
                    @"class",
                    NSStringFromClass(klass),
                    NSStringFromSelector(selector),
                    arguments?:@[]
                    ];
  return (id)[self performLater:args];
}

+ (instancetype)jobWithObject:(id)object selector:(SEL)selector arguments:(NSArray *)arguments {
  NSArray *args = @[
                    @"object",
                    [NSKeyedArchiver archivedDataWithRootObject:object],
                    NSStringFromSelector(selector),
                    arguments?:@[]
                    ];
  return (id)[self performLater:args];
}

- (void)perform {
  if ([self.arguments[0] isEqualToString:@"class"]) {
    [self performForClass];
  } else if ([self.arguments[0] isEqualToString:@"object"]) {
    [self performForObject];
  } else {
    [NSException raise:NSInternalInconsistencyException
                format:@"Don't know how to handle invocation job for type: %@", self.arguments[0]];
  }
}

- (void)performForClass {
  Class klass = NSClassFromString(self.arguments[1]);
  SEL selector = NSSelectorFromString(self.arguments[2]);
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[klass methodSignatureForSelector:selector]];
  invocation.selector = selector;
  if (self.arguments[3] && [self.arguments isKindOfClass:[NSArray class]]) {
    [self.arguments[3] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      [invocation setArgument:&obj atIndex:idx+2];
    }];
  }
  [invocation invokeWithTarget:klass];
}

- (void)performForObject {
  id object = [NSKeyedUnarchiver unarchiveObjectWithData:self.arguments[1]];
  SEL selector = NSSelectorFromString(self.arguments[2]);
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:selector]];
  invocation.selector = selector;
  if (self.arguments[3] && [self.arguments isKindOfClass:[NSArray class]]) {
    [self.arguments[3] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      [invocation setArgument:&obj atIndex:idx+2];
    }];
  }
  [invocation invokeWithTarget:object];
}

@end
