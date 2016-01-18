//
//  SANewArticleTableViewCell.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/31.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTXibViewUtils.h"
#import "SAArticle.h"

@interface SANewArticleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *articleLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleNextLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *totalBtn;

@property (weak, nonatomic) IBOutlet UIButton *reportBtn;
@property (copy, nonatomic) SAArilcleTotalCallBack callBack;
@property (retain, nonatomic)SAArticle *article;
+ (id)loadFromXib;
- (IBAction)handleTotalBtnAction:(id)sender;
@end
