//
//  SAArticleViewController.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/18.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAArticleViewController.h"
#import "ITTPullTableView.h"
#import <ShareSDK/ShareSDK.h>
#import "SAShareView.h"
#import "SASearchViewController.h"
#import "SAArticle.h"
#import "SVProgressHUD.h"
#import "SAArticleTableViewCell.h"
#import "SAContributeViewController.h"
#import "SAFavourRequest.h"
#import "SAUnfavourRequest.h"
#import "SAShareStatisticRequest.h"
#import "SAClickArticleStatisticsRequest.h"
#import "SAMarkArticleRequest.h"
#import "UIImage+waterMarker.h"
#import "SAGetQuanwenRequest.h"
#import "SANewGrayTableViewCell.h"
#import "SAWeChatLoginView.h"
typedef NS_ENUM(NSInteger, SAArticleFilterType) {
    SAArticleFilterTypeLatest,//最新
    SAArticleFilterTypePerfect,//精选
};

@interface SAArticleViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSInteger _latestId;
}
@property (weak, nonatomic) IBOutlet UIImageView *lineView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) SAArticleFilterType filterType;

@property (nonatomic, retain) NSMutableArray *dataSource;

- (IBAction)handleBtnAction:(id)sender;
@end

@implementation SAArticleViewController
- (id)init
{
    self = [super init];
    if (self) {
        self.filterType = SAArticleFilterTypeLatest;
        

        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray arrayWithCapacity:10];
    _latestId = 0;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        _latestId = 0;
        [self startRequestWithLastId:_latestId filterType:self.filterType];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self startRequestWithLastId:_latestId filterType:self.filterType];
    }];
    
    [self.tableView triggerPullToRefresh];
    
    SEL selLeft = @selector(handleNavigationLeftBarAction:);
    SEL selRight = @selector(handleNavigationRightBarAction:);
    
    NSString *title = @"搜索";
    
    if (self.isPresent) {
        title = @"关闭";
    }
    
    UIButton *leftBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, 40, 40)
                                            title:title
                                       titleColor:[UIColor whiteColor]
                              titleHighlightColor:[UIColor lightTextColor]
                                        titleFont:[UIFont systemFontOfSize:15]
                                            image:nil
                                      tappedImage:nil
                                           target:self
                                           action:selLeft
                                              tag:0];
    
    UIButton *rightBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, 40, 40)
                                             title:@"投稿"
                                        titleColor:[UIColor whiteColor]
                               titleHighlightColor:[UIColor lightTextColor]
                                         titleFont:[UIFont systemFontOfSize:15]
                                             image:nil
                                       tappedImage:nil
                                            target:self
                                            action:selRight
                                               tag:0];
    
    UIBarButtonItem *leftItem              = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
//    UIBarButtonItem *leftItem              = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:selLeft];
//    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:selRight];
    self.navigationItem.leftBarButtonItem  = leftItem ;
    if (![self isPresent]) {
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    
    [SAWeChatLoginView showWithActive:^(enum SAWeChatActive avtive) {
        
    }];

}

- (void)referenceView:(id)sender
{
    [self refreshViewByFilter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)handleBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *title = [[btn titleLabel]text];
    if ([title isEqualToString:@"最新"]) {
        if (self.filterType == SAArticleFilterTypeLatest) {
            return;
        }
    }else{
        if (self.filterType == SAArticleFilterTypePerfect) {
            return;
        }
    }
    
    [self.tableView setContentOffset:CGPointZero];
    [self changeFilterTypeFrom:self.filterType to:[self getWillChangedFilterType]];
    
    [self refreshViewByFilter];
}

- (void)handleNavigationLeftBarAction:(id)sender
{
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [MobClick event:@"MobclickAgent9"];
        SASearchViewController *search = [[SASearchViewController alloc]initWithNibName:@"SASearchViewController" bundle:nil];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:search];
        navi.navigationBar.barTintColor = RGBCOLOR(72, 179, 166);
        [self presentViewController:navi animated:YES completion:nil];
    }
}

