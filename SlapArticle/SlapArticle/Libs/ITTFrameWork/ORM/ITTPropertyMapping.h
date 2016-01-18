//
//  ITTPropertyMapping.h
//  iTotemMinFramework
//
//  Created by Sword on 10/23/14.
//
//

#import "ITTMapping.h"

@class ITTObjectMapping;

@interface ITTPropertyMapping : ITTMapping

@property (nonatomic, strong) ITTObjectMapping *objectMapping;
@property (nonatomic, strong) Class propertyObjectClass;
@property (nonatomic, copy) NSString *sourceName;
@property (nonatomic, copy) NSString *propertyName;

+ (ITTPropertyMapping*)propertyMapping:(NSString*)sourceName propertyName:(NSString*)propertyName;
+ (ITTPropertyMapping*)propertyMapping:(NSString*)sourceName propertyName:(NSString*)propertyName propertyObjectClass:(Class)cls;

/*! Returns a BOOL value indicates whether the value of property is object or system type.
 * system type includes in (NSString, NSNumber, NSValue, NSInteger, CGFloat)
 *
 */
- (BOOL)isObjectProperty;

@end
