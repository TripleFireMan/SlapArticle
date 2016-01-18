//
//  SADuanzi.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/27.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SACellModel.h"
@interface SADuanzi : SACellModel
@property (nonatomic, assign) NSInteger app_share_count;
@property (nonatomic, assign) NSInteger appThumbCount;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger aid;
@property (nonatomic, assign) NSInteger thumbed;

- (id)initWithDuanzi:(id)info;

@end
