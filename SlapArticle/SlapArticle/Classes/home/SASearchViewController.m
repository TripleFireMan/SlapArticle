//
//  SASearchViewController.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/25.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SASearchViewController.h"
#import "SAHotWord.h"
#import "SAHottestKeyWordRequest.h"
#import "SASearchHotWordTableViewCell.h"
#import "SAKeyWordSearchRequest.h"
#import "SAArticle.h"
#import "SAArticleTableViewCell.h"
#import "SAShareView.h"
#import <ShareSDK/ShareSDK.h>
#import "SVProgressHUD.h"
#import "SVPullToRefresh.h"
#import "SANewArticleTableViewCell.h"
#import "SANewGrayTableViewCell.h"
#import "SAMarkArticleRequest.h"

#import "SAGetQuanwenRequest.h"

@interface SASearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _latestId;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;//热词tableview
@property (strong, nonatomic) IBOutlet UITableView *tableViewSearch;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) NSMutableArray *hotWordDataSource;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *keyWord;

@end

@implementation SASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationItems];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _latestId = 0;
    self.hotWordDataSource = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    [self startGetHotWord];

    
    __block typeof(self) weakSelf = self;
    
    [self.tableViewSearch addInfiniteScrollingWithActionHandler:^{
        [weakSelf startSearch:weakSelf.keyWord];
    }];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.view layoutSubviews];
}

- (void)startGetHotWord
{
    void (^success)(id result) = ^(id result){
        if ([result isKindOfClass:[NSArray class]]) {
            for (id obj in result) {
                SAHotWord *hotword = [[SAHotWord alloc]initWithHotWord:obj];
                [self.hotWordDataSource addObject:hotword];
            }
            [self.tableView reloadData];
        }
    };
    
    void(^failure)(NSString *) = ^(NSString *error){
    
    };
    
    [SAHottestKeyWordRequest requestWithParameters:nil
                                 withIndicatorView:nil
                                           keyPath:nil
                                           mapping:nil
                                 withCancelSubject:nil
                                    onRequestStart:^(ITTBaseDataRequest *request) {
        
    }
                                 onRequestFinished:^(ITTBaseDataRequest *request, ITTMappingResult *result) {
                                     NSLog(@"result = %@",result.rawDictionary);
                                     NSInteger status = [[result.rawDictionary valueForKey:@"state"]integerValue];
                                     id message = [result.rawDictionary valueForKey:@"message"];
                                     if (status == 1) {
                                         if ([message isKindOfClass:[NSArray class]]) {
                                             success(message);
                                         }else{
                                             failure(@"获取失败");
                                         }
                                     }else{
                                         if ([message isKindOfClass:[NSString class]]) {
                                             failure(message);
                                         }else{
                                             failure(@"获取失败");
                                         }
                                     }
                                     
    }
                                 onRequestCanceled:^(ITTBaseDataRequest *request) {
        
    }
                                   onRequestFailed:^(ITTBaseDataRequest *request, NSError *error) {
                                       failure(error.localizedDescription);
    }];
}

