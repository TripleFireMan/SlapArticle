//
//  ITTORMUtilities.m
//  iTotemMinFramework
//
//  Created by Sword on 10/27/14.
//
//

#import "ITTMappingUtilities.h"
#import "ITTMappingConsts.h"
#import <objc/runtime.h>
#import "ITTPropertyMapping.h"
#import "ITTBaseModelObject.h"
#import "ITTObjectMapping.h"

NSString* propertyStringFromType(ITTORMPropertyType type)
{
    NSString *string = @"None";
    switch (type) {
        case ITTORMPropertyTypeInt:
            string = @"int";
            break;
        case ITTORMPropertyTypeNSInteger:
            string = @"NSInteger";
            break;
        case ITTORMPropertyTypeFloat:
            string = @"float";
            break;
        case ITTORMPropertyTypeDouble:
            string = @"double";
            break;
        case ITTORMPropertyTypeCGFloat:
            string = @"CGFloat";
            break;
        case ITTORMPropertyTypeNSValue:
            string = @"NSValue";
            break;
        case ITTORMPropertyTypeNSString:
            string = @"NSString";
            break;
        case ITTORMPropertyTypeNSNumber:
            string = @"NSNumber";
            break;
        case ITTORMPropertyTypeNSArray:
            string = @"NSArray";
            break;
        case ITTORMPropertyTypeNSDictionary:
            string = @"NSDictionary";
            break;
        default:
            break;
    }
    return string;
}

ITTORMPropertyType propertyTypeFromValue(id value)
{
    ITTORMPropertyType propertyType = ITTORMPropertyTypeNone;
    if ([value isKindOfClass:[NSNumber class]]) {
        propertyType = ITTORMPropertyTypeNSNumber;
    }
    else if([value isKindOfClass:[NSString class]]) {
        propertyType = ITTORMPropertyTypeNSString;
    }
    else if([value isKindOfClass:[NSValue class]]) {
        propertyType = ITTORMPropertyTypeNSValue;
    }
    else if([value isKindOfClass:[NSDictionary class]]) {
        propertyType = ITTORMPropertyTypeNSDictionary;
    }
    else if([value isKindOfClass:[NSArray class]]) {
        propertyType = ITTORMPropertyTypeNSArray;
    }
    else if([value isKindOfClass:[NSArray class]]) {
        propertyType = ITTORMPropertyTypeNSArray;
    }
    else if([value isKindOfClass:[ITTBaseModelObject class]]) {
        propertyType = ITTORMPropertyTypeCustomClass;
    }
    return propertyType;
}

ITTORMPropertyType propertyTypeFromType(Class cls, const char *properptyAttributes)
{
    ITTORMPropertyType propertyType = ITTORMPropertyTypeNone;
    NSString *attributes = [NSString stringWithUTF8String:properptyAttributes];
    
    if (NSNotFound != [attributes rangeOfString:@"T@"].location) {
        NSString *type = [[attributes componentsSeparatedByString:@","] firstObject];
        if ([@"T@\"NSNumber\"" isEqualToString:type]) {
            propertyType = ITTORMPropertyTypeNSNumber;
        }
        else if ([@"T@\"NSValue\"" isEqualToString:type]) {
            propertyType = ITTORMPropertyTypeNSValue;
        }
        else if ([@"T@\"NSArray\"" isEqualToString:type]) {
            propertyType = ITTORMPropertyTypeNSArray;
        }
        else if ([@"T@\"NSString\"" isEqualToString:type]) {
            propertyType = ITTORMPropertyTypeNSString;
        }
        else if ([@"T@\"NSDictionary\"" isEqualToString:type]) {
            propertyType = ITTORMPropertyTypeNSDictionary;
        }
        else {
            NSString *customType = [NSString stringWithFormat:@"T@\"%@\"", NSStringFromClass(cls)];
            if ([customType isEqualToString:type]) {
                propertyType = ITTORMPropertyTypeCustomClass;
            }
        }
    }
    else if(NSNotFound != [attributes rangeOfString:@"Ti"].location) {
        propertyType = ITTORMPropertyTypeInt;
    }
    else if(NSNotFound != [attributes rangeOfString:@"Tq"].location) {
        propertyType = ITTORMPropertyTypeNSInteger;
    }
    else if(NSNotFound != [attributes rangeOfString:@"Tf"].location) {
        propertyType = ITTORMPropertyTypeFloat;
    }
    else if(NSNotFound != [attributes rangeOfString:@"Td"].location) {
        propertyType = ITTORMPropertyTypeCGFloat;
    }
    return propertyType;
}

