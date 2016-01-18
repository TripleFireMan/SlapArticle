//
//  SAUnfavourRequest.m
//  SlapArticle
//
//  Created by 成焱 on 15/11/4.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAUnfavourRequest.h"

@implementation SAUnfavourRequest
- (NSString *)getRequestUrl
{
    return SAUnfavourUrl;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}
@end
