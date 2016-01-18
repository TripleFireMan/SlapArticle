//
//  ITTMappingOperation.h
//  iTotemMinFramework
//
//  Created by Sword on 10/24/14.
//
//

#import <Foundation/Foundation.h>

@class ITTObjectDataSource;
@class ITTObjectMapping;
@class ITTMappingResult;

@interface ITTMappingOperation : NSOperation

- (instancetype)initWithObjectDataSource:(ITTObjectDataSource*)dataSource
                           objectMapping:(ITTObjectMapping*)objectMapping
                                 keyPath:(NSString*)keyPath
                         completionBlock:(void(^)(ITTMappingResult *result, NSError *error))completionBlock;

@end
