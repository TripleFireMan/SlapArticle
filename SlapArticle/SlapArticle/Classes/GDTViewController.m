//
//  GDTViewController.m
//  SlapArticle
//
//  Created by 成焱 on 15/11/22.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "GDTViewController.h"
#import "GDTSplashAd.h"
@interface GDTViewController ()<GDTSplashAdDelegate>
@property (nonatomic, strong) UIImageView *imgview;
@property (strong, nonatomic) GDTSplashAd *splash;

@end

@implementation GDTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgview = ({
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        img.image = [UIImage imageNamed:@"LaunchImage"];
        img;
    });
    
    [self.view addSubview:self.imgview];
    
    
//    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    //开屏广告初始化并展示代码
    // 1104983962  8070409730911639 点开全文
    // 1101508191   1020003690642397   测试用
    GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppkey:@"1104983962" placementId:@"8070409730911639"];
    splash.delegate = self; //设置代理
    //根据iPhone设备不同设置不同背景图
    if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
        splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage-568h"]]; } else {
            splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage"]]; }
    splash.fetchDelay = 5; //开发者可以设置开屏拉取时间,超时则放弃展示 //开屏广告拉取并展示在当前window中
    [splash loadAdAndShowInWindow:self.window];
    self.splash = splash;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
}

-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    if (self.finish) {
        self.finish();
    }
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    
}

- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    if (self.finish) {
        self.finish();
    }
}

- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    //程序切到appstore会回调这个方法，目前并不需要做任何事
    //do nothing
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
