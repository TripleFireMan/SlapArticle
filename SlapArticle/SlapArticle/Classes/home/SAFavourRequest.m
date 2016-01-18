//
//  SAFavourRequest.m
//  SlapArticle
//
//  Created by 成焱 on 15/11/4.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAFavourRequest.h"

@implementation SAFavourRequest
- (NSString *)getRequestUrl
{
    return SAFavourUrl;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

@end
