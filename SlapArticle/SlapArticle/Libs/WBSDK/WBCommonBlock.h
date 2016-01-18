//
//  WBCommonBlock.h
//  SlapArticle
//
//  Created by 成焱 on 15/10/27.
//  Copyright © 2015年 成焱. All rights reserved.
//

#ifndef WBCommonBlock_h
#define WBCommonBlock_h

typedef void (^WBNetSuccess)(id);
typedef void (^WBNetError)(NSString *);

#define WB_WEAK_SELF(x) __block typeof(self) x = self

#endif /* WBCommonBlock_h */
