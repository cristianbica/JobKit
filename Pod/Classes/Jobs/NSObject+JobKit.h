//
//  NSObject+JobKit.h
//  Pods
//
//  Created by Cristian Bica on 03/04/15.
//
//

#import <Foundation/Foundation.h>
#import "JKJob.h"

@interface NSObject (JobKit)

+ (JKJob *)jk_performLater:(SEL)selector arguments:(NSArray *)arguments;
- (JKJob *)jk_performLater:(SEL)selector arguments:(NSArray *)arguments;

@end
