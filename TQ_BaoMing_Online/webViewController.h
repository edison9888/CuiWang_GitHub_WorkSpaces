//
//  webViewController.h
//  poptoolbar
//
//  Created by zzvcom on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UIWebView *webview;
    UIView * opaqueview;
    
    UIActivityIndicatorView * activityIndicator;
    
    UIView * viewbar;
    UIToolbar *myToolbar;
}

@end
