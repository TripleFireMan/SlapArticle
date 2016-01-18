//
//  GDTViewController.h
//  SlapArticle
//
//  Created by 成焱 on 15/11/22.
//  Copyright © 2015年 成焱. All rights reserved.
//  专门用来展示光电通的

#import <UIKit/UIKit.h>
typedef void (^GDTFinishedBlock)(void);
@interface GDTViewController : UIViewController
@property (nonatomic,copy) GDTFinishedBlock finish;
@property (nonatomic,assign) UIWindow *window;
@end
