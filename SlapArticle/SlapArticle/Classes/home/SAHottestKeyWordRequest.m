//
//  SAHottestKeyWordRequest.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/25.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAHottestKeyWordRequest.h"

@implementation SAHottestKeyWordRequest
- (NSString *)getRequestUrl
{
    return SAHottestWordsUrl;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}
@end
