//
//  SAUrl.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/17.
//  Copyright © 2015年 成焱. All rights reserved.
//
#import "SvUDIDTools.h"

#ifndef SAURL
#define SAURL
#define SAEXTERN    extern
#define SA_DEBUG    1

#define SA_TOKEN    @"3610ce6af5e4d8d3ccc07c5ae2a5068b"//接口加密用token


SAEXTERN NSString *const SAGetQuanwenUrl;           //获取全文

SAEXTERN NSString *const SAHottestWordsUrl;         //获取热词
SAEXTERN NSString *const SAKeyWordSearchUrl;        //搜索关键字
SAEXTERN NSString *const SADuanziUrl;               //获取段子
SAEXTERN NSString *const SAContributeUrl;           //投稿
SAEXTERN NSString *const SAFavourUrl;               //点赞
SAEXTERN NSString *const SAUnfavourUrl;             //取消赞
SAEXTERN NSString *const SAShareStatistics;         //分享统计
SAEXTERN NSString *const SAClickArticleStatistics;  //用户点开全文动作上报

#pragma mark - NEW_INTERFACE

SAEXTERN NSString *const SAMarkArticleStatisticsUrl;//点赞和取消赞全文
SAEXTERN NSString *const SAMarkDuanziStatisticsUrl;//点赞和取消赞段子
#define DEVICE_ID   [SvUDIDTools UDID]

#endif
