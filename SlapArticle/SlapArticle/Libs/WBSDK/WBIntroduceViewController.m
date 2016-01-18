//
//  WBIntroduceViewController.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/19.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "WBIntroduceViewController.h"

typedef void (^WBClickCallBack)(void);

@interface WBIntroduceViewController ()
{
    WBClickCallBack _wbClickCallBack;
    NSArray <UIImage *> *_images;
    UIScrollView *_scrollerView;
}
@end

@implementation WBIntroduceViewController

- (id)initWithIntruduceImages:(NSArray<UIImage *> *)intruduceImages
{
    self = [super init];
    if (self) {
        _images = [NSArray arrayWithArray:intruduceImages];
    }
    return self;
}

- (void)setHandleLastImageViewClickCallBack:(void (^)(void))clickCallBack
{
    if (_wbClickCallBack != clickCallBack) {
        _wbClickCallBack = [clickCallBack copy];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat systemVersion = [[[UIDevice currentDevice]systemVersion]floatValue];
    if (systemVersion > 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    _scrollerView =({
        
        CGFloat screenWidth                 = [[UIScreen mainScreen]bounds].size.width;
        CGFloat screenHeight                = [[UIScreen mainScreen]bounds].size.height;

        UIScrollView *scro                  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        scro.backgroundColor                = [UIColor whiteColor];
        scro.bounces                        = NO;

        NSInteger number                    = [_images count];
        scro.pagingEnabled                  = YES;
        scro.showsHorizontalScrollIndicator = NO;
        [scro setContentSize:CGSizeMake(screenWidth * number, screenHeight)];

        [_images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imgView = ({
                UIImageView *tmpImgV           = [[UIImageView alloc]initWithFrame:CGRectMake(idx * screenWidth, 0, screenWidth, screenHeight)];
                tmpImgV.contentMode            = UIViewContentModeScaleAspectFill;
                tmpImgV.image                  = obj;
                tmpImgV.userInteractionEnabled = YES;
                tmpImgV;
            });
            
            if (idx == number - 1) {
                UISwipeGestureRecognizer *swipeGes = ({
                    UISwipeGestureRecognizer *tmp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipLeftAction:)];
                    tmp.direction = UISwipeGestureRecognizerDirectionLeft;
                    tmp;
                });
                
                UITapGestureRecognizer *tapGes = ({
                    UITapGestureRecognizer *tmp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapAction:)];
                    tmp.numberOfTapsRequired = 1;
                    tmp;
                });
                
                [imgView addGestureRecognizer:swipeGes];
                [imgView addGestureRecognizer:tapGes];
            }
            [scro addSubview:imgView];
        }];
        scro;
    });

    self.view = _scrollerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTapAction:(id)sender
{
    if (_wbClickCallBack) {
        _wbClickCallBack();
    }
}

- (void)handleSwipLeftAction:(id)sender
{
    if (_wbClickCallBack) {
        _wbClickCallBack();
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
