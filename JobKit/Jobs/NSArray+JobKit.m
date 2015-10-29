//
//  NSArray+JobKit.m
//  Pods
//
//  Created by Cristian Bica on 09/04/15.
//
//

#import "NSArray+JobKit.h"

@implementation NSArray (JobKit)

- (BOOL)jk_allConformsToProtocol:(Protocol *)protocol {
  __block BOOL conforms = YES;
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if ([obj respondsToSelector:@selector(jk_allConformsToProtocol:)]
        && ![obj jk_allConformsToProtocol:protocol]) {
      conforms = NO;
      *stop = YES;
    } else if (![obj conformsToProtocol:protocol]) {
      conforms = NO;
      *stop = YES;
    }
  }];
  return conforms;
}

@end
