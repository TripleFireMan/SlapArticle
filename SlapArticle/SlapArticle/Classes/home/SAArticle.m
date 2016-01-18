//
//  SAArticle.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/17.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAArticle.h"

@implementation SAArticle
- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.cellType      = SACellTypeArticle;
        self.isShowTotal   = NO;
        self.aid           = [data[@"id"]integerValue];
        self.contentNext   = [@"\n\n\n\n\n" stringByAppendingString:data[@"content_nxt"]];
        self.contentPrew   = data[@"content_prev"];
        self.appShareCount = [data[@"app_share_count"]integerValue];
        self.thumbed       = [data[@"thumbed"]integerValue];
        self.appThumbCount = [data[@"app_thumb_count"]integerValue];
    }
    return self;
}
@end
