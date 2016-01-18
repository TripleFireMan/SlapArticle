//
//  SAArticleTableViewCell.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/18.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAArticleTableViewCell.h"
@interface SAArticleTableViewCell()
- (IBAction)handleBtnAction:(id)sender;

@end
@implementation SAArticleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self resetConstraint];
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
    [self removeAllContraintFromView:self.zanBtn];
    [self removeAllContraintFromView:self.shareBtn];
    [self removeAllContraintFromView:self.reportBtn];
    
    
    
    float width = SCREEN_WIDTH / 3;
    float heigth = 36.f;
    
    DYConstrainsSetEdge(self.zanBtn.superview, self.zanBtn, NSLayoutAttributeLeading, 0);
    DYConstrainsSetEdge(self.zanBtn.superview, self.zanBtn, NSLayoutAttributeTop, 0);
    DYConstrainsSetWidthOrHeight(self.zanBtn, NSLayoutAttributeWidth, width);
    DYConstrainsSetWidthOrHeight(self.zanBtn, NSLayoutAttributeHeight, heigth);
    
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
    
    [self.zanBtn setImageEdgeInsets:UIEdgeInsetsMake(h1, w1, 8, w11)];
    [self.shareBtn setImageEdgeInsets:UIEdgeInsetsMake(h2, w2, 8, w22)];
    [self.reportBtn setImageEdgeInsets:UIEdgeInsetsMake(h3, w3, 8, w33)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)handleTotalBtnAction:(id)sender {
    if (self.callBack) {
        self.callBack(self.article.isShowTotal?SAArticleCellBtnTypeTotal:SAArticleCellBtnTypeFoldUp);
    }
}
- (IBAction)handleBtnAction:(id)sender {
    NSInteger tag = [(UIButton *)sender tag];
    if (tag == 1) {
        if (self.article.thumbed == 0) {
            self.callBack(SAArticleCellBtnTypeFavor);
        }else{
            self.callBack(SAArticleCellBtnTypeUnFavor);
        }
        
    }else if (tag == 2){
        self.callBack(SAArticleCellBtnTypeShare);
    }else if (tag == 3){
        [SVProgressHUD showSuccessWithStatus:@"举报成功"];
    }
}
@end
