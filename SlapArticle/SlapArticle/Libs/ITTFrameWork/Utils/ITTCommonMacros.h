//
//  ITTCommonMacros.h
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#ifndef iTotemFrame_ITTCommonMacros_h
#define iTotemFrame_ITTCommonMacros_h
////////////////////////////////////////////////////////////////////////////////
#pragma mark - shortcuts

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define DATA_ENV [ITTDataEnvironment sharedDataEnvironment]

#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]


////////////////////////////////////////////////////////////////////////////////
#pragma mark - common functions 

#define RELEASE_SAFELY(__POINTER) { if(__POINTER){[__POINTER release]; __POINTER = nil; }}


#pragma mark - 设备检测
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT_OF_IPHONE4       480
#define SCREEN_HEIGHT_OF_IPHONE5       568
#define SCREEN_HEIGHT_OF_IPHONE6       667
#define SCREEN_HEIGHT_OF_IPHONE6PLUS   736
#define isiPHONE4       ([UIScreen mainScreen].bounds.size.height == SCREEN_HEIGHT_OF_IPHONE4)
#define isiPHONE5       ([UIScreen mainScreen].bounds.size.height == SCREEN_HEIGHT_OF_IPHONE5)
#define is4InchScreen() ([UIScreen mainScreen].bounds.size.height == SCREEN_HEIGHT_OF_IPHONE5)
#define isiPHONE6       ([UIScreen mainScreen].bounds.size.height == SCREEN_HEIGHT_OF_IPHONE6)
#define isiPHONE6PLUS   ([UIScreen mainScreen].bounds.size.height == SCREEN_HEIGHT_OF_IPHONE6PLUS)
#define iPhone6PlusStatusHeight         27
#define iPhoneOtherStatusHeight         20
#define iPhone6PlusNavagationHeight     66
#define iPhoneOtherNavigationHeight     44
#define iPhoneVersionThan6          (isiPHONE6||isiPHONE6PLUS)
#define SCREEN_NAVIGATION_HEIGHT    (isiPHONE6PLUS?44:44)
#define SCREEN_STATUS_HEIGTH        (isiPHONE6PLUS?20:20)

#define kUserNeedLoginNotification  @"kUserNeedLoginNotification"

#pragma mark - 弧度角度转换
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

#pragma mark - 颜色宏定义
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define SHOULDOVERRIDE(basename, subclassname){ NSAssert([basename isEqualToString:subclassname], @"subclass should override the method!");}

#pragma mark - 字体大小定义

#define YKFONT0                  [UIFont systemFontOfSize:18]
#define YKFONT1                  [UIFont systemFontOfSize:22]
#define YKFONT2                  [UIFont systemFontOfSize:14]
#define YKFONT3                  [UIFont systemFontOfSize:12]


#pragma mark - 字符串判空
#define IS_STRING_NOT_EMPTY(sting)    (sting && ![@"" isEqualToString:sting] && (NSNull *)sting!=[NSNull null])
#define IS_STRING_EMPTY(sting)        (!sting || [@"" isEqualToString:sting] || (NSNull *)sting==[NSNull null])
#define SAFE_STRING(x)                (IS_STRING_EMPTY(x))?(@""):(x)

#pragma mark - 跟项目相关的
#define WBFAKEDATA              1
#define WBAnimationTime         0.35f
#define WBVerion                [[[NSBundle mainBundle] infoDictionary]valueForKey:@"CFBundleShortVersionString"]
#define WB_LINE_COLOR           RGBCOLOR(196,196,196)
#define WB_BACK_GROUND_COLOR    RGBCOLOR(239,239,239)
#define WB_BTNCOLOR             RGBCOLOR(253, 160, 29)
#define WB_VERSION              [[[NSBundle mainBundle] infoDictionary]valueForKey:@"CFBundleShortVersionString"]

#pragma mrak - 全局发送的通知
#define WB_NOTIFICATION_LOGIN   @"WB_NOTIFICATION_LOGIN"
#define WB_NOTIFICATION_LOGOUT  @"WB_NOTIFICATION_LOGOUT"

#ifdef DEBUG

#define YKLog(xx,...)   NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define YKLog(xx,...)  
#endif

#define IPHONE5SCALE(x) ((SCREEN_WIDTH * x) / 640)

#define FONT(x)         [UIFont systemFontOfSize:isiPHONE6PLUS?(x+2):(x)]

#pragma mark - 请求相关

#define RESULT_DATA     @"data"
                  
#endif