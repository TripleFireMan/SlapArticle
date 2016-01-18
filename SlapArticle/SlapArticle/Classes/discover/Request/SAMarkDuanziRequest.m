//
//  SAMarkDuanziRequest.m
//  SlapArticle
//
//  Created by 成焱 on 15/11/28.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAMarkDuanziRequest.h"

@implementation SAMarkDuanziRequest
- (NSString *)getRequestUrl
{
    return SAMarkDuanziStatisticsUrl;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}
@end
