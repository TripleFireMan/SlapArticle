//
//  SADiscoverTableViewCell.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/17.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SADuanzi.h"

@interface SADiscoverTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *articleLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *copyedBtn;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;

@property (copy, nonatomic) SAArilcleTotalCallBack callBack;
@property (retain, nonatomic) SADuanzi *duanzi;

- (IBAction)handleCopyAction:(id)sender;
- (IBAction)handleShareAction:(id)sender;
- (IBAction)handleReportAction:(id)sender;
- (void)resetConstraint;

@end
