//
//  HHRequestResult
//
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ITTRequestResult.h"


@implementation ITTRequestResult
///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

-(id)initWithCode:(NSString*)code withMessage:(NSString*)message
{
    self = [super init];
    if (self) {
        if ([code isKindOfClass:[NSString class]]) {
            if ([code isEqualToString:@"0"]) {
                _code = @0;
            }else{
                _code = @1;
            }
        }else if([code isKindOfClass:[NSNumber class]]){
            _code = [NSNumber numberWithInt:[code intValue]];
        }else{
            _code = @1;
        }
        _message = message;
    }
    return self;
}

-(BOOL)isSuccess
{
    BOOL isSuccess = _code && [_code integerValue]==1;
    return isSuccess;
}

-(void)showErrorMessage
{
    if (_message && _message.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:_message
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@end