//
//  SAGetQuanwenRequest.m
//  SlapArticle
//
//  Created by 成焱 on 15/11/28.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAGetQuanwenRequest.h"

@implementation SAGetQuanwenRequest
- (NSString *)getRequestUrl
{
    return SAGetQuanwenUrl;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}
@end
