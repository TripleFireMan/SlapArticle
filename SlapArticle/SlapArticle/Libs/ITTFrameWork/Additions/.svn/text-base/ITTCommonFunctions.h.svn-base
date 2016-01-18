//
//  ITTCommonFunctions.h
//  
//
//  Created by guo hua on 11-9-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - CGGeometry functions
@class YKDoctor;
typedef void (^YKUniversalBlock)(void);
typedef void (^YKStringResultBlock)(NSString *);
typedef void (^YKArrayResultBlock)(NSArray *);
typedef void (^YKIntegerResultBlock)(NSInteger);
typedef void (^YKBoolResultBlock)(BOOL);
typedef void (^YKDoctorResultBlock)(YKDoctor *doc);

CGPoint CGRectGetCenter(CGRect rect);
CGFloat distanceBetweenPoints(CGPoint p1,CGPoint p2);
CGFloat angleOfPointFromCenter(CGPoint p,CGPoint center);
BOOL ITTIsModalViewController(UIViewController* viewController);
NSString *pathInDocumentDirectory(NSString *fileName);
extern void DYConstrains(UIView *superview,UIView *view1,UIView *view2, NSLayoutAttribute att1,NSLayoutAttribute att2,float constant);
extern void DYConstrainsSetEdge(UIView *superview, UIView *view,NSLayoutAttribute att,float constant);
extern void DYConstrainsSetWidthOrHeight(UIView *view,NSLayoutAttribute att,float constant);