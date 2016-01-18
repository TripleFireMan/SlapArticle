//
//  SAArticleContributeRequest.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/31.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAArticleContributeRequest.h"

@implementation SAArticleContributeRequest
- (NSString *)getRequestUrl
{
    return SAContributeUrl;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