- (void)handleNavigationRightBarAction:(id)sender
{
    [MobClick event:@"MobclickAgent8"];
    SAContributeViewController *contribute = [[SAContributeViewController alloc]init];
    contribute.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:contribute animated:YES];
}

#pragma mark - LINE CONFIG

- (void)refreshViewByFilter
{
    _latestId = 0;
    [self startRequestWithLastId:_latestId filterType:self.filterType];
}

- (SAArticleFilterType)getWillChangedFilterType
{
    if (self.filterType == SAArticleFilterTypeLatest) {
        return SAArticleFilterTypePerfect;
    }else{
        return SAArticleFilterTypeLatest;
    }
}

- (void)changeFilterTypeFrom:(SAArticleFilterType)fromType to:(SAArticleFilterType)toType
{
    self.filterType = toType;
    [self configLineView];
}

- (void)configLineView
{
    CGFloat constant = 25.f;
    
    UIView *superview = self.lineView.superview;
    
    CGFloat leadingConstant = self.filterType == SAArticleFilterTypeLatest ? constant : constant + superview.width / 2;
    CGFloat trailingConstant = self.filterType == SAArticleFilterTypeLatest ? constant : constant -superview.width / 2;
    
    [superview layoutIfNeeded];
    [UIView animateWithDuration:0.35f animations:^{
        for (NSLayoutConstraint *constraint in self.lineView.superview.constraints) {
            
            if (constraint.firstItem == self.lineView && constraint.firstAttribute == NSLayoutAttributeLeading) {
                constraint.constant = leadingConstant;
            }
            if (constraint.secondAttribute == NSLayoutAttributeTrailing && constraint.secondItem == self.lineView) {
                constraint.constant = trailingConstant;
            }
        }
        [superview layoutIfNeeded];
    }];
}

