//
//  UIImage+waterMarker.m
//  SlapArticle
//
//  Created by 成焱 on 15/11/28.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "UIImage+waterMarker.h"

@implementation UIImage (waterMarker)
- (UIImage *)watermarkImage:(NSString *)text{
    
    
    
    //1.获取上下文
    
    UIGraphicsBeginImageContext(self.size);
    
    
    
    //2.绘制图片
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    
    
    //3.绘制水印文字
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    
    style.alignment = NSTextAlignmentCenter;
    
    //文字的属性
    
    NSDictionary *dic = @{
                          
                          NSFontAttributeName:[UIFont systemFontOfSize:13],
                          
                          NSParagraphStyleAttributeName:style,
                          
                          NSForegroundColorAttributeName:[UIColor blackColor]
                          
                          };
    
    //将文字绘制上去
    
    [text drawInRect:rect withAttributes:dic];
    
    
    
    //4.获取绘制到得图片
    
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    //5.结束图片的绘制
    
    UIGraphicsEndImageContext();
    
    
    
    return watermarkImage;
    
}


@end
