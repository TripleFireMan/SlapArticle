//
//  WBSDK.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/27.
//  Copyright © 2015年 成焱. All rights reserved.
//

#ifndef WBSDK_h
#define WBSDK_h

#import "WBCommonBlock.h"
#import "WBLogUtils.h"

#ifdef                 DEBUG
#define NSLog(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
#define NSLog(x...)    ((void)0)
#endif

#endif /* WBSDK_h */
