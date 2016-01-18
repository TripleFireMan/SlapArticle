//
//  ITTPropertyMapping.m
//  iTotemMinFramework
//
//  Created by Sword on 10/23/14.
//
//

#import "ITTPropertyMapping.h"
#import "ITTObjectMapping.h"

@implementation ITTPropertyMapping

+ (ITTPropertyMapping*)propertyMapping:(NSString*)sourceName propertyName:(NSString*)propertyName
{
    return [ITTPropertyMapping propertyMapping:sourceName propertyName:propertyName propertyObjectClass:nil];
}

+ (ITTPropertyMapping*)propertyMapping:(NSString*)sourceName propertyName:(NSString*)propertyName propertyObjectClass:(Class)cls
{
    NSAssert(sourceName, @"nil sourceName");
    NSAssert(propertyName, @"nil propertyName");
    NSAssert([sourceName length], @"empty sourceName");
    NSAssert([propertyName length], @"empty propertyName with field %@", sourceName);
    
    ITTPropertyMapping *propertyMapping = [[ITTPropertyMapping alloc] init];
    propertyMapping.sourceName = sourceName;
    propertyMapping.propertyName = propertyName;
    propertyMapping.propertyObjectClass = cls;
    return propertyMapping;
}

- (BOOL)isObjectProperty
{
    return [self.propertyObjectClass isSubclassOfClass:[ITTObjectMapping class]];
}

@end
