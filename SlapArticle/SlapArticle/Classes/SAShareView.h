//
//  SAShareView.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/24.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAShareView : UIView

//+ (id)create;


/**
 *  通用的展示分享框的回调方法
 *
 *  @param images    图片数组
 *  @param titles    标题数组
 *  @param callBacks 回调
 *  @param height    高度
 *  @param animation 是否有动画
 *
 *  @return 返回视图对象
 */
+ (id)  showWithImages:(NSArray <UIImage *>*)images
                 title:(NSArray <NSString *> *)titles
             callBacks:(void(^)(NSInteger))callBacks
                 heiht:(CGFloat)height
             animation:(BOOL)animation;

/**
 *  方便的分享调用方法
 *
 *  @param callBack 回调
 */
+ (void) showWithCallBack:(void(^)(NSInteger type))callBack;
@end