#pragma mark - tableViewDelegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierForArticel     = @"cell";
    static NSString *identifierForGrayCell    = @"grayCell";
    
    __kindof UITableViewCell *cell = nil;
    __block SACellModel *model    = [self.dataSource objectAtIndex:indexPath.row];

    if (model.cellType == SACellTypeArticle) {
        
        SAArticle *article = (SAArticle *)model;
        
        __block SAArticleTableViewCell * artcell = cell;
        artcell                          = [tableView dequeueReusableCellWithIdentifier:identifierForArticel];
        artcell.article = (SAArticle *)model;
        artcell.articleLabel.text = [(SAArticle *)model contentPrew];
        if ([(SAArticle *)model isShowTotal]) {
            artcell.articleNextLabel.text = [(SAArticle *)model contentNext];
            [artcell.totalBtn setTitle:[NSString stringWithFormat:@"收起"] forState:UIControlStateNormal];
        }else{
            artcell.articleNextLabel.text = nil;
            [artcell.totalBtn setTitle:[NSString stringWithFormat:@"全文"] forState:UIControlStateNormal];
        }
        BOOL thumbed = [article thumbed];
        
        [artcell.zanBtn setImage:thumbed?[UIImage imageNamed:@"sa_zan_full"]:[UIImage imageNamed:@"sa_zan_empty"] forState:UIControlStateNormal];
        
        artcell.callBack = ^(SAArticleCellBtnType type){
            
            switch (type) {
                case SAArticleCellBtnTypeTotal:
                case SAArticleCellBtnTypeFoldUp:
                {
                    model.isShowTotal = !model.isShowTotal;
                    if (model.isShowTotal == YES) {
                        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@([article aid]),@"id",@"read",@"type", nil];
                        [SAMarkArticleRequest requestWithParameters:params withIndicatorView:nil keyPath:nil mapping:nil onRequestFinished:nil];
                        
                    }
                    [self.tableView beginUpdates];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                }
                    break;
                case SAArticleCellBtnTypeShare:
                {
                    [MobClick event:@"MobclickAgent5"];
                    [SAShareView showWithImages:@[[UIImage imageNamed:@"wechattimeline"],
                                                  [UIImage imageNamed:@"wechat"],
                                                  [UIImage imageNamed:@"qzone"],
                                                  [UIImage imageNamed:@"qq"],
                                                  [UIImage imageNamed:@"sina_weibo"],
                                                  [UIImage imageNamed:@"sa_message"]]
                                          title:@[@"朋友圈",@"微信好友",@"qq空间",@"QQ好友",@"新浪微博",@"短信"]
                                      callBacks:^(NSInteger index){
                                          
                                          
                                          NSArray *platforms = @[@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeSMS)];
                                          
                                          NSString *quanwen = [[[article contentPrew]stringByAppendingString:@"\r\r\r\r\r\r\r"]stringByAppendingString:article.contentNext];
                                          
                                          NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                                          
                                          BOOL needImage = NO;
                                          NSArray *imgArray = [NSArray arrayWithObject:[UIImage imageNamed:@"icon_our"]];
                                          if (index == 2) {
                                              needImage = YES;
                                          }else if (index == 4){
                                              needImage = YES;
                                              quanwen = [article contentPrew];
                                              article.contentNext = [@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" stringByAppendingString:article.contentNext];
                                              UIImage *watermarker = [[UIImage imageNamed:@"drawable_bg"]watermarkImage:article.contentNext];
                                              imgArray = [NSArray arrayWithObject:watermarker];
                                          }
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
                                                       
                                                       NSString *articleId  = [NSString stringWithFormat:@"%ld",(long)[article aid]];
                                                       NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:articleId,@"id",@"share",@"type", nil];
                                                       
                                                       article.appShareCount ++;
                                                       [tableView beginUpdates];
                                                       [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                       [tableView endUpdates];
                                                       
                                                       [SAMarkArticleRequest requestWithParameters:params withIndicatorView:nil keyPath:nil mapping:nil onRequestFinished:nil];
                                                       
                                                       [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                                   }
                                                       break;
                                                   default:
                                                       break;
                                               }
                                           }];
                                      }
                                          heiht:160
                                      animation:YES];
                }
                    break;
                case SAArticleCellBtnTypeFavor:
                {
                    [MobClick event:@"MobclickAgent4"];
                    
                    NSString *articleId  = [NSString stringWithFormat:@"%ld",(long)[article aid]];
                    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:articleId,@"id",DEVICE_ID,@"device_id",@"thumb",@"type", nil];
                    
                    [SAMarkArticleRequest requestWithParameters:params withIndicatorView:nil keyPath:nil mapping:nil withCancelSubject:nil onRequestStart:nil onRequestFinished:^(ITTBaseDataRequest *request, ITTMappingResult *result) {
                        NSLog(@"result = %@",result.rawDictionary);
                        NSInteger state = [[result.rawDictionary valueForKey:@"state"]integerValue];
                        if (state == 1) {
                            article.thumbed = 1;
                            article.appThumbCount ++;
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
                    NSString *articleId  = [NSString stringWithFormat:@"%ld",(long)[article aid]];
                    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:articleId,@"id",DEVICE_ID,@"device_id",@"cancelthumb",@"type", nil];
                    
                    [SAMarkArticleRequest requestWithParameters:params withIndicatorView:nil keyPath:nil mapping:nil withCancelSubject:nil onRequestStart:nil onRequestFinished:^(ITTBaseDataRequest *request, ITTMappingResult *result) {
                        NSLog(@"result = %@",result.rawDictionary);
                        NSInteger state = [[result.rawDictionary valueForKey:@"state"]integerValue];
                        if (state == 1) {
                            article.thumbed = 0;
                            if (article.appThumbCount > 0) {
                                article.appThumbCount --;
                            }
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
        [artcell.shareBtn setTitle:[NSString stringWithFormat:@"%ld",(long)article.appShareCount] forState:UIControlStateNormal];
        [artcell.zanBtn setTitle:[NSString stringWithFormat:@"%ld",(long)article.appThumbCount] forState:UIControlStateNormal];
        return artcell;
    
    }else if (model.cellType == SACellTypeGrayCell){
        cell = [tableView dequeueReusableCellWithIdentifier:identifierForGrayCell];
        
        return cell;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SACellModel *cellModel = [self.dataSource objectAtIndex:indexPath.row];
    switch (cellModel.cellType) {
        case SACellTypeArticle:
        {
            SAArticle *article = (SAArticle *)cellModel;
            CGFloat h = 0;
            UIFont *font = [UIFont systemFontOfSize:14.f];
            UIColor *color = [UIColor darkGrayColor];
            CGSize size = CGSizeMake(SCREEN_WIDTH - 20, 1000);
            CGFloat preHeight = [self caculateLabelSize:font color:color text:article.contentPrew size:size];
            CGFloat nexHeight = [self caculateLabelSize:font color:color text:article.contentNext size:size];
            
            if ([article isShowTotal]) {
                h = preHeight + 8 + nexHeight + 36 + 30 + 40;
            }else{
                h = preHeight + 8 + 36 + 30 + 40;
            }
            
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



#pragma mark - DATA

- (void)startRequestWithLastId:(NSInteger)lastid filterType:(SAArticleFilterType)filterType
{
    NSString *type = @"";
    if (filterType == SAArticleFilterTypeLatest) {
        type = @"newest";
    }else{
        type = @"hottest";
    }
//    NSString *requestUrl = @"";
//    if (filterType == SAArticleFilterTypeLatest)/*最新*/ {
//        requestUrl = SATotalArticleUrl;
//    }else/*精选*/{
//        requestUrl = SAPerfectArticleUrl;
//    }
    
    void(^failuer)(NSString *error) = ^(NSString *error){
        [SVProgressHUD dismiss];
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
        [SVProgressHUD showErrorWithStatus:error];
    };
    
    void(^success)(ITTMappingResult *result) = ^(ITTMappingResult *result) {
        [SVProgressHUD dismiss];
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
        NSLog(@"RESULT = %@",result.rawDictionary);
        if (result.isSuccess) {
            if (_latestId == 0) {
                self.dataSource = [NSMutableArray array];
                SACellModel *gray = [[SACellModel alloc]init];
                gray.cellType = SACellTypeGrayCell;
                [self.dataSource addObject:gray];
                id message = [result.rawDictionary valueForKey:@"message"];
                if (message && [message isKindOfClass:[NSArray class]]) {
                    for (id obj in message) {
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            SAArticle *article = [[SAArticle alloc]initWithData:obj];
                            [self.dataSource addObject:article];
                            _latestId = article.aid;
                            SACellModel *gray = [[SACellModel alloc]init];
                            gray.cellType = SACellTypeGrayCell;
                            [self.dataSource addObject:gray];
                        }else if ([obj isKindOfClass:[NSString class]]&&obj!=nil){
                            failuer(obj);
                        }
                    }
                }else if([message isKindOfClass:[NSString class]]){
                    failuer(message);
                }else{
                    failuer(@"请求失败!");
                }
                [self.tableView reloadData];

            }else{
                id message = [result.rawDictionary valueForKey:@"message"];
                if (message && [message isKindOfClass:[NSArray class]]) {
                    for (id obj in message) {
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            SAArticle *article = [[SAArticle alloc]initWithData:obj];
                            [self.dataSource addObject:article];
                            _latestId = article.aid;
                            SACellModel *gray = [[SACellModel alloc]init];
                            gray.cellType = SACellTypeGrayCell;
                            [self.dataSource addObject:gray];
                        }else if ([obj isKindOfClass:[NSString class]]&&obj!=nil){
                            failuer(obj);
                        }
                    }
                }else if([message isKindOfClass:[NSString class]]){
                    failuer(message);
                }else{
                    failuer(@"请求失败!");
                }
                
                [self.tableView reloadData];
            }
        }else{
            NSString *msg = [result.rawDictionary objectForKey:@"message"];
            if (msg != nil && [msg isKindOfClass:[NSString class]]) {
                failuer(msg);
            }
        }
    };
    
    
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:lastid],@"last_id",DEVICE_ID,@"device_id",type,@"type", nil];
    
    
    [SAGetQuanwenRequest requestWithParameters:info withIndicatorView:nil keyPath:nil mapping:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
    } onRequestFinished:^(ITTBaseDataRequest *request, ITTMappingResult *result) {
        success(result);
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        [SVProgressHUD dismiss];
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
    } onRequestFailed:^(ITTBaseDataRequest *request, NSError *error) {
        failuer(error.localizedDescription);
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

