//
//  webViewController.h
//  poptoolbar
//
//  Created by zzvcom on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface webViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,PassValueDelegate>
{
    UIWebView *webview;
    UIView * opaqueview;
    
    UIActivityIndicatorView * activityIndicator;
    
    UIView * viewbar;
    UIToolbar *myToolbar;
    
   
}
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url;
- (void) setUrlValue:(NSString *) value;
@property(nonatomic,strong) NSString *urlString;
@end
