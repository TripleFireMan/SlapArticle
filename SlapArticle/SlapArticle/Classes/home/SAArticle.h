//
//  SAArticle.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/17.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SACellModel.h"

@interface SAArticle : SACellModel

@property (nonatomic, assign) NSInteger appShareCount;
@property (nonatomic, assign) NSInteger appThumbCount;
@property (nonatomic, assign) NSInteger aid;
@property (nonatomic, assign) NSInteger thumbed;

@property (nonatomic, strong) NSString *contentPrew;
@property (nonatomic, strong) NSString *contentNext;

- (id)initWithData:(NSDictionary *)data;
@end
