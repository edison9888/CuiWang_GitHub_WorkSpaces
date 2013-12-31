//
//  PinLunViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-12-21.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "PinLunViewController.h"

@interface PinLunViewController ()

@end

@implementation PinLunViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (isIPhone5) {
        self = [super initWithNibName:@"PinLunViewController_ip5" bundle:nibBundleOrNil];
    } else {
        
        self = [super initWithNibName:@"PinLunViewController" bundle:nibBundleOrNil];
    }
	if (self) {
		// Custom initialization
		self.t.text = @"热门评论";
	}
	return self;
}
- (id)initWithCatID:(NSString *)catid ContentID:(NSString *)nid
{
    self = [super init];
    if (self) {
        self.CatID = catid;
        self.ContentID = nid;
    }
    return self;
}
- (void)viewDidLoad {
	[super viewDidLoad];
    [CW_Tools ToastNotification:@"页面加载中..." andView:self.myPinLunWebView andLoading:YES andIsBottom:NO doSomething: ^{
	        [self myMixedTask];
	}];
	// Do any additional setup after loading the view from its nib.
}
/**
 *    加载页面,有缓存先用缓存
 */
- (void)myMixedTask {
	NSString *urlstr = [NSString stringWithFormat:@"http://gaokao.tqedu.com/index.php?m=content&c=khdindex&a=remenpl&catid=%@&id=%@", self.CatID, self.ContentID];
	NSURL *URL = [NSURL URLWithString:urlstr];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {
        
		[self.myPinLunWebView loadHTMLString:[request responseString] baseURL:nil];
	}
	else {
		[CW_Tools ToastViewInView:self.view withText:@"连接服务器失败! "];
	}
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
