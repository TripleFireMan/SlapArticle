//
//  ISSMappingResult.h
//  iTotemMinFramework
//
//  Created by Sword on 10/22/14.
//
//

#import <Foundation/Foundation.h>

@class ITTObjectDataSource;

@interface ITTMappingResult : NSObject

- (instancetype)intWithDataSource:(ITTObjectDataSource*)dataSource;

- (BOOL)isSuccess;
- (NSString *)message;
- (NSArray*)array;
- (NSDictionary*)dictionary;
- (NSDictionary*)rawDictionary;
- (id)valueForKeyPath:(NSString *)keyPath;
- (void)replaceObjectAtKey:(NSString*)key object:(id)object;
- (void)replaceObjectAtKeyPath:(NSString*)keyPath object:(id)object;

@end
