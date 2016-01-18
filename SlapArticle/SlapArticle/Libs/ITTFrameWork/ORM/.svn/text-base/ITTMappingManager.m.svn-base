//
//  ITTMappingManager.m
//  iTotemMinFramework
//
//  Created by Sword on 10/24/14.
//
//

#import "ITTMappingManager.h"
#import "ITTObjectSingleton.h"
#import "ITTObjectDataSource.h"
#import "ITTMappingOperation.h"

#define ROOT_KEY        @"ROOT_KEY"

@interface ITTMappingManager()
{
    NSOperationQueue *_mappingOperationQueue;
}
@end

@implementation ITTMappingManager

ITTOBJECT_SINGLETON_BOILERPLATE(ITTMappingManager, sharedManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupQueue];
    }
    return self;
}


- (void)setupQueue
{
    _mappingOperationQueue = [[NSOperationQueue alloc] init];
    [_mappingOperationQueue setMaxConcurrentOperationCount:1];
}

- (void)mapWithSourceData:(id)sourceData
            objectMapping:(ITTObjectMapping*)objectMapping
                  keyPath:(NSString*)keyPath
          completionBlock:(void(^)(ITTMappingResult *result, NSError *error))completionBlock
{
    NSAssert([sourceData isKindOfClass:[NSDictionary class]] || [sourceData isKindOfClass:[NSArray class]], @"sourceData is not a dictionary or array!");
    
    if([sourceData isKindOfClass:[NSArray class]]) {
        keyPath = [NSString stringWithFormat:@"%@/%@", ROOT_KEY, keyPath];
        sourceData = @{ROOT_KEY:sourceData};
    }
    ITTObjectDataSource *dataSource = [[ITTObjectDataSource alloc] initWithSourceDictionary:sourceData keyPath:keyPath];
    ITTMappingOperation *mappingOperation = [[ITTMappingOperation alloc] initWithObjectDataSource:dataSource
                                                                                    objectMapping:objectMapping
                                                                                          keyPath:keyPath
                                                                                  completionBlock:completionBlock];
    [_mappingOperationQueue addOperation:mappingOperation];
}

@end
