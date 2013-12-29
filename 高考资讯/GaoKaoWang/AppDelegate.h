//
//  AppDelegate.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-18.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "subMMDrawerController.h"
#import "ASIDownloadCache.h"
#import "AGViewDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    AppDelegate *app;
   AGViewDelegate *_viewDelegate;
    
}
-(subMMDrawerController *)loadMainVC;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)    ASIDownloadCache *asiCache;
 @property (nonatomic,readonly) AppDelegate *app;
@property (nonatomic,readonly) AGViewDelegate *viewDelegate;
@end
