//
//  UITextField+ITTAdditions.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "UITextField+ITTAdditions.h"

@implementation UITextField (ITTAdditions)

+ (UITextField *)textFieldWithFrame:(CGRect)frame
                        borderStyle:(UITextBorderStyle)borderStyle
                          textColor:(UIColor *)textColor
                    backgroundColor:(UIColor *)backgroundColor
                               font:(UIFont *)font
                       keyboardType:(UIKeyboardType)keyboardType
                                tag:(NSInteger)tag{
	UITextField *textField = [[UITextField alloc] initWithFrame:frame];
	textField.borderStyle = borderStyle;
	textField.textColor = textColor;
	textField.font = font;
	
	textField.backgroundColor = backgroundColor;
	textField.keyboardType = keyboardType;
	textField.tag = tag;
	
	textField.returnKeyType = UIReturnKeyDone;
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	textField.leftViewMode = UITextFieldViewModeUnlessEditing;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	return textField;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame keyBoardType:(UIKeyboardType)keyBoardType placeHolder:(NSString *)placeHolder delegate:(id)delegate returnKeyType:(UIReturnKeyType)returnKeyType secret:(BOOL)secret
{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.placeholder = placeHolder;
    textField.delegate = delegate;
    textField.returnKeyType = returnKeyType;
    textField.secureTextEntry = secret;
    textField.layer.cornerRadius = 15.f;
    textField.keyboardType = keyBoardType;
    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    return textField;
}
@end
