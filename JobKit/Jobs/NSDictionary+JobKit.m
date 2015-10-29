//
//  NSDictionary+JobKit.m
//  Pods
//
//  Created by Cristian Bica on 09/04/15.
//
//

#import "NSDictionary+JobKit.h"

@implementation NSDictionary (JobKit)

- (BOOL)jk_allConformsToProtocol:(Protocol *)protocol {
  __block BOOL conforms = YES;
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if ([obj respondsToSelector:@selector(jk_allConformsToProtocol:)]
        && ![obj jk_allConformsToProtocol:protocol]) {
      conforms = NO;
      *stop = YES;
    } else if (![obj conformsToProtocol:protocol]) {
      conforms = NO;
      *stop = YES;
    } else if ([key respondsToSelector:@selector(jk_allConformsToProtocol:)]
               && ![key jk_allConformsToProtocol:protocol]) {
      conforms = NO;
      *stop = YES;
    } else if (![key conformsToProtocol:protocol]) {
      conforms = NO;
      *stop = YES;
    }    
  }];
  return conforms;
  
}

@end
