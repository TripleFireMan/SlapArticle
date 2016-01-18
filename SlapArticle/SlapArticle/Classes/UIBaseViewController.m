//
//  UIBaseViewController.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/17.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "UIBaseViewController.h"

@interface UIBaseViewController ()

@end

@implementation UIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackBarItem];
    self.view.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackBarItem
{
    UIBarButtonItem *backBar = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 44, 41);
        btn.backgroundColor = [UIColor redColor];
        [btn setImage:[UIImage imageNamed:@"sa_back"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 10, 15)];
        [btn addTarget:self action:@selector(handleBackAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *tmp = [[UIBarButtonItem alloc]initWithCustomView:btn];
        tmp.title = @"";
        tmp;
    });
    
    
    self.navigationItem.backBarButtonItem = backBar;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)handleBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    text1 = @"结果我获得了永生";
    //上下文的大小
    int w = img.size.width;
    int h = img.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//创建颜色
    //创建上下文
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);//将img绘至context上下文中
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);//设置颜色
    char* text = (char *)[text1 cStringUsingEncoding:NSUTF8StringEncoding];
    CGContextSelectFont(context, "Georgia", 30, kCGEncodingMacRoman);//设置字体的大小
    CGContextSetTextDrawingMode(context, kCGTextFill);//设置字体绘制方式
    CGContextSetRGBFillColor(context, 255, 0, 0, 1);//设置字体绘制的颜色
    CGContextShowTextAtPoint(context, w/2-strlen(text)*5, h/2, text, strlen(text));//设置字体绘制的位置
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);//创建CGImage
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];//获得添加水印后的图片 
}

-(UIImage *)CSImage:(UIImage *)img AddText:(NSString *)text
{
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    view.image = img;
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    
    [label setNumberOfLines:0];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor redColor];
    NSString *s = text;
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake(320,2000);
    
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(0,0, labelsize.width, labelsize.height);
    label.text = text;
    [view addSubview:label];
    
    return [self convertViewToImage:view];
}

-(UIImage*)convertViewToImage:(UIView*)v
{
    CGSize s = v.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [v.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    v.layer.contents = nil;
    return image; 
    
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
