//
//  SACellModel.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/18.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, SACellType){
    SACellTypeGrayCell,
    SACellTypeArticle,
    SACellTypeLoadingMore,
    SACellTypeDuanzi,
};
@interface SACellModel : NSObject
@property (nonatomic, assign) SACellType cellType;
@property (nonatomic, assign) BOOL isShowTotal;
@end
