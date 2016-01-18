//
//  SAClickArticleStatisticsRequest.m
//  SlapArticle
//
//  Created by 成焱 on 15/11/8.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAClickArticleStatisticsRequest.h"

@implementation SAClickArticleStatisticsRequest
- (NSString *)getRequestUrl
{
    return SAClickArticleStatistics;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}
@end
