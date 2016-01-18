//
//  ITTBaseDataRequest.h
//
//
//  Created by lian jie on 6/22/11.
//  Copyright 2011 iMobile. All rights reserved.
//
#import "ITTRequestResult.h"
#import "ITTDataCacheManager.h"
#import "ITTMaskActivityView.h"
#import "ITTNetwork.h"
#import "ITTMappingResult.h"
#define USE_DUMPY_DATA	NO

@class ITTObjectMapping;


typedef enum : NSUInteger{
    ITTRequestMethodGet = 0,
    ITTRequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
    ITTRequestMethodMultipartPost = 2,   // content type = @"multipart/form-data"
} ITTRequestMethod;

@class ITTRequestDataHandler;
@class ITTBaseDataRequest;

@protocol DataRequestDelegate <NSObject>

@optional
- (void)requestDidStartLoad:(ITTBaseDataRequest*)request;
- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request;
- (void)requestDidCancelLoad:(ITTBaseDataRequest*)request;
- (void)request:(ITTBaseDataRequest*)request progressChanged:(CGFloat)progress;
- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error;

@end

@interface ITTBaseDataRequest : NSObject
{
@protected
    BOOL        _useSilentAlert;
    BOOL        _usingCacheData;
    
    DataCacheManagerCacheType _cacheType;
    ITTMaskActivityView       *_maskActivityView;
    
    //progress related
    long long _totalData;
    long long _downloadedData;
    CGFloat   _currentProgress;
    
    NSString    *_cancelSubject;
    NSString    *_cacheKey;
    NSString    *_filePath;
    NSString    *_keyPath;
    NSDate      *_requestStartDate;
    
    
    //callback stuffs
    void (^_onRequestStartBlock)(ITTBaseDataRequest *);
    void (^_onRequestFinishBlock)(ITTBaseDataRequest *, ITTMappingResult *);
    void (^_onRequestCanceled)(ITTBaseDataRequest *);
    void (^_onRequestFailedBlock)(ITTBaseDataRequest *, NSError *);
    void (^_onRequestProgressChangedBlock)(ITTBaseDataRequest *, CGFloat);
    
    //the finall mapping result
    ITTMappingResult    *_responseResult;
}

@property (nonatomic, assign, readonly) BOOL loading;
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, assign) ITTParameterEncoding parmaterEncoding;
@property (nonatomic, strong) NSString *rawResultString;
@property (nonatomic, strong, readonly) NSString *requestUrl;
@property (nonatomic, strong, readonly) NSDictionary *userInfo;
@property (nonatomic, strong, readonly) ITTRequestDataHandler *requestDataHandler;
#pragma mark - init methods using blocks
+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(ITTObjectMapping*)mapping
          onRequestFinished:(void(^)(ITTBaseDataRequest *request, ITTMappingResult *result))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(ITTObjectMapping*)mapping
          onRequestFinished:(void(^)(ITTBaseDataRequest *request, ITTMappingResult *result))onFinishedBlock
            onRequestFailed:(void(^)(ITTBaseDataRequest *request, NSError *error))onFailedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(ITTObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(ITTBaseDataRequest *request, ITTMappingResult *result))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(ITTObjectMapping*)mapping
          onRequestFinished:(void(^)(ITTBaseDataRequest *request, ITTMappingResult *result))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(ITTObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(ITTBaseDataRequest *request, ITTMappingResult *result))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(ITTObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(ITTBaseDataRequest *request, ITTMappingResult *result))onFinishedBlock
          onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(ITTBaseDataRequest *request, NSError *error))onFailedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(ITTObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(ITTBaseDataRequest *request, ITTMappingResult *result))onFinishedBlock
          onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(ITTBaseDataRequest *request, NSError *error))onFailedBlock;

#pragma mark - file download related init methods
+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(ITTObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
          onRequestFinished:(void(^)(ITTBaseDataRequest *request, ITTMappingResult *result))onFinishedBlock
          onProgressChanged:(void(^)(ITTBaseDataRequest *request,CGFloat progress))onProgressChangedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(ITTObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
          onRequestFinished:(void(^)(ITTBaseDataRequest *request, ITTMappingResult *result))onFinishedBlock
            onRequestFailed:(void(^)(ITTBaseDataRequest *request, NSError *error))onFailedBlock
          onProgressChanged:(void(^)(ITTBaseDataRequest *request,CGFloat progress))onProgressChangedBlock;

- (id)initWithParameters:(NSDictionary*)params
          withRequestUrl:(NSString*)url
       withIndicatorView:(UIView*)indiView
                 keyPath:(NSString*)keyPath
                 mapping:(ITTObjectMapping*)mapping
      withLoadingMessage:(NSString*)loadingMessage
       withCancelSubject:(NSString*)cancelSubject
         withSilentAlert:(BOOL)silent
            withCacheKey:(NSString*)cache
           withCacheType:(DataCacheManagerCacheType)cacheType
            withFilePath:(NSString*)localFilePath
          onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
       onRequestFinished:(void(^)(ITTBaseDataRequest *request, ITTMappingResult *result))onFinishedBlock
       onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
         onRequestFailed:(void(^)(ITTBaseDataRequest *request, NSError *error))onFailedBlock
       onProgressChanged:(void(^)(ITTBaseDataRequest *request, CGFloat))onProgressChangedBlock;

- (void)notifyDelegateRequestDidErrorWithError:(NSError*)error;
- (void)notifyDelegateRequestDidSuccess;
- (void)doRelease;
/*!
 * subclass can override the method, access data from responseResult and parse it to sepecfied data format
 */
- (void)processResult;
- (void)showIndicator:(BOOL)bshow;
- (void)doRequestWithParams:(NSDictionary*)params;
- (void)cancelRequest;                                     //subclass should override the method to cancel its request
- (void)showNetowrkUnavailableAlertView:(NSString*)message;
- (void)handleResponseString:(NSString*)resultString;

- (BOOL)onReceivedCacheData:(NSObject*)cacheData;
- (BOOL)processDownloadFile;

- (ITTRequestMethod)getRequestMethod;                       //default method is GET

- (NSStringEncoding)getResponseEncoding;

- (NSString*)encodeURL:(NSString *)string;
- (NSString*)getRequestUrl;

- (NSDictionary*)getStaticParams;

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse;

#pragma mark - 假数据方法
- (BOOL)useDumpyData;
- (NSString*)dumpyResponseString;
#pragma mark - 注册通知
- (void)registerRequestNotification;
- (void)unregisterRequestNotification;
@end
