//
//  WBIntroduceViewController.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/19.
//  Copyright © 2015年 成焱. All rights reserved.

//  介绍页浏览引擎
//  Version 1.0
//  Brief   第一版介绍页引擎，主要实现以下功能
//          1.能够展示提供的介绍图片，并滑动浏览
//          2.点击最后一张或向右轻扫最后一张图执行回调方法

//  TODO    能够提供一些可供选择的切换动画

#import <UIKit/UIKit.h>

@interface WBIntroduceViewController : UIViewController

/**
 *  初始化
 *
 *  @param intruduceImages 图片资源
 *
 *  @return 介绍页浏览引擎
 */
- (id)initWithIntruduceImages:(NSArray <UIImage *> *)intruduceImages;

/**
 *  设置最后显示到最后一张图片点击回调
 *
 *  @param clickCallBack 回调的时间
 */
- (void)setHandleLastImageViewClickCallBack:(void(^)(void))clickCallBack;

@end
