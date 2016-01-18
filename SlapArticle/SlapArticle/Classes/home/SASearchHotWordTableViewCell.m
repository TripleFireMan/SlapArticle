//
//  SASearchHotWordTableViewCell.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/25.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SASearchHotWordTableViewCell.h"

@implementation SASearchHotWordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (id)loadFromXib
{
    id xib = [ITTXibViewUtils loadViewFromXibNamed:NSStringFromClass([self class])];
    return xib;
}

@end
