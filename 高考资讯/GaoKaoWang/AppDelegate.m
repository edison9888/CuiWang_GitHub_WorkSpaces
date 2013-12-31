//
//  AppDelegate.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-18.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "AppDelegate.h"

#import <ShareSDK/ShareSDK.h>
#import "HomeViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "LoadViewController.h"
#import "BaseViewController.h"
#import "MMExampleDrawerVisualStateManager.h"



static const CGFloat kPublicLeftMenuWidth = 218.0f;
@implementation AppDelegate

@synthesize app;
@synthesize viewDelegate = _viewDelegate;


- (id)init
{
    if(self = [super init])
        {
        _viewDelegate = [[AGViewDelegate alloc] init];
        }
    return self;
}
//----------各个平台key初始化
- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"2605487199"
                               appSecret:@"1f7c645e1680747fd50b4144db4dcbd8"
                             redirectUri:@"http://gaokao.tqedu.com/"];
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"1101124467"
                                  appSecret:@"9KCJWGi4yFCvG3eI"
                                redirectUri:@"http://gaokao.tqedu.com/"];
    /**
     连接人人网应用以使用相关功能，此应用需要引用RenRenConnection.framework
     http://dev.renren.com上注册人人网开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectRenRenWithAppKey:@"6d2e9bd4e30a47c19a902ce740a1ba36"
                            appSecret:@"67165a61c18149c3b4f3d6725a1053ec"];
    
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"100454423" appSecret:@"a70db2b3742cef42f0c88fc3b07baa57" ];
    
    /**
     连接开心网应用以使用相关功能，此应用需要引用KaiXinConnection.framework
     http://open.kaixin001.com上注册开心网开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectKaiXinWithAppKey:@"995986238347027aae2e7242eac6504a "
                            appSecret:@"7b1e7762fcfc864b253a7a6da8ceb94b"
                          redirectUri:@"http://gaokao.tqedu.com/"];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //--------在图标上显示数字
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //开启ChuaiGuo会话，注册appToken
//    [ChuaiGuo Begin:@"1073029ecfc2d5395ea03c3cb30181fe"];
    //其他必要的代码
    //远程日志
//    CHLog(@"测试名称：%@",@"test");
    
    //--------sharesdk注册
    
    [ShareSDK registerApp:@"e7fff31b8a2"];//高考资讯
    [ShareSDK ssoEnabled:NO];//是否单点登录
    [self initializePlat];//初始化
    //--------------缓存策略-------------------
    _asiCache = [[ASIDownloadCache alloc]init];
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MyCache"];
    [_asiCache setStoragePath:document];
    [_asiCache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    
    
    
//     DrawerController = [self loadMainVC];
    
//    //增加标识，用于判断是否是第一次启动应用...
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
////        ViewController *appStartController = [[ViewController alloc] init];
////        self.window.rootViewController = appStartController;
////        [appStartController release];
//    }else {
////        NextViewController *mainViewController = [[NextViewController alloc] init];
////        self.window.rootViewController=mainViewController;
////        [mainViewController release];
//        
//    }
    
    LoadViewController *loadVC;
    if (isIPhone5) {
        
        loadVC = [[LoadViewController alloc]initWithNibName:@"LoadViewController_ip5" bundle:nil];
    } else {
         loadVC = [[LoadViewController alloc]initWithNibName:@"LoadViewController" bundle:nil];
    }
    
//    DLog(@"isIPhone5  %@",isIPhone5?@"YES":@"NO");
    
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:loadVC];
    
    [nv setNavigationBarHidden:YES];
    [self.window setRootViewController:nv];
    [self.window makeKeyAndVisible];
    return YES;
    
}

-(subMMDrawerController *)loadMainVC
{
    LeftViewController *leftVC = [LeftViewController new];
//    RightViewController *rightVC = [RightViewController new];
    
    HomeViewController *HomeVC = [HomeViewController new];
    
    UINavigationController * HomeSwitchVC = [[UINavigationController alloc] initWithRootViewController:HomeVC];
    
    subMMDrawerController * drawerController = [[subMMDrawerController alloc]
                                                initWithCenterViewController:HomeSwitchVC
                                                leftDrawerViewController:leftVC
                                                rightDrawerViewController:nil];
    
    [drawerController setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//        MMDrawerControllerDrawerVisualStateBlock block;
//        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
//        block(drawerController, drawerSide, percentVisible);
//    }];
    [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
     [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
    
    return drawerController;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:nil];
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
