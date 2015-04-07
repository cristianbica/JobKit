//
//  JKCoreDataAdapter.h
//  Pods
//
//  Created by Cristian Bica on 06/04/15.
//
//

#import <Foundation/Foundation.h>
#import "JKStorageAdapter.h"

@interface JKCoreDataAdapter : NSObject <JKStorageAdapter>

- (void)cleanUp;

@end
