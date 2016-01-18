//
//  SAOurViewController.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/20.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAOurViewController.h"
#import "UMFeedback.h"
#import "User.h"
#import "SAShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <StoreKit/StoreKit.h>
@interface SAOurViewController ()<UIAlertViewDelegate,SKStoreProductViewControllerDelegate>

@end

@implementation SAOurViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
//                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [MobClick event:@"MobclickAgent11"];
            [self comment];
        }
            break;
        case 1:
        {
            [MobClick event:@"MobclickAgent12"];
            [self feedBack];
        }
            break;
        case 2:
        {
            [MobClick event:@"MobclickAgent13"];
            [self inviteFriends];
        }
            break;
        case 3:
        {
            [MobClick event:@"MobclickAgent14"];
            [self forcusOurWechatnumber];
        }
            break;
        default:
            break;
    }
}

- (void)comment
{
    __block typeof(self) weakSelf = self;
    SKStoreProductViewController *produceViewController = [[SKStoreProductViewController alloc]init];
    produceViewController.delegate = self;
    
    [SVProgressHUD showWithStatus:@"跳转AppStore中..."];
    [produceViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:APPID}
                                     completionBlock:^(BOOL result, NSError * _Nullable error) {
                                         [SVProgressHUD dismiss];
                                         if (error) {
                                             [SVProgressHUD showErrorWithStatus:@"无法打开AppStore！"];
                                         }else{
                                             [weakSelf presentViewController:produceViewController animated:YES completion:nil];
                                         }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)feedBack
{
    UIViewController *feedBack = [UMFeedback feedbackViewController];
    feedBack.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feedBack animated:YES];
}

- (void)inviteFriends
{
    [SAShareView showWithCallBack:^(NSInteger index) {
        NSArray *platforms = @[@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeSMS)];
        
        NSString *inviteUrl = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?mt=8&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&id="APPID;
        
        NSString *inviteMessage = [NSString stringWithFormat:@"我在点开全文发现很多好玩的段子，你也一起来玩吧，点击这个链接去下载吧,%@",inviteUrl];
        BOOL needImage = NO;
        NSArray *imgArray = [NSArray arrayWithObject:[UIImage imageNamed:@"icon_our"]];
        if (index == 2) {
            needImage = YES;
        }
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:inviteMessage images:needImage?imgArray:nil
                                            url:[NSURL URLWithString:@"http://quanwen.bmob.cn/" ]
                                          title:@"http://quanwen.bmob.cn/"
                                           type:needImage?SSDKContentTypeAuto:SSDKContentTypeText];
        [ShareSDK share:[platforms[index] integerValue]
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             switch (state) {
                 case SSDKResponseStateBegin:
                 {
                     NSLog(@"1");
                 }
                     break;
                 case SSDKResponseStateCancel:
                 {
                     NSLog(@"2");
                 }
                     break;
                 case SSDKResponseStateFail:
                 {
                     NSLog(@"3 error = %@",error);
                 }
                     break;
                 case SSDKResponseStateSuccess:
                 {
                     NSLog(@"4");
                 }
                     break;
                 default:
                     break;
             }
         }];
    }];
}

- (void)forcusOurWechatnumber
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"我们的公众号'猛击全文'已复制好，现在打开微信去粘贴搜索吧！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去搜索", nil];
    [alertView show];
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else if (buttonIndex == alertView.firstOtherButtonIndex){
        
        UIPasteboard *pasted = [UIPasteboard generalPasteboard];
        [pasted setString:@"猛击全文"];
        
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
            [MobClick event:@"copy_wechat"];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"wechat://"]];
        }else{
            [SVProgressHUD showErrorWithStatus:@"您的设备没有安装微信，请先安装微信"];
        }
         [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}
@end
