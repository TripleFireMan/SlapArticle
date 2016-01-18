//
//  ITTORMConsts.h
//  iTotemMinFramework
//
//  Created by Sword on 10/27/14.
//
//

#ifndef iTotemMinFramework_ITTORMConsts_h
#define iTotemMinFramework_ITTORMConsts_h

typedef enum {
    ITTORMPropertyTypeNone,
    ITTORMPropertyTypeInt,                  //Ti,N,V_propertyName
    ITTORMPropertyTypeNSInteger,            //Tq,N,V_propertyName
    ITTORMPropertyTypeFloat,                //Tf,N,V_propertyName
    ITTORMPropertyTypeCGFloat,              //Td,N,V_propertyName
    ITTORMPropertyTypeDouble,               //Td,N,V_propertyName
    ITTORMPropertyTypeNSNumber,             //T@"NSNumber"
    ITTORMPropertyTypeNSValue,              //T@"NSValue"
    ITTORMPropertyTypeNSString,             //T@"NSArray"
    ITTORMPropertyTypeNSArray,              //T@“NSString"
    ITTORMPropertyTypeNSDictionary,         //T@"NSDictionary"
    ITTORMPropertyTypeCustomClass,          //T@"ClassName"
} ITTORMPropertyType;

typedef enum {
    ITTMappingErrorTypeMismatch = 111,
}ITTMappingError;

#endif
