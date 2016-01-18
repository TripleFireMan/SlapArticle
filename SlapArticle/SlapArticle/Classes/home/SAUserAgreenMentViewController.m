//
//  SAUserAgreenMentViewController.m
//  SlapArticle
//
//  Created by 成焱 on 15/12/13.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAUserAgreenMentViewController.h"
@interface SAUserAgreenMentViewController()
@property (nonatomic, strong) UIWebView *WebView;
@end
@implementation SAUserAgreenMentViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"用户协议"];
    
    self.WebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.diankaiquanwen.com/eula.html"]]];
    [self.view addSubview:self.WebView];
}
@end
