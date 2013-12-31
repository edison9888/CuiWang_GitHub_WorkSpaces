//
//  payWebViewController.h
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-10-23.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Step3ViewController.h"
@interface payWebViewController : UIViewController<UIWebViewDelegate,PasswebValueDelegate>
{
    UIActivityIndicatorView *activityIndicatorView;
    NSString *urlString;
}
@property (strong, nonatomic) IBOutlet UIButton *webgoback;
@property (strong, nonatomic) IBOutlet UIWebView *payweb;
@property (strong, nonatomic) IBOutlet UIButton *webback;
@property (strong, nonatomic) IBOutlet UIButton *nextstep;

@end
