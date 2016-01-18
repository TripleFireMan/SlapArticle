//
//  ITTMappingManager.h
//  iTotemMinFramework
//
//  Created by Sword on 10/24/14.
//
//

#import <Foundation/Foundation.h>

@class ITTMappingResult;
@class ITTObjectMapping;

@interface ITTMappingManager : NSObject

+ (ITTMappingManager*)sharedManager;

/*!
 * @param sourceData An json-formated object of NSArray or NSDictionary type
 * @param objectMapping The mapping being used to parse data
 * @param keyPath A key path specifying the subset of the parsed response for which the mapping is to be used. Such as result/cities
 * @param completionBlock A completion callback handler
 */
- (void)mapWithSourceData:(id)sourceData
            objectMapping:(ITTObjectMapping*)objectMapping
                  keyPath:(NSString*)keyPath
          completionBlock:(void(^)(ITTMappingResult *result, NSError *error))completionBlock;

@end
