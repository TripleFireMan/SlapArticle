//
//  SAMarkArticleRequest.m
//  SlapArticle
//
//  Created by 成焱 on 15/11/8.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAMarkArticleRequest.h"

@implementation SAMarkArticleRequest
- (NSString *)getRequestUrl
{
    return SAMarkArticleStatisticsUrl;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}
@end
