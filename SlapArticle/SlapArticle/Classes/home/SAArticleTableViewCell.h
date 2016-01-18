//
//  SAArticleTableViewCell.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/18.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAArticle.h"   

@interface SAArticleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *articleLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleNextLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *totalBtn;
@property (copy, nonatomic) SAArilcleTotalCallBack callBack;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;
@property (retain, nonatomic)SAArticle *article;

- (IBAction)handleTotalBtnAction:(id)sender;
@end
