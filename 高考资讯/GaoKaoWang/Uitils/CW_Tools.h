//
//  CW_Tools.h
//  GaoKaoWang
//
//  Created by cui wang on 13-12-13.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CW_Tools : NSObject

+ (CW_Tools *)sharedManager;

/*!
 * @method 弹出异步视图
 * @abstract
 * @discussion
 * @text 显示的文本 view 在哪个view上 isLoading是否显示activiy andIsBottom上下
 * @result
 */
+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom doSomething:(void (^)())completion;
+ (void)ToastNotification2:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom doSomething:(void (^)())completion;
/*!
 * @method 通过16进制计算颜色
 * @abstract
 * @discussion
 * @param 16机制
 * @result 颜色对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;
+ (void)ToastViewInView:(UIView *)view withText:(NSString *)text;
#pragma mark -
#pragma mark 正则校验

+ (BOOL)isMobile:(NSString *)mobile;
+ (BOOL)isEmail:(NSString *)email;
+ (BOOL)isNormal:(NSString *)string;
+ (BOOL)isPassword:(NSString *)passwrod;
/**
 *    网络是否存在
 */
+ (BOOL)checkNetworkConnection;
@end
