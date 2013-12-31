//
//  WebOpenViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-12-27.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "WebOpenViewController.h"

@interface WebOpenViewController ()

@end

@implementation WebOpenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(id)initWithUrl:(NSString *)url NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _url = url;
        self.t.text = @"焦点推荐";
    }
    return self;
}
/**
 *    返回按钮点击响应
 */
- (void)popback {
	if (self.myWebOpenWebView.canGoBack) {
		[self.myWebOpenWebView goBack];
	}
	else {
		[self dismissViewControllerAnimated:YES completion: ^{
		}];
	}
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [CW_Tools ToastNotification:@"页面加载中..." andView:self.myWebOpenWebView andLoading:YES andIsBottom:NO doSomething: ^{
        [self myMixedTask];
	}];
    // Do any additional setup after loading the view from its nib.
}
/**
 *    加载页面,有缓存先用缓存
 */
- (void)myMixedTask {
	NSURL *URL = [NSURL URLWithString:_url];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {
        
		[self.myWebOpenWebView loadHTMLString:[request responseString] baseURL:nil];
	}
	else {
		[CW_Tools ToastViewInView:self.view withText:@"连接服务器失败! "];
	}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
