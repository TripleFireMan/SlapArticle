//
//  SAShareStatisticRequest.m
//  SlapArticle
//
//  Created by 成焱 on 15/11/4.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAShareStatisticRequest.h"

@implementation SAShareStatisticRequest
- (NSString *)getRequestUrl
{
    return SAShareStatistics;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}
@end
