//
//  ITTObjectDataSource.h
//  iTotemMinFramework
//
//  Created by Sword on 10/24/14.
//
//

#import <Foundation/Foundation.h>

@interface ITTObjectDataSource : NSObject

@property (nonatomic, readonly) NSString *keyPath;
@property (nonatomic, readonly) NSDictionary *dictionary;
@property (nonatomic, readonly) NSDictionary *rawDictionary;

- (instancetype)initWithSourceDictionary:(NSDictionary*)dictionary keyPath:(NSString*)keyPath;

- (id)valueForKey:(NSString *)key;
- (id)valueForKeyPath:(NSString *)keyPath;
- (void)replaceObject:(NSString *)key object:(id)object;
- (void)replaceObjectAtKeyPath:(NSString *)keyPath object:(id)object;

@end
