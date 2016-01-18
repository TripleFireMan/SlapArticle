//
//  SAWeChatLoginWindow.m
//  SlapArticle
//
//  Created by 成焱 on 16/1/12.
//  Copyright © 2016年 成焱. All rights reserved.
//

#import "SAWeChatLoginView.h"

const CGFloat contentWidth = 500.f;
const CGFloat contentHeight = 600.f;

@interface SAWeChatLoginView()
@property (nonatomic, copy) SAWeChatCallBack callBack;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIView *contentView;
@end

static SAWeChatLoginView *loginWindow = nil;

@implementation SAWeChatLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)shareLoginWindow
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginWindow = [[SAWeChatLoginView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    });

    return loginWindow;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        BOOL canUseBlurView = [[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0;
        if (canUseBlurView) {
            UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.blurView = [[UIVisualEffectView alloc]initWithEffect:effect];
            self.blurView.frame = self.bounds;
            self.blurView.alpha = 1.0;
            [self addSubview:self.blurView];
            self.backgroundColor = [UIColor clearColor];
        }else{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        }
        
        [self setUpWechatLoginView];

        
    }
    return self;
}

- (void)setUpWechatLoginView
{
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE5SCALE(contentWidth),IPHONE5SCALE(contentHeight))];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.center = self.blurView.center;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, IPHONE5SCALE(contentWidth), IPHONE5SCALE(90))];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT(18);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = RGBACOLOR(85, 191, 181, 1);
    titleLabel.text = @"请先登录后使用";
    [self.contentView addSubview:titleLabel];
    
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wechat_login"]];
    logo.frame = CGRectMake(0, 0, IPHONE5SCALE(160), IPHONE5SCALE(131));
    logo.centerX = titleLabel.centerX;
    logo.top = titleLabel.bottom + 20;
    [self.contentView addSubview:logo];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, 40)];
    contentLabel.text = @"使用微信登录";
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = RGBACOLOR(85, 191, 181, 1);
    contentLabel.font = FONT(18);
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.centerX = titleLabel.centerX;
    contentLabel.top = logo.bottom + IPHONE5SCALE(60);
    [self.contentView addSubview:contentLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:RGBCOLOR(155, 155, 155) forState:UIControlStateNormal];
    [cancelBtn setTitle:@"稍后再说" forState:UIControlStateNormal];
    cancelBtn.tag = 10;
    cancelBtn.titleLabel.font = FONT(18);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(IPHONE5SCALE(25), self.contentView.height - IPHONE5SCALE(67) - IPHONE5SCALE(30), IPHONE5SCALE(206), IPHONE5SCALE(67));
    [self.contentView addSubview:cancelBtn];
    
    UIButton *loginbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitleColor:RGBACOLOR(85, 191, 181, 1) forState:UIControlStateNormal];
    [loginbtn setTitle:@"立即登录" forState:UIControlStateNormal];
    loginbtn.tag = 11;
    loginbtn.titleLabel.font = FONT(18);
    [loginbtn setBackgroundImage:[UIImage imageNamed:@"blue_btn"] forState:UIControlStateNormal];
    [loginbtn addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    loginbtn.frame = CGRectMake(self.contentView.width - IPHONE5SCALE(206) - IPHONE5SCALE(25), self.contentView.height - IPHONE5SCALE(67) - IPHONE5SCALE(30), IPHONE5SCALE(206), IPHONE5SCALE(67));
    [self.contentView addSubview:loginbtn];
    
    

    [self.blurView.contentView addSubview:self.contentView];
}

- (void)handleBtnAction:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
    if (tag == 10) {
        _callBack(SAWeChatCancel);
    }else{
        _callBack(SAWeChatLogin);
    }
    
    [SAWeChatLoginView dismiss];
}

+ (void)showWithActive:(SAWeChatCallBack)callBack
{
    SAWeChatLoginView *window = [SAWeChatLoginView shareLoginWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:window];
    [SAWeChatLoginView shareLoginWindow].callBack = callBack;
}

+ (void)dismiss
{
    SAWeChatLoginView *view = [SAWeChatLoginView shareLoginWindow];
    [view removeFromSuperview];
}
@end
