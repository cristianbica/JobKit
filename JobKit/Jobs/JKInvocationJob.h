//
//  JKInvocationJob.h
//  Pods
//
//  Created by Cristian Bica on 03/04/15.
//
//

#import <Foundation/Foundation.h>
#import "JKJob.h"

@interface JKInvocationJob : JKJob

+ (instancetype)jobWithClass:(Class)klass selector:(SEL)selector arguments:(NSArray *)arguments;
+ (instancetype)jobWithObject:(id)object selector:(SEL)selector arguments:(NSArray *)arguments;


@end
