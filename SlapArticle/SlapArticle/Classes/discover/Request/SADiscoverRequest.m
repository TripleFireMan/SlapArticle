//
//  SADiscoverRequest.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/27.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SADiscoverRequest.h"

@implementation SADiscoverRequest
- (NSString *)getRequestUrl
{
    return SADuanziUrl;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}
@end
