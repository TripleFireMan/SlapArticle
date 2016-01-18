//
//  User.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/21.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "User.h"


static User *user = nil;

@implementation User

+ (User *)current
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (user == nil) {
            user = [User new];
        }
    });
    return user;
}
@end
