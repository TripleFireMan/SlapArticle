//
//  DYValid.h
//  DaoYouProject
//
//  Created by 成焱 on 15-3-2.
//  Copyright (c) 2015年 成焱. All rights reserved.
//

#import <Foundation/Foundation.h>
//正则校验
@interface WBValid : NSObject
/*!
 *  @brief  校验邮箱
 *  @param email
 *  @return
 */
+ (BOOL)validateEmail:(NSString *)email;

/*!
 *  @brief  校验手机号
 *  @param mobile 手机号
 *  @return
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/*!
 *  @brief  校验车牌
 *  @param carNo 车牌
 *  @return
 */
+ (BOOL)validateCarNo:(NSString *)carNo;

/*!
 *  @brief  校验车型
 *  @param CarType 车型
 *  @return
 */
+ (BOOL)validateCarType:(NSString *)CarType;

/*!
 *  @brief  校验用户名
 *  @param name 用户名
 *  @return
 */
+ (BOOL)validateUserName:(NSString *)name;

/*!
 *  @brief  校验密码
 *  @param passWord 密码
 *  @return
 */
+ (BOOL)validatePassword:(NSString *)passWord;

/*!
 *  @brief  校验昵称
 *  @param nickname 昵称
 *  @return
 */
+ (BOOL)validateNickname:(NSString *)nickname;

/*!
 *  @brief  校验身份证号码
 *  @param identityCard 身份证号吗
 *  @return
 */
+ (BOOL)validateIdentityCard: (NSString *)identityCard;

/*!
 *  @brief  校验银行卡号
 *  @param bankCardNumber 银行卡号
 *  @return
 */
+ (BOOL)validateBankCardNumber: (NSString *)bankCardNumber;

/*!
 *  @brief  校验银行卡号后4位
 *  @param bankCardNumber 银行卡号后四位
 *  @return 
 */
+ (BOOL)validateBankCardLastNumber: (NSString *)bankCardNumber;

/*!
 *  @brief  校验cvn
 *  @param cvnCode cvn
 *  @return
 */
+ (BOOL)validateCVNCode: (NSString *)cvnCode;

/*!
 *  @brief  校验月
 *  @param month 月
 *  @return
 */
+ (BOOL)validateMonth: (NSString *)month;

/*!
 *  @brief  校验年
 *  @param year 年
 *  @return
 */
+ (BOOL)validateYear: (NSString *)year;

/*!
 *  @brief  校验验证码
 *  @param verifyCode 验证码
 *  @return
 */
+ (BOOL)validateVerifyCode: (NSString *)verifyCode;

/*!
 *  @brief  校验qq
 *  @param qq qq
 *  @return
 */
+ (BOOL)validateQQ:(NSString *)qq;

@end
