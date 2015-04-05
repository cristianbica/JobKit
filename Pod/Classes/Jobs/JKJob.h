//
//  JKJob.h
//  Pods
//
//  Created by Cristian Bica on 03/04/15.
//
//

#import <Foundation/Foundation.h>

@interface JKJob : NSObject<NSCoding>

@property (strong) NSString *identifier;
@property (strong) NSArray *arguments;

- (void)perform;

+ (JKJob *)performLater:(NSArray *)arguments;

@end
