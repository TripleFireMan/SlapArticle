//
//  ITTRequestJsonDataHandler.m
//  iTotemFramework
//
//  Created by Sword on 13-9-5.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "ITTRequestJsonDataHandler.h"

@implementation ITTRequestJsonDataHandler


/*!
 * default implementation:using NSJSONSerialization to generate a NSMutableDictionary
 */
- (id)parseJsonString:(NSString *)resultString error:(NSError **)error
{
    id result = nil;
    resultString = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSData *jsonData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:error];
    return result;
}

@end
