//
//  SAContributeViewController.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/31.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAContributeViewController.h"
#import "SAArticleContributeRequest.h"
#import "WBValid.h"
#import <CoreText/CoreText.h>
#import  "SVProgressHUD.h"
#import "SAUserAgreenMentViewController.h"

@interface SAContributeViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *agreenBtn;

- (IBAction)handleContributeAction:(id)sender;
- (IBAction)handleTapBackAction:(id)sender;
- (IBAction)handleUserAgreement:(id)sender;
- (IBAction)handleAgreenBtn:(id)sender;


@end

@implementation SAContributeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投稿";
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self loadTextViewDefaultText];
    
    [self.agreenBtn setSelected:[[NSUserDefaults standardUserDefaults] boolForKey:@"user_agreen"]];
    
}


- (void)loadTextViewDefaultText
{
    [self.textView setAttributedText:[self attributedText]];
}


// 获取带有不同样式的文字内容
- (NSAttributedString *)attributedText {
    
    
    NSString *sourceString = @"复制朋友圈中的搞笑段子，并在这里粘贴（当然我们更欢迎您的原创作品）~";
    NSString *string1 = @"复制朋友圈中的搞笑段子，并在这里粘贴（";
    NSString *string2 = @"当然我们更欢迎您的原创作品";
    NSString *string3 = @"）~";
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:sourceString];
    
    NSRange rang1 = [sourceString rangeOfString:string1];
    NSRange rang2 = [sourceString rangeOfString:string2];
    NSRange rang3 = [sourceString rangeOfString:string3];
    
    NSDictionary * a1= @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f],
                                              NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                              NSBackgroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary * a2 = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f],
                                              NSForegroundColorAttributeName: [UIColor redColor],
                                              NSBackgroundColorAttributeName: [UIColor whiteColor]};
    
    [attributeStr setAttributes:a1 range:rang1];
    [attributeStr setAttributes:a2 range:rang2];
    [attributeStr setAttributes:a1 range:rang3];
    
    return attributeStr;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)handleContributeAction:(id)sender {
    NSString *phoneNum = [self.textField text];
    
    if (![WBValid validateMobile:phoneNum]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
        return;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL agreen = [userDefault boolForKey:@"user_agreen"];
    
    if (!agreen) {
        [SVProgressHUD showErrorWithStatus:@"请您先阅读用户协议"];
        return;
    }
    
    NSString *content = [self.textView text];
    
    NSString *keyctring = @"\n";
    NSString *anOtherKeyctring = @"\r";
    
    NSRange range = [content rangeOfString:keyctring];
    
    if (range.location == NSNotFound) {
        range = [content rangeOfString:anOtherKeyctring];
        if (range.location == NSNotFound) {
            [SVProgressHUD showErrorWithStatus:@"上文与下文中间需要换行！"];
            return;
        }else{
            NSLog(@"find location is %ld",range.location);
        }
    }else{
        NSLog(@"find location is %ld",range.location);
    }
    NSString *prefix = [content substringToIndex:range.location];
    NSString *suffix  = [content substringFromIndex:range.location];
    
    suffix = [suffix stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (prefix == nil || [prefix isEqualToString:@""] || suffix == nil || [suffix isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"全文格式不正确"];
        return;
    }
    
    [params setObject:phoneNum forKey:@"phone"];
    [params setObject:prefix forKey:@"quanwen_prev"];
    [params setObject:suffix forKey:@"quanwen_nxt"];
    
    [SVProgressHUD show];
    
    [SAArticleContributeRequest requestWithParameters:params withIndicatorView:nil keyPath:nil mapping:nil withCancelSubject:nil onRequestStart:nil onRequestFinished:^(ITTBaseDataRequest *request, ITTMappingResult *result) {
        
        NSInteger state = [[result.rawDictionary objectForKey:@"state"]integerValue];
        NSString *message = [result.rawDictionary objectForKey:@"message"];
        if (state == 1) {
            [SVProgressHUD showSuccessWithStatus:@"我们已经收到你的来搞，请等待小编和你联系，谢谢。"];
        }else{
            [SVProgressHUD showErrorWithStatus:message];
        }
        
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        [SVProgressHUD dismiss];
    } onRequestFailed:^(ITTBaseDataRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

- (IBAction)handleTapBackAction:(id)sender {
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
}

- (IBAction)handleUserAgreement:(id)sender {
    
    SAUserAgreenMentViewController *user = [[SAUserAgreenMentViewController alloc]init];
    [self.navigationController pushViewController:user animated:YES];
    
}

- (IBAction)handleAgreenBtn:(id)sender {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL agreen = [userDefault boolForKey:@"user_agreen"];
    
    if (agreen == YES) {
        [userDefault setBool:NO forKey:@"user_agreen"];
        self.agreenBtn.selected = NO;
    }else{
        [userDefault setBool:YES forKey:@"user_agreen"];
        self.agreenBtn.selected = YES;
    }
}

#pragma mark - TEXT_FIELD_DELEGATE

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark - TEXT_VIEW_DELEGATE
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //如果文本框中现在的文字是提示文字，清除掉即可
    if ([textView.text isEqualToString:@"复制朋友圈中的搞笑段子，并在这里粘贴（当然我们更欢迎您的原创作品）~"]) {
        textView.text = nil;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView text] == nil || [[textView text]isEqualToString:@""]) {
        [self loadTextViewDefaultText];
    }
}

@end
