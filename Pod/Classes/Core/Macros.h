//
//  Macros.h
//  Pods
//
//  Created by Cristian Bica on 02/04/15.
//
//


#ifndef JK_NSCODING_MIXIN
#define JK_NSCODING_MIXIN \
- (id)initWithCoder:(NSCoder *)aDecoder { \
self = [super init]; \
if( self ) \
{ \
Class currentClass = [self class]; \
do { \
unsigned count; \
objc_property_t *properties = class_copyPropertyList(currentClass, &count); \
unsigned i; \
for (i = 0; i < count; i++) \
{ \
objc_property_t property = properties[i]; \
NSString *name = [NSString stringWithUTF8String:property_getName(property)]; \
@try { \
if([aDecoder decodeObjectForKey:name]){ \
[self setValue:[aDecoder decodeObjectForKey:name] forKey:name]; \
} \
} \
@catch (NSException *exception) { \
NSLog(@"%@", exception); \
} \
\
} \
free(properties); \
currentClass = [currentClass superclass]; \
} while ([currentClass superclass]); \
} \
return self; \
} \
- (void)encodeWithCoder:(NSCoder *)encoder { \
Class currentClass = [self class]; \
do { \
unsigned count; \
objc_property_t *properties = class_copyPropertyList(currentClass, &count); \
unsigned i; \
for (i = 0; i < count; i++) { \
objc_property_t property = properties[i]; \
NSString *name = [NSString stringWithUTF8String:property_getName(property)]; \
[encoder encodeObject:[self valueForKey:name] forKey:name]; \
} \
free(properties); \
currentClass = [currentClass superclass]; \
} while ([currentClass superclass]); \
}
#endif