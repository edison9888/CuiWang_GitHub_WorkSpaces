//
//  AppDelegate.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-13.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "LoadingViewController.h"
@implementation AppDelegate

//----------各个平台key初始化
- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"947593726"
                               appSecret:@"a85d75532cefd432b077b42e5f8ba235"
                             redirectUri:@"http://www.tqpad.com"];
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801343348"
                                  appSecret:@"3311dcb625d20cb000ff4ac50965e39f"
                                redirectUri:@"http://www.tqpad.com"];
    /**
     连接人人网应用以使用相关功能，此应用需要引用RenRenConnection.framework
     http://dev.renren.com上注册人人网开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectRenRenWithAppKey:@"6d2e9bd4e30a47c19a902ce740a1ba36"
                            appSecret:@"67165a61c18149c3b4f3d6725a1053ec"];
    
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"100454423" appSecret:@"a70db2b3742cef42f0c88fc3b07baa57" ];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
    }
    /**
     注册SDK应用，此应用请到http://www.sharesdk.cn中进行注册申请。
     此方法必须在启动时调用，否则会限制SDK的使用。
     **/
    [ShareSDK registerApp:@"252783cb028"];
    [ShareSDK ssoEnabled:NO];//是否单点登录
    [self initializePlat];//初始化
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[LoadingViewController alloc]init];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