- (void)startSearch:(NSString *)keyword
{
    //只要开始搜索，最热关键字搜索页面就移除掉
    if (self.tableView.hidden == NO) {
        self.tableView.hidden = YES;
    }
    
    //搜索栏取消第一响应者身份
    [self.searchTF resignFirstResponder];
    
    void(^failuer)(NSString *error) = ^(NSString *error){
        [SVProgressHUD dismiss];
        [self.tableViewSearch.pullToRefreshView stopAnimating];
        [self.tableViewSearch.infiniteScrollingView stopAnimating];
        [SVProgressHUD showErrorWithStatus:error];
    };
    
    void(^success)(ITTMappingResult *result) = ^(ITTMappingResult *result) {
        [SVProgressHUD dismiss];
        [self.tableViewSearch.pullToRefreshView stopAnimating];
        [self.tableViewSearch.infiniteScrollingView stopAnimating];
        
        if (result.isSuccess) {
            if (_latestId == 0) {
                self.dataSource = [NSMutableArray array];
                SACellModel *gray = [[SACellModel alloc]init];
                gray.cellType = SACellTypeGrayCell;
                [self.dataSource addObject:gray];
                
                id message = [[result rawDictionary]objectForKey:@"message"];
                if (message && [message isKindOfClass:[NSArray class]]) {
                    for (id obj in [result.rawDictionary objectForKey:@"message"]) {
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
                }else{
                    failuer(message);
                }
                
                [self.tableViewSearch reloadData];
                
            }else{
                
                id message = [[result rawDictionary]objectForKey:@"message"];
                if (message && [message isKindOfClass:[NSArray class]]) {
                    for (id obj in [result.rawDictionary objectForKey:@"message"]) {
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
                [self.tableViewSearch reloadData];
            }
        }else{
            NSString *msg = [result.rawDictionary objectForKey:@"message"];
            if (msg != nil && [msg isKindOfClass:[NSString class]]) {
                failuer(msg);
            }
        }
    };
    
    
    NSString *requesturl = [SAGetQuanwenUrl stringByAppendingString:[NSString stringWithFormat:@"&last_id=%ld&device_id=%@&type=searchresult",(long)_latestId,DEVICE_ID]];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:keyword,@"keyword",nil];
    
    [SAKeyWordSearchRequest requestWithParameters:info withRequestUrl:requesturl withIndicatorView:nil keyPath:nil mapping:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
    } onRequestFinished:^(ITTBaseDataRequest *request, ITTMappingResult *result) {
        NSLog(@"info = %@",result.rawDictionary);
        success(result);
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        [SVProgressHUD dismiss];
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
    } onRequestFailed:^(ITTBaseDataRequest *request, NSError *error) {
        failuer(error.localizedDescription);
    }];
    
}

- (void)setUpNavigationItems
{
    SEL selLeft = @selector(handleNavigationLeftBarAction:);
    SEL selRight = @selector(handleNavigationRightBarAction:);
    
//    UIButton *leftBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, 40, 40)
//                                            title:@"取消"
//                                       titleColor:[UIColor whiteColor]
//                              titleHighlightColor:[UIColor lightTextColor]
//                                        titleFont:[UIFont systemFontOfSize:15]
//                                            image:nil
//                                      tappedImage:nil
//                                           target:self
//                                           action:selLeft
//                                              tag:0];
//    
//    UIButton *rightBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, 40, 40)
//                                             title:@"搜索"
//                                        titleColor:[UIColor whiteColor]
//                               titleHighlightColor:[UIColor lightTextColor]
//                                         titleFont:[UIFont systemFontOfSize:15]
//                                             image:nil
//                                       tappedImage:nil
//                                            target:self
//                                            action:selRight
//                                               tag:0];
    
//    UIBarButtonItem *leftItem              = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    UIBarButtonItem *leftItem              = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:selLeft];
    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:selRight];
    self.navigationItem.leftBarButtonItem  = leftItem ;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UIView *tfBackview = [[UIView alloc]initWithFrame:CGRectMake(20 + 44, 4, SCREEN_WIDTH - 64 * 2, 36)];
    tfBackview.backgroundColor = [UIColor whiteColor];
    
    UITextField *tf = ({
        UITextField *tmp    = [[UITextField alloc]initWithFrame:CGRectMake(10, 2, tfBackview.width - 10*2, 32)];
        
        if (IS_IOS_7) {
            tmp.tintColor   = [UIColor blueColor];
        }
        tmp.borderStyle     = UITextBorderStyleNone;
        tmp.delegate        = self;
        tmp.textColor       = [UIColor lightGrayColor];
        tmp.font            = [UIFont systemFontOfSize:13];
        tmp.returnKeyType   = UIReturnKeySearch;
        [tmp becomeFirstResponder];
        tmp;
    });
    self.searchTF = tf;
    [tfBackview addSubview:self.searchTF];
    self.navigationItem.titleView = tfBackview;
}


