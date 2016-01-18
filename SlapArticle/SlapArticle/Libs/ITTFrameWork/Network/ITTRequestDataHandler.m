//
//  RequestDataHandler.m
//  iTotemFramework
//
//  Created by Sword on 13-9-5.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "ITTRequestDataHandler.h"

@implementation ITTRequestDataHandler

- (id)parseJsonString:(NSString *)resultString error:(NSError **)error
{
    NSString *reason = [NSString stringWithFormat:@"This is a abstract method. You should subclass of ITTRequestDataHandler and override it!"];
    @throw [NSException exceptionWithName:@"Logic Error" reason:reason userInfo:nil];
    return nil;
}

@end
