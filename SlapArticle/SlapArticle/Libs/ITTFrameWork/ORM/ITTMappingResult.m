//
//  ISSMappingResult.m
//  iTotemMinFramework
//
//  Created by Sword on 10/22/14.
//
//

#import "ITTMappingResult.h"
#import "ITTObjectDataSource.h"
#import "ITTRequestResult.h"

@interface ITTMappingResult()
{
    ITTRequestResult    *_responseResult;
    ITTObjectDataSource *_dataSource;
}
@end

@implementation ITTMappingResult

- (instancetype)intWithDataSource:(ITTObjectDataSource*)dataSource
{
    if (self) {
        _dataSource = dataSource;
        _responseResult = [[ITTRequestResult alloc] initWithCode:dataSource.rawDictionary[@"state"] withMessage:dataSource.rawDictionary[@"message"]];
    }
    return self;
}

- (NSArray*)array
{
    NSMutableArray *collection = nil;
    id object = [_dataSource valueForKeyPath:_dataSource.keyPath];
    if (object) {
        collection = [[NSMutableArray alloc] init];
        if([object isKindOfClass:[NSArray class]]) {
            [collection addObjectsFromArray:object];
        }
        else {
            [collection addObject:object];
        }
    }
    return collection;
}

- (NSDictionary*)dictionary
{
    return _dataSource.dictionary;
}

- (NSDictionary*)rawDictionary
{
    return _dataSource.rawDictionary;
}

- (BOOL)isSuccess
{
    return [_responseResult isSuccess];
}

- (NSString *)message{
    return [_responseResult message];
}

- (id)valueForKeyPath:(NSString *)keyPath
{
    return [_dataSource valueForKeyPath:keyPath];
}

- (void)replaceObjectAtKey:(NSString*)key object:(id)object
{
    [_dataSource replaceObjectAtKeyPath:key object:object];
}

- (void)replaceObjectAtKeyPath:(NSString*)keyPath object:(id)object
{
    [_dataSource replaceObjectAtKeyPath:keyPath object:object];
}
@end
