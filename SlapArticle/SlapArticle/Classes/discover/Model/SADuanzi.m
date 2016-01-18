//
//  SADuanzi.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/27.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SADuanzi.h"

@implementation SADuanzi
- (id)initWithDuanzi:(id)info
{
    if (self = [super init]) {
        self.cellType = SACellTypeDuanzi;
        self.aid = [info[@"id"]integerValue];
        self.app_share_count = [info[@"app_share_count"]integerValue];
        self.appThumbCount = [info[@"app_thumb_count"]integerValue];
        self.thumbed = [info[@"thumbed"]integerValue];
        self.content = info[@"content"];
    }
    return self;
}
@end
