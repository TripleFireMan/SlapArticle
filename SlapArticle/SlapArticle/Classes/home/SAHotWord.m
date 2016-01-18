//
//  SAHotWord.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/26.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAHotWord.h"

@implementation SAHotWord
- (id)initWithHotWord:(NSDictionary *)hotword
{
    self = [super init];
    if (self) {
        self.content = hotword[@"content"];
    }
    return self;
}
@end