- (void)handleNavigationLeftBarAction:(id)sender
{
    [MobClick event:@"MobclickAgent16"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleNavigationRightBarAction:(id)sender
{
    [MobClick event:@"MobclickAgent15"];
    if ([self.searchTF.text isEqualToString:@""]) {
        [self.searchTF resignFirstResponder];
        [SVProgressHUD showErrorWithStatus:@"请输入搜索内容！"];
    }else{
        _latestId = 0;
        self.keyWord = [self.searchTF text];
        [self.dataSource removeAllObjects];
        [self.tableViewSearch reloadData];
        [self startSearch:self.keyWord];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TEXTFIELD_DELEGATE

//开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

//结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([[textField text]isEqualToString:@""]) {
        if (self.tableView.hidden == YES) {
            self.tableView.hidden = NO;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入搜索内容！"];
    }else{
        self.keyWord = [textField text];
        [self.dataSource removeAllObjects];
        [self.tableViewSearch reloadData];
        [self startSearch:self.keyWord];
    }
    return YES;
}

#pragma mark - tableViewDelegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        static NSString *identifier = @"hotCell";
        SASearchHotWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [SASearchHotWordTableViewCell loadFromXib];
        }
        SAHotWord *hotWord = [self.hotWordDataSource objectAtIndex:indexPath.row];
        cell.hotWord.text = hotWord.content;
        return cell;
    }else{
        
        __block SACellModel *model    = [self.dataSource objectAtIndex:indexPath.row];
        
        static NSString *identifierForArticel     = @"SANewArticleTableViewCell";
        static NSString *identifierForGrayCell    = @"grayCell";
        
        UITableViewCell *cell = nil;
        if (model.cellType == SACellTypeArticle) {
            
            
            SAArticle *article = (SAArticle *)model;
            
            SANewArticleTableViewCell * artcell = (SANewArticleTableViewCell *)cell;
            artcell  = [tableView dequeueReusableCellWithIdentifier:identifierForArticel];
            if (artcell == nil) {
                artcell = [SANewArticleTableViewCell loadFromXib];
            }
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
                        
                        [self.tableViewSearch beginUpdates];
                        [self.tableViewSearch reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [self.tableViewSearch endUpdates];
                    }
                        break;
                    case SAArticleCellBtnTypeShare:
                    {
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
                                article.appThumbCount -- ;
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
                    case SAArticleCellBtnTypeCopy:
                    {
                        
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
            if (cell == nil) {
                cell = [SANewGrayTableViewCell loadFromXib];
            }
            return cell;
        }
        
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return [self.hotWordDataSource count];
    }else{
        return [self.dataSource count];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        SAHotWord *hot = [self.hotWordDataSource objectAtIndex:indexPath.row];
        self.keyWord = hot.content;
        self.searchTF.text = hot.content;
        [self startSearch:hot.content];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        UIView *header = ({
            UIView *tmp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
            tmp.backgroundColor = RGBACOLOR(255, 255, 255, 1);
            
            UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 25)];
            sectionLabel.text = @"今日热搜";
            sectionLabel.textColor = RGBCOLOR(130, 130, 130);
            sectionLabel.backgroundColor = [UIColor clearColor];
            sectionLabel.font = [UIFont systemFontOfSize:13.f];
            [tmp addSubview:sectionLabel];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 24, SCREEN_WIDTH - 15, 1)];
            line.backgroundColor = RGBCOLOR(241, 241, 241);
            [tmp addSubview:line];
            
            tmp;
        });
        
        return header;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return 25.f;
    }else{
        return 0.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        return 44.f;
    }else{
        SACellModel *cellModel = [self.dataSource objectAtIndex:indexPath.row];
        
        switch (cellModel.cellType) {
            case SACellTypeArticle:
            {
                SAArticle *article = (SAArticle *)cellModel;
                CGFloat h          = 0;
                UIFont *font       = [UIFont systemFontOfSize:14.f];
                UIColor *color     = [UIColor darkGrayColor];
                CGSize size        = CGSizeMake(SCREEN_WIDTH - 20, 1000);
                CGFloat preHeight  = [self caculateLabelSize:font color:color text:article.contentPrew size:size];
                CGFloat nexHeight  = [self caculateLabelSize:font color:color text:article.contentNext size:size];
                
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
            default:
                break;
        }
        return 0;
    }
    return 0.f;
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
