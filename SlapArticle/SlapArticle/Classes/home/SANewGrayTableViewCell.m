//
//  SANewGrayTableViewCell.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/31.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SANewGrayTableViewCell.h"

@implementation SANewGrayTableViewCell
+ (id)loadFromXib
{
    id xib = [ITTXibViewUtils loadViewFromXibNamed:NSStringFromClass([self class])];
    return xib;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
