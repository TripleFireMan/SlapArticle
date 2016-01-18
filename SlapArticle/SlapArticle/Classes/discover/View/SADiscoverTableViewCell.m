//
//  SADiscoverTableViewCell.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/17.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SADiscoverTableViewCell.h"

@implementation SADiscoverTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)removeAllContraintFromView:(UIView *)view
{
    for (NSLayoutConstraint *cons in view.constraints) {
        [view removeConstraint:cons];
    }
    
    for (NSLayoutConstraint *cons  in view.superview.constraints) {
        if (cons.firstItem == view  || cons.secondItem == view) {
            [view.superview removeConstraint:cons];
        }
    }
}

- (void)resetConstraint
{
    
    
    [self removeAllContraintFromView:self.copyedBtn];
    [self removeAllContraintFromView:self.shareBtn];
    [self removeAllContraintFromView:self.reportBtn];
    
    self.copyedBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.copyedBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.copyedBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    float width = SCREEN_WIDTH / 3;
    float heigth = 36.f;
    
    DYConstrainsSetEdge(self.copyedBtn.superview, self.copyedBtn, NSLayoutAttributeLeading, 0);
    DYConstrainsSetEdge(self.copyedBtn.superview, self.copyedBtn, NSLayoutAttributeTop, 0);
    DYConstrainsSetWidthOrHeight(self.copyedBtn, NSLayoutAttributeWidth, width);
    DYConstrainsSetWidthOrHeight(self.copyedBtn, NSLayoutAttributeHeight, heigth);

    DYConstrainsSetEdge(self.shareBtn.superview, self.shareBtn, NSLayoutAttributeLeading, width *1);
    DYConstrainsSetEdge(self.shareBtn.superview, self.shareBtn, NSLayoutAttributeTop, 0);
    DYConstrainsSetWidthOrHeight(self.shareBtn, NSLayoutAttributeWidth, width);
    DYConstrainsSetWidthOrHeight(self.shareBtn, NSLayoutAttributeHeight, heigth);

    DYConstrainsSetEdge(self.reportBtn.superview, self.reportBtn, NSLayoutAttributeLeading, width *2);
    DYConstrainsSetEdge(self.reportBtn.superview, self.reportBtn, NSLayoutAttributeTop, 0);
    DYConstrainsSetWidthOrHeight(self.reportBtn, NSLayoutAttributeWidth, width);
    DYConstrainsSetWidthOrHeight(self.reportBtn, NSLayoutAttributeHeight, heigth);
    
    float w1 = 48 * (SCREEN_WIDTH/320);
    float w11 = 40 * (SCREEN_WIDTH/320);
    float h1 = 10.f;
    float w2 = 48 * (SCREEN_WIDTH/320);
    float w22 = 40 * (SCREEN_WIDTH/320);
    float h2 = 9.f;
    float w3 = 52 * (SCREEN_WIDTH/320);
    float w33 = 39 * (SCREEN_WIDTH/320);
    float h3 = 10.f;
    
    [self.copyedBtn setImageEdgeInsets:UIEdgeInsetsMake(h1, w1, 8, w11)];
    [self.shareBtn setImageEdgeInsets:UIEdgeInsetsMake(h2, w2, 8, w22)];
    [self.reportBtn setImageEdgeInsets:UIEdgeInsetsMake(h3, w3, 8, w33)];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleCopyAction:(id)sender {
//    if (self.callBack != nil) {
//        self.callBack(SAArticleCellBtnTypeCopy);
//    }
    
    if (self.duanzi) {
        if (self.duanzi.thumbed == 0) {
            self.callBack(SAArticleCellBtnTypeFavor);
        }else{
            self.callBack(SAArticleCellBtnTypeUnFavor);
        }
    }
}

- (IBAction)handleShareAction:(id)sender {
    if (self.callBack != nil) {
        self.callBack(SAArticleCellBtnTypeShare);
    }
}

- (IBAction)handleReportAction:(id)sender {
    [SVProgressHUD showSuccessWithStatus:@"举报成功"];
}
@end
