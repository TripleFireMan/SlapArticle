//
//  ISSObjectMapping.h
//  iTotemMinFramework
//
//  Created by Sword on 10/22/14.
//
//

#import "ITTMapping.h"

@class ITTPropertyMapping;

@interface ITTObjectMapping : ITTMapping

@property (nonatomic, strong) NSMutableArray *mappings;

@property (nonatomic, weak, readonly) Class objectClass;

+ (instancetype)mappingFromClass:(Class)cls;

- (instancetype)initWithClass:(Class)cls;

- (ITTPropertyMapping*)propertyMappingForSourceName:(NSString*)sourceName;

/*!
 * add property mapping from dictionary.
 * @param mappingDictionary Key-Value pair by data key name and property name.
 */
- (void)addPropertyMappingsFromDictionary:(NSDictionary*)mappingDictionary;

/*!
 * add sub property to object mapping
 * @param objectMapping The object mapping to be added
 * @param from The key of data
 * @param to property name of mapping class
 */
- (void)addPropertyMapping:(ITTObjectMapping*)objectMapping fromKey:(NSString*)from toKey:(NSString*)to;

@end
