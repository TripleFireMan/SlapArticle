//
//  SAShareView.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/24.
//  Copyright © 2015年 成焱. All rights reserved.
//

#define TopMargin    3
#define LeftMargin   0
#define BottomMargin 0
#define RightMargin  0

#import "SAShareView.h"
@interface SAShareView()

@property (nonatomic, copy) void(^aa)(NSInteger);
@property (nonatomic, assign) BOOL animation;
@property (nonatomic, strong) UIView *itemsView;
@end
@implementation SAShareView

+ (id)showWithImages:(NSArray<UIImage *> *)images
                 title:(NSArray<NSString *> *)titles
             callBacks:(void(^)(NSInteger))callBacks
                 heiht:(CGFloat)height
                animation:(BOOL)animation
{
    //灰色背景夢层
    CGRect bounds = [[UIScreen mainScreen]bounds];
    
    SAShareView *shareView = ({
        SAShareView *tmpShare = [[SAShareView alloc]initWithFrame:bounds];
        tmpShare.animation = animation;
        
        tmpShare.aa = callBacks;
        
        tmpShare.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        UIView *bgView = ({
            UIView *tmpBg = [[UIView alloc]initWithFrame:bounds];
            tmpBg.backgroundColor = [UIColor blackColor];
            tmpBg.alpha = 0.3f;
            tmpBg.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:tmpShare action:@selector(handleTapBackGround:)];
            tap.numberOfTapsRequired = 1;
            
            [tmpBg addGestureRecognizer:tap];
            
            tmpBg;
        });
        
        [tmpShare addSubview:bgView];
        
        
        
        tmpShare.itemsView = ({
            UIView *tmp = [[UIView alloc]initWithFrame:CGRectMake(0, bounds.size.height - height, bounds.size.width, height)];
            tmp.backgroundColor = [UIColor clearColor];
            
            CGFloat btnWidth   = (bounds.size.width - LeftMargin - RightMargin) / 3;
            CGFloat btnHeight  = (height - TopMargin - BottomMargin) /2;
            CGFloat btnOriginx = LeftMargin;
            CGFloat btnOriginy = TopMargin;
            
            NSInteger rows = 2;
            NSInteger cloum = [titles count] / 2;
            
            for (int i = 0; i < rows; i++) {
                for (int j = 0; j < cloum; j++) {
                    UIButton *btn = ({
                        UIButton *tmp = [UIButton buttonWithType:UIButtonTypeCustom];
                        tmp.frame = CGRectMake(btnOriginx + j * btnWidth , btnOriginy + i * btnHeight,btnWidth, btnHeight);
                        [tmp setBackgroundColor:[UIColor whiteColor]];
                        [tmp setTitleColor:RGBCOLOR(72, 179, 166) forState:UIControlStateNormal];
                        [tmp addTarget:tmpShare action:@selector(handleTapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                        [tmp addTarget:tmpShare action:@selector(handleBtnTapDownAction:) forControlEvents:UIControlEventTouchDown];
                        [tmp addTarget:tmpShare action:@selector(handleBtnTapDragExitAction:) forControlEvents:UIControlEventTouchDragExit];
                        [tmp addTarget:tmpShare action:@selector(handleBtnTapDragEnterAction:) forControlEvents:UIControlEventTouchDragEnter];
                        [tmp addTarget:tmpShare action:@selector(handleBtnTapDragInsideAction:) forControlEvents:UIControlEventTouchDragInside];
                        [tmp addTarget:tmpShare action:@selector(handleBtnTapDragOutsideAction:) forControlEvents:UIControlEventTouchDragOutside];
                        tmp.tag = cloum * i + j;
                        UIImage *img         = images[cloum * i + j];

                        CGFloat imgWidth     = img.size.width /2;
                        CGFloat imgHeight    = img.size.height/2;

                        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
                        imgView.frame        = CGRectMake(10, 0, imgWidth, imgHeight);
                        imgView.center       = CGPointMake(btnWidth / 2, btnHeight / 2 - imgHeight + 10);
                        
                        [tmp addSubview:imgView];
                        
                        UILabel *lab      = [[UILabel alloc]initWithFrame:CGRectMake(0, btnHeight - 21-10, btnWidth, 21)];
                        lab.text          = titles[cloum * i + j];
                        lab.font          = [UIFont systemFontOfSize:13.f];
                        lab.textColor     = RGBACOLOR(72, 179, 166, 1);
                        lab.textAlignment = NSTextAlignmentCenter;
                        [tmp addSubview:lab];
                        
                        tmp;
                    });
                    [tmp addSubview:btn];
                }
            }
            
            tmp.backgroundColor = RGBCOLOR(72, 179, 166);
            
            tmp;
        });
        
        tmpShare.itemsView.top = tmpShare.bottom;
        
        [tmpShare addSubview:tmpShare.itemsView];
        
        [UIView animateWithDuration:tmpShare.animation?0.15:0 animations:^{
            tmpShare.itemsView.top = tmpShare.height - height;
        }];
        
        
        
        tmpShare;
    });
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    shareView.alpha = 0.0;
    [keyWindow addSubview:shareView];
    
    [UIView animateWithDuration:shareView.animation?0.35:0
                     animations:^{
        shareView.alpha = 1.0f;
    }
                     completion:nil];
    
    
    return shareView;
}

+ (void)showWithCallBack:(void (^)(NSInteger))callBack
{
    [[self class]showWithImages:@[[UIImage imageNamed:@"wechattimeline"],
                                 [UIImage imageNamed:@"wechat"],
                                 [UIImage imageNamed:@"qzone"],
                                 [UIImage imageNamed:@"qq"],
                                 [UIImage imageNamed:@"sina_weibo"],
                                 [UIImage imageNamed:@"sa_message"]]

                          title:@[@"朋友圈",@"微信好友",@"qq空间",@"QQ好友",@"新浪微博",@"短信"]
                      callBacks:callBack
                          heiht:160
                      animation:YES];
}

- (void)handleTapBackGround:(id)sender
{
    [self hideWithAnimation:self.animation];
}

- (void)handleTapBtnAction:(id)sender
{
    [self hideWithAnimation:self.animation];
    
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    if (self.aa != nil) {
        self.aa(tag);
    }
}

- (void)handleBtnTapDragInsideAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor lightTextColor]];
}

- (void)handleBtnTapDragOutsideAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor whiteColor]];
}

- (void)handleBtnTapDownAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor lightTextColor]];
}

- (void)handleBtnTapDragExitAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor whiteColor]];
}

- (void)handleBtnTapDragEnterAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor lightTextColor]];
}

- (void)hideWithAnimation:(BOOL)animation
{
    [UIView animateWithDuration:animation?0.15:0 animations:^{
        self.itemsView.top = self.bottom;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
