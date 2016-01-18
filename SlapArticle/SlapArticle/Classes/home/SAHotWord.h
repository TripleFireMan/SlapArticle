//
//  SAHotWord.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/26.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAHotWord : NSObject

@property (nonatomic, copy) NSString *content;

- (id)initWithHotWord:(NSDictionary *)hotword;

@end