/*!
 * 检测*valueObject的类型与objClass的属性的类型是否匹配，不匹配的话讲抛出异常
 */
BOOL CheckTypeMatching(id *valueObject, Class objClass, ITTPropertyMapping *propertyMapping)
{
    BOOL matched = FALSE;
    NSString *reason = nil;
    NSString *propertyName = propertyMapping.propertyName;
    objc_property_t property = class_getProperty(objClass, [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
    if (!property) {
        reason = [NSString stringWithFormat:@"%@ is not a property of class %@. Please check your declaration or spelling", propertyName, NSStringFromClass(objClass)];
    }
    else {
        const char *propertyAttributeString = property_getAttributes(property);
        
        ITTORMPropertyType valueAccutallyType = propertyTypeFromValue(*valueObject);
        ITTORMPropertyType declarePropertyType = propertyTypeFromType(propertyMapping.objectMapping.objectClass, propertyAttributeString);
        
        BOOL declarePropertyTypeCanConvertToNumber = declarePropertyType == ITTORMPropertyTypeNSNumber ||
        declarePropertyType == ITTORMPropertyTypeInt ||
        declarePropertyType == ITTORMPropertyTypeNSInteger ||
        declarePropertyType == ITTORMPropertyTypeFloat ||
        declarePropertyType == ITTORMPropertyTypeCGFloat ||
        declarePropertyType == ITTORMPropertyTypeDouble;
        
        BOOL sameType = valueAccutallyType == declarePropertyType;
        if (sameType || ((ITTORMPropertyTypeNSNumber == valueAccutallyType) && declarePropertyTypeCanConvertToNumber)) {
            matched = TRUE;
        }
        else {
            //属性声明的事NSString, 但是实际数据是NSNumber, 将NSNumber转化为NSString
            if (ITTORMPropertyTypeNSNumber == valueAccutallyType && ITTORMPropertyTypeNSString == declarePropertyType) {
                *valueObject = [*valueObject stringValue];
                matched = TRUE;
            }
            else if(ITTORMPropertyTypeNSString == valueAccutallyType &&  declarePropertyTypeCanConvertToNumber) {
                if ([*valueObject canConvertToNumber]) {
                    *valueObject = @([*valueObject integerValue]);
                }
                else {
                    reason = [NSString stringWithFormat:@"The value of field %@ is: %@, it can't be converted to number.", propertyMapping.sourceName, *valueObject];
                }
                matched = TRUE;
            }
            else {
                if (ITTORMPropertyTypeCustomClass == declarePropertyType) {
                    reason = [NSString stringWithFormat:@"The actual type of field %@ is %@, but the type of property %@ in %@ is declared as %@, not matched.  Please see %@ declaration", propertyMapping.sourceName, NSStringFromClass([*valueObject class]), propertyName, NSStringFromClass(objClass), NSStringFromClass(propertyMapping.objectMapping.objectClass), NSStringFromClass(objClass)];
                }
                else {
                    reason = [NSString stringWithFormat:@"The actual type of field %@ is %@, but the type of property %@ in %@ is declared as %@, not matched. Please see %@ declaration", propertyMapping.sourceName, NSStringFromClass([*valueObject class]), propertyName, NSStringFromClass(objClass), propertyStringFromType(declarePropertyType), NSStringFromClass(objClass)];
                }
                ITTDERROR(@"%@", reason);
            }
        }
    }
    if (reason && [reason length]) {
        @throw [NSException exceptionWithName:@"Type Mismatch" reason:reason userInfo:nil];
    }
    return matched;
}

