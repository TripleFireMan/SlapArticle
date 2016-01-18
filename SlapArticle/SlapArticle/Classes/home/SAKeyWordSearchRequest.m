//
//  SAKeyWordSearchRequest.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/26.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAKeyWordSearchRequest.h"

@implementation SAKeyWordSearchRequest

- (NSString *)getRequestUrl
{
    return SAKeyWordSearchUrl;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
