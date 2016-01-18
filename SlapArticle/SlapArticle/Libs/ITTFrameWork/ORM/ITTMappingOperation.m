//
//  ITTMappingOperation.m
//  iTotemMinFramework
//
//  Created by Sword on 10/24/14.
//
//

#import "ITTMappingOperation.h"
#import "ITTObjectDataSource.h"
#import "ITTObjectMapping.h"
#import "ITTPropertyMapping.h"
#import "ITTMappingResult.h"
#import "ITTMappingUtilities.h"
#import "ITTMappingConsts.h"

@interface ITTMappingOperation()
{
    BOOL                _errorOccured;
    NSError             *_error;
    NSString            *_keyPath;
    ITTObjectDataSource *_dataSource;
    ITTObjectMapping    *_objectMapping;
    
    void(^_complectionBlock)(ITTMappingResult *result, NSError *error);
}
@end

@implementation ITTMappingOperation

- (void)dealloc
{
    _error = nil;
    _keyPath = nil;
    _dataSource = nil;
    _objectMapping = nil;
    _complectionBlock = nil;
}

- (instancetype)initWithObjectDataSource:(ITTObjectDataSource*)dataSource
                           objectMapping:(ITTObjectMapping*)objectMapping
                                 keyPath:(NSString*)keyPath
                         completionBlock:(void(^)(ITTMappingResult *result, NSError *error))completionBlock
{
    self = [super init];
    if (self) {
        _errorOccured = FALSE;
        _objectMapping = objectMapping;
        _dataSource = dataSource;
        _keyPath = keyPath;
        _complectionBlock = completionBlock;
    }
    return self;
}

- (void)main
{
    ITTMappingResult *mappingResult = nil;
    if (_objectMapping) {
        NSDate *beginDate = [NSDate date];
        id source = [_dataSource valueForKeyPath:_keyPath];
        NSAssert(!([source isKindOfClass:[NSArray class]] && [source[0] isKindOfClass:[NSNull class]]),  @"can not get value at key %@", _keyPath);
        NSAssert(source != nil, @"can not get value at key %@", _keyPath);
        NSAssert(![source isKindOfClass:[NSNull class]], @"can not get value at key %@", _keyPath);
        
        id mappedObject = [self map:source mapping:_objectMapping];
        if (_errorOccured || _error) {
            _complectionBlock(mappingResult, _error);
        }
        else {
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:beginDate];
            [_dataSource replaceObjectAtKeyPath:_keyPath object:mappedObject];
            mappingResult = [[ITTMappingResult alloc] intWithDataSource:_dataSource];
//            ITTDINFO(@"total time of parse process is %lf seconds", interval);
            _complectionBlock(mappingResult, _error);
        }
    }
    else {
        mappingResult = [[ITTMappingResult alloc] intWithDataSource:_dataSource];
        _complectionBlock(mappingResult, _error);
    }
}

- (id)map:(id)source mapping:(ITTObjectMapping*)objectMapping
{
    if ([source isKindOfClass:[NSArray class]]) {
        return [self mappedObjectFromArray:source withMapping:objectMapping];
    }
    else if ([source isKindOfClass:[NSDictionary class]]) {
        return [self mappedObjectFromDictionary:source withMapping:objectMapping];
    }
    else {
        NSAssert(TRUE, @"invalid source data");
        return nil;
    }
}

- (id)mappedObjectFromArray:(id)source withMapping:(ITTObjectMapping*)objectMapping
{
    if (_errorOccured) {
        return nil;
    }
    @try {
        NSAssert([source isKindOfClass:[NSArray class]], @"source is not array type");
        NSMutableArray *destinationObjects = [[NSMutableArray alloc] init];
        for (id sourceObjectValue in source) {
            if ([sourceObjectValue isKindOfClass:[NSDictionary class]]) {
                id destinationObjectValue = [self mappedObjectFromDictionary:sourceObjectValue withMapping:objectMapping];
                if (destinationObjectValue) {
                    [destinationObjects addObject:destinationObjectValue];
                }
            }
            else if([sourceObjectValue isKindOfClass:[NSArray class]]) {
                id destinationObjectValue = [self mappedObjectFromArray:sourceObjectValue withMapping:objectMapping];
                if (destinationObjectValue) {
                    if ([destinationObjectValue isKindOfClass:[NSArray class]]) {
                        [destinationObjects addObjectsFromArray:destinationObjectValue];
                    }
                    else {
                        [destinationObjects addObject:destinationObjectValue];
                    }
                }
            }
            else {
                [destinationObjects addObject:sourceObjectValue];
            }
        }
        return destinationObjects;
    }
    @catch (NSException *exception) {
        _errorOccured = TRUE;
        _error = [NSError errorWithDomain:exception.name code:ITTMappingErrorTypeMismatch userInfo:@{@"reason":exception.reason}];
        return nil;
    }
    @finally {
    }
}

- (id)mappedObjectFromDictionary:(id)source withMapping:(ITTObjectMapping*)objectMapping
{
    if (_errorOccured) {
        return nil;
    }
    @try {
        NSAssert([source isKindOfClass:[NSDictionary class]], @"source is not dictionary type");
        id destinationObject = [objectMapping.objectClass new];
        for (NSString *sourceName in source) {
            ITTPropertyMapping *propertyMapping = [objectMapping propertyMappingForSourceName:sourceName];
            if (propertyMapping) {
                if ([propertyMapping isObjectProperty]) {
                    id propertyObjectValue = [self map:[source valueForKey:sourceName] mapping:propertyMapping.objectMapping];
                    CheckTypeMatching(&propertyObjectValue, objectMapping.objectClass, propertyMapping);
                    [destinationObject setValue:propertyObjectValue forKey:propertyMapping.propertyName];
                }
                else {
                    id sourceObjectValue = [source valueForKey:sourceName];
                    CheckTypeMatching(&sourceObjectValue, objectMapping.objectClass, propertyMapping);
                    [destinationObject setValue:sourceObjectValue forKey:propertyMapping.propertyName];
                }
            }
        }
        return destinationObject;
    }
    @catch (NSException *exception) {
        _errorOccured = TRUE;
        _error = [NSError errorWithDomain:exception.name code:ITTMappingErrorTypeMismatch userInfo:@{@"reason":exception.reason}];
       return nil;
    }
    @finally {
    }

}

@end
