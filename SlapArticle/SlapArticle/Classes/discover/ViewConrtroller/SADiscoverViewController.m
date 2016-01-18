//
//  SADiscoverViewController.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/17.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SADiscoverViewController.h"
#import "SADiscoverTableViewCell.h"
#import "SADiscoverRequest.h"
#import "SACellModel.h"
#import "SADuanzi.h"
#import "SAShareView.h"
#import "SAShareStatisticRequest.h"
#import <ShareSDK/ShareSDK.h>
#import "SAMarkDuanziRequest.h"

@interface SADiscoverViewController ()
{
    NSInteger _latestId;
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation SADiscoverViewController

#pragma mark - LifeCycle

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    if (IS_IOS_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dataSource = [NSMutableArray array];
    
    WB_WEAK_SELF(weakSelf);
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        _latestId = 0;
        [weakSelf startRequest];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf startRequest];
    }];
    
    [self.tableView triggerPullToRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierForDuanzi   = @"Cell";
    static NSString *identifierForGrayCell = @"grayCell";
    
    SACellModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
    if (model.cellType == SACellTypeDuanzi) {
        
        SADuanzi *duanzi = (SADuanzi *)model;
        SADiscoverTableViewCell * duanzicell  = [tableView dequeueReusableCellWithIdentifier:identifierForDuanzi];
        [duanzicell resetConstraint];
        duanzicell.duanzi = duanzi;
        duanzicell.articleLabel.text = duanzi.content;
        [duanzicell.shareBtn setTitle:[NSString stringWithFormat:@"%ld",(long)duanzi.app_share_count] forState:UIControlStateNormal];
        [duanzicell.copyedBtn setTitle:[NSString stringWithFormat:@"%ld",(long)duanzi.appThumbCount] forState:UIControlStateNormal];
        
        BOOL thumbed = [duanzi thumbed];
        [duanzicell.copyedBtn setImage:thumbed?[UIImage imageNamed:@"sa_zan_full"]:[UIImage imageNamed:@"sa_zan_empty"] forState:UIControlStateNormal];
        
        duanzicell.callBack = ^(SAArticleCellBtnType type){
            switch (type) {
                case SAArticleCellBtnTypeShare:
                {
                    [MobClick event:@"MobclickAgent18"];
                    [SAShareView showWithCallBack:^(NSInteger index) {
                        NSArray *platforms = @[@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeSMS)];
                        
                        NSString *quanwen = [duanzi content];
                        
                        
                        BOOL needImage = NO;
                        NSArray *imgArray = [NSArray arrayWithObject:[UIImage imageNamed:@"icon_our"]];
                        if (index == 2) {
                            needImage = YES;
                        }
                        
                        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                        
                        [shareParams SSDKSetupShareParamsByText:quanwen
                                                         images:needImage?imgArray:nil
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
                                     NSString *errorInfo = [[error userInfo]valueForKey:@"error_message"];
                                     if ([errorInfo isKindOfClass:[NSString class]] && errorInfo != nil) {
                                         [SVProgressHUD showErrorWithStatus:errorInfo duration:2.0];
                                     }
                                 }
                                     break;
                                 case SSDKResponseStateSuccess:
                                 {
                                     NSLog(@"4");
                                     
                                     NSString *articleId  = [NSString stringWithFormat:@"%ld",(long)[duanzi aid]];
                                     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:articleId,@"id",@"share",@"type", nil];
                                     
                                     duanzi.app_share_count ++;
                                     [tableView beginUpdates];
                                     [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                     [tableView endUpdates];
                                     [SAMarkDuanziRequest requestWithParameters:params withIndicatorView:nil keyPath:nil mapping:nil onRequestFinished:nil];
                                     
                                     [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                 }
                                     break;
                                     
                                 default:
                                     break;
                             }
                         }];
                    }];
                }
                    break;
                
                case SAArticleCellBtnTypeFavor:
                {
                    [MobClick event:@"MobclickAgent17"];
                    NSString *articleId  = [NSString stringWithFormat:@"%ld",(long)[duanzi aid]];
                    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:articleId,@"id",DEVICE_ID,@"device_id",@"thumb",@"type", nil];
                    
                    [SAMarkDuanziRequest requestWithParameters:params withIndicatorView:nil keyPath:nil mapping:nil withCancelSubject:nil onRequestStart:nil onRequestFinished:^(ITTBaseDataRequest *request, ITTMappingResult *result) {
                        NSLog(@"result = %@",result.rawDictionary);
                        NSInteger state = [[result.rawDictionary valueForKey:@"state"]integerValue];
                        if (state == 1) {
                            duanzi.thumbed = 1;
                            duanzi.appThumbCount ++;
                            [tableView beginUpdates];
                            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            [tableView endUpdates];
                            
                            [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
                        }else{
                            [SVProgressHUD showErrorWithStatus:@"点赞失败"];
                        }
                    } onRequestCanceled:^(ITTBaseDataRequest *request) {
                        
                    } onRequestFailed:^(ITTBaseDataRequest *request, NSError *error) {
                        [SVProgressHUD showErrorWithStatus:@"网络连接已中断"];
                    }];
                }
                    break;
                case SAArticleCellBtnTypeUnFavor:
                {
                    NSString *articleId  = [NSString stringWithFormat:@"%ld",(long)[duanzi aid]];
                    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:articleId,@"id",DEVICE_ID,@"device_id",@"cancelthumb",@"type", nil];
                    
                    [SAMarkDuanziRequest requestWithParameters:params withIndicatorView:nil keyPath:nil mapping:nil withCancelSubject:nil onRequestStart:nil onRequestFinished:^(ITTBaseDataRequest *request, ITTMappingResult *result) {
                        NSLog(@"result = %@",result.rawDictionary);
                        NSInteger state = [[result.rawDictionary valueForKey:@"state"]integerValue];
                        if (state == 1) {
                            duanzi.thumbed = 0;
                            duanzi.appThumbCount --;
                            [tableView beginUpdates];
                            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            [tableView endUpdates];
                            [SVProgressHUD showSuccessWithStatus:@"取消赞成功"];
                        }else{
                            [SVProgressHUD showErrorWithStatus:[result.rawDictionary valueForKey:@"message"]];
                        }
                    } onRequestCanceled:^(ITTBaseDataRequest *request) {
                        
                    } onRequestFailed:^(ITTBaseDataRequest *request, NSError *error) {
                        [SVProgressHUD showErrorWithStatus:@"网络连接已中断"];
                    }];
                }
                    break;
                default:
                    break;
            }
        };
        return duanzicell;
        
    }else if (model.cellType == SACellTypeGrayCell){
       UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierForGrayCell];
        return cell;
    }else {
        return nil;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SACellModel *cellModel = [self.dataSource objectAtIndex:indexPath.row];
    switch (cellModel.cellType) {
        case SACellTypeDuanzi:
        {
            SADuanzi *duanzi = (SADuanzi *)cellModel;
            CGFloat h = 0;
            UIFont *font = [UIFont systemFontOfSize:14.f];
            UIColor *color = [UIColor darkGrayColor];
            CGSize size = CGSizeMake(SCREEN_WIDTH - 20, 1000);
            CGFloat contentHeight = [self caculateLabelSize:font color:color text:duanzi.content size:size];
            CGFloat gap = 10;
            h = contentHeight + 8 + 36 + 2 * gap;
            
            return h;
        }
            break;
        case SACellTypeGrayCell:
        {
            return 10;
        }
            break;
        case SACellTypeLoadingMore:
        {
            return 44.f;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - REQUEST

- (void)startRequest
{

    WBNetError failure = ^(NSString *error){
        [SVProgressHUD dismiss];
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
        [SVProgressHUD showErrorWithStatus:error];
    };
    
    WBNetSuccess success = ^(id result){
        
        [SVProgressHUD dismiss];
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
        
        NSInteger status = [result[@"state"]integerValue];
        id message = result[@"message"];
        
        if (status == 1) {
            if ([message isKindOfClass:[NSArray class]]) {
                if (_latestId == 0) {
                    self.dataSource = [NSMutableArray array];
                    SACellModel *gray = [[SACellModel alloc]init];
                    gray.cellType = SACellTypeGrayCell;
                    [self.dataSource addObject:gray];
                    id message = [result valueForKey:@"message"];
                    if (message && [message isKindOfClass:[NSArray class]]) {
                        for (id obj in [result objectForKey:@"message"]) {
                            if ([obj isKindOfClass:[NSDictionary class]]) {
                                SADuanzi *duanzi = [[SADuanzi alloc]initWithDuanzi:obj];
                                [self.dataSource addObject:duanzi];
                                _latestId = duanzi.aid;
                                SACellModel *gray = [[SACellModel alloc]init];
                                gray.cellType = SACellTypeGrayCell;
                                [self.dataSource addObject:gray];
                            }else if ([obj isKindOfClass:[NSString class]]&&obj!=nil){
                                failure(obj);
                            }
                        }
                    }else if([message isKindOfClass:[NSString class]]){
                        failure(message);
                    }else{
                        failure(@"请求失败!");
                    }
                    
                    [self.tableView reloadData];
                    
                }else{
                    id message = [result valueForKey:@"message"];
                    
                    if (message && [message isKindOfClass:[NSArray class]]) {
                        for (id obj in [result objectForKey:@"message"]) {
                            if ([obj isKindOfClass:[NSDictionary class]]) {
                                SADuanzi *duanzi = [[SADuanzi alloc]initWithDuanzi:obj];
                                [self.dataSource addObject:duanzi];
                                _latestId = duanzi.aid;
                                SACellModel *gray = [[SACellModel alloc]init];
                                gray.cellType = SACellTypeGrayCell;
                                [self.dataSource addObject:gray];
                            }else if ([obj isKindOfClass:[NSString class]]&&obj!=nil){
                                failure(obj);
                            }
                        }
                    }else if([message isKindOfClass:[NSString class]]){
                        failure(message);
                    }else{
                        failure(@"请求失败!");
                    }
                    
                    [self.tableView reloadData];
                }
            }else{
                failure(@"请求失败");
            }
        }else {
            if ([message isKindOfClass:[NSString class]]) {
                failure(message);
            }else{
                failure(@"请求失败");
            }
        }
    };
    
    [SVProgressHUD show];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:DEVICE_ID,@"device_id",@(_latestId),@"last_id",@"newest",@"type", nil];
    [SADiscoverRequest requestWithParameters:params
                           withIndicatorView:nil
                                     keyPath:nil
                                     mapping:nil
                           withCancelSubject:nil
                              onRequestStart:^(ITTBaseDataRequest *request) {
        
    }
                           onRequestFinished:^(ITTBaseDataRequest *request, ITTMappingResult *result) {
                               success(result.rawDictionary);
    }
                           onRequestCanceled:^(ITTBaseDataRequest *request) {
                               [SVProgressHUD dismiss];
                               [self.tableView.pullToRefreshView stopAnimating];
                               [self.tableView.infiniteScrollingView stopAnimating];
    }
                             onRequestFailed:^(ITTBaseDataRequest *request, NSError *error) {
                                 failure(error.localizedDescription);
    }];
}


- (CGFloat)caculateLabelSize:(UIFont *)font color:(UIColor *)color text:(NSString *)string size:(CGSize)size
{
    if (!string) {
        return 0;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:allRange];
    
    CGFloat titleHeight;
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:size
                                        options:options
                                        context:nil];
    titleHeight = ceilf(rect.size.height);
    
    return titleHeight+2;  // 加两个像素,防止emoji被切掉.
}
@end
