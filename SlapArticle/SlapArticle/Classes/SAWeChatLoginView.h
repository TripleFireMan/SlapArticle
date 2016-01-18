//
//  SAWeChatLoginWindow.h
//  SlapArticle
//
//  Created by 成焱 on 16/1/12.
//  Copyright © 2016年 成焱. All rights reserved.
//

#import <UIKit/UIKit.h>
enum SAWeChatActive{
    SAWeChatCancel = 0,
    SAWeChatLogin = 1,
};

typedef void (^SAWeChatCallBack)(enum SAWeChatActive avtive);

@interface SAWeChatLoginView : UIView

+ (void)showWithActive:(SAWeChatCallBack)callBack;
+ (void)dismiss;

@end
