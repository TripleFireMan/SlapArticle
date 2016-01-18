//
//  ISSObjectMapping.m
//  iTotemMinFramework
//
//  Created by Sword on 10/22/14.
//
//

#import "ITTObjectMapping.h"
#import "ITTPropertyMapping.h"

@interface ITTObjectMapping()
{
    NSMutableDictionary *_propertyMappingsDic;
}
@end

@implementation ITTObjectMapping

+ (instancetype)mappingFromClass:(Class)cls
{
    return [[self alloc] initWithClass:cls];
}

- (instancetype)initWithClass:(Class)cls
{
    self = [super init];
    if (self) {
        _objectClass = cls;
        _mappings = [[NSMutableArray alloc] init];
        _propertyMappingsDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addPropertyMappingsFromDictionary:(NSDictionary*)mappingDictionary
{
    ITTPropertyMapping *propertyMapping = nil;
    for (NSString *key in mappingDictionary) {
        id object = mappingDictionary[key];
         if ([object isKindOfClass:[NSNumber class]]) {
            propertyMapping = [ITTPropertyMapping propertyMapping:key propertyName:mappingDictionary[key] propertyObjectClass:[NSNumber class]];
        }
        else if([object isKindOfClass:[NSValue class]]) {
            propertyMapping = [ITTPropertyMapping propertyMapping:key propertyName:mappingDictionary[key] propertyObjectClass:[NSValue class]];
        }
        else if([object isKindOfClass:[NSString class]]) {
            propertyMapping = [ITTPropertyMapping propertyMapping:key propertyName:mappingDictionary[key] propertyObjectClass:[NSString class]];
        }
        else {
            NSAssert(TRUE, @"unsupported property type");
        }
        if (propertyMapping) {
            [_mappings addObject:propertyMapping];
            _propertyMappingsDic[propertyMapping.sourceName] = propertyMapping;
        }
    }
}

- (void)addPropertyMapping:(ITTObjectMapping*)objectMapping fromKey:(NSString*)from toKey:(NSString*)to
{
    NSAssert(objectMapping, @"nil object mapping");
    NSAssert(from, @"nil from key");
    NSAssert(to, @"nil to key");
    
    ITTPropertyMapping *propertyMapping = [ITTPropertyMapping propertyMapping:from propertyName:to propertyObjectClass:[objectMapping class]];
    propertyMapping.objectMapping = objectMapping;
    [_mappings addObject:propertyMapping];
    _propertyMappingsDic[propertyMapping.sourceName] = propertyMapping;
}

- (ITTPropertyMapping*)propertyMappingForSourceName:(NSString*)sourceName
{
    if (sourceName && [sourceName length]) {
        return _propertyMappingsDic[sourceName];
    }
    return nil;
}
@end
