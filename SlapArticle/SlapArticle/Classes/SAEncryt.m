//
//  SAEncryt.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/29.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "SAEncryt.h"

@implementation SAEncryt

+ (NSDictionary *)getEncrytParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date]timeIntervalSince1970]];
    NSString *nonce = [NSString stringWithFormat:@"%d",arc4random()%100];

    [params setObject:SA_TOKEN forKey:@"token"];
    [params setObject:timeStamp forKey:@"timestamp"];
    [params setObject:nonce forKey:@"nonce"];
    
    NSArray *allKeys = [[params allValues]sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableString *signature = [[NSMutableString alloc]initWithString:@""];
    
    [allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [signature appendString:obj];
    }];
    
    NSString *sha1Signature = [SAEncryt getSha1String:signature];
    
    [params removeObjectForKey:@"token"];
    [params setObject:sha1Signature forKey:@"signature"];
    
    return params;
}

+ (NSString *)getSha1String:(NSString *)srcString{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    
    for(int i =0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}
@end
