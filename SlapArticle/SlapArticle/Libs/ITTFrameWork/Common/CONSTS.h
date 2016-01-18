//
//  CONSTS.h
//  Hupan
//
//  Copyright 2010 iTotem Studio. All rights reserved.
//


#define REQUEST_DOMAIN @"http://cx.itotemstudio.com/api.php" // default env

//text
#define TEXT_LOAD_MORE_NORMAL_STATE @"向上拉动加载更多..."
#define TEXT_LOAD_MORE_LOADING_STATE @"更多数据加载中..."
#define DY_EXTERN   extern
#define NET_RESULT  @"result"
#define NET_CODE    @"status"
#define NET_MESSAGE @"message"
#define NET_DATA    @"data"
#define NET_SUCCESS    0
#define NET_ERR     @"网络连接错误，请检查网络"


//other consts
typedef enum{
	kTagWindowIndicatorView = 501,
	kTagWindowIndicator,
} WindowSubViewTag;

typedef enum{
    kTagHintView = 101
} HintViewTag;
typedef enum {
    DYSelectPhotoHeader,
    DYSelectPhotoHuZhao,
    DYSelectPhotoShenFenZheng,
}DYSelectPhotoType;
typedef enum {
    kDYSelectTypeSex,//性别选择
    kDYSelectTypeCountry,//国家选择
    kDYSelectTypeCity,//城市选择
    kDYSelectTypePlace,//景点选择
    kDYSelectTypeShowName,//显示名称选择
    kDYSelectTypeSimpleSex,//性别提交
}DYSelectType;

/**
 *  cell上面的按钮类型
 */
typedef NS_ENUM(NSInteger, SAArticleCellBtnType) {
    /**
     *  全文
     */
    SAArticleCellBtnTypeTotal,
    /**
     *  收起
     */
    SAArticleCellBtnTypeFoldUp,
    /**
     *  赞
     */
    SAArticleCellBtnTypeFavor,
    /**
     *  取消赞
     */
    SAArticleCellBtnTypeUnFavor,
    /**
     *  分享
     */
    SAArticleCellBtnTypeShare,
    /**
     *  复制
     */
    SAArticleCellBtnTypeCopy,
};

typedef void(^SAArilcleTotalCallBack)(SAArticleCellBtnType cellType);


#pragma mark - APP DATA

#define appHasLaunchedKey @"appHasLaunchedKey"
#define APPID             @"1054247558"

