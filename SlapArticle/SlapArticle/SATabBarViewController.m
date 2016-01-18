//
//  SATabBarViewController.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/17.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SATabBarViewController.h"

@interface SATabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation SATabBarViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tabBar.tintColor = RGBCOLOR(72, 179, 166);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"viewcontroller = %@",viewController);
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
