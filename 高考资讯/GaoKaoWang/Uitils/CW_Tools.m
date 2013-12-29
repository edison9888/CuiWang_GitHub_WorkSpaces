//
//  CW_Tools.m
//  GaoKaoWang
//
//  Created by cui wang on 13-12-13.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "CW_Tools.h"
#import "GCDiscreetNotificationView.h"


@implementation CW_Tools

+ (CW_Tools *)sharedManager {
    static CW_Tools *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[CW_Tools alloc] init];
    });
    
    return _sharedManager;
}
#pragma mark - 工具方法

/*!
 * @method 弹出异步视图
 * @abstract
 * @discussion
 * @text 显示的文本 view 在哪个view上 isLoading是否显示activiy andIsBottom上下
 * @result 
 */
+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom doSomething:(void (^)())completion
{
    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom?GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];
    [notificationView show:YES];
    completion();
    [notificationView hideAnimatedAfter:1.2];
}

+ (void)ToastNotification2:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom doSomething:(void (^)())completion
{
    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom?GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];
    completion();
    [notificationView hide:YES];
}

#pragma mark - 工具方法

/*!
 * @method 通过16进制计算颜色
 * @abstract
 * @discussion
 * @param 16机制
 * @result 颜色对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
        {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
        }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

#pragma mark - 弹出视图
+ (void)ToastViewInView:(UIView *)view withText:(NSString *)text
{
    [ALToastView toastInView:view withText:text];
}
#pragma mark -
#pragma mark 正则校验

+ (BOOL)isMobile:(NSString *)mobile
{
    return [mobile isMatchedByRegex:@"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$"];
}
+ (BOOL)isEmail:(NSString *)email
{
    return [email isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
}
+ (BOOL)isNormal:(NSString *)string
{
    return [string isMatchedByRegex:@"[^?!@#$%\\^&*()]+"];
}
+ (BOOL)isPassword:(NSString *)passwrod
{
    return [passwrod isMatchedByRegex:@"^[a-zA-Z0-9]{6,16}$"];
}

+ (BOOL)checkNetworkConnection
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}
@end
