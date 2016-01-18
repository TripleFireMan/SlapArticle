//
//  SASearchHotWordTableViewCell.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/25.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTXibViewUtils.h"
@interface SASearchHotWordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hotWord;

+ (id)loadFromXib;

@end
