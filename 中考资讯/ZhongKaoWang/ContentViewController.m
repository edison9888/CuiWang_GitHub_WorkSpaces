//
//  ContentViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-12-13.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "ContentViewController.h"
#import "AppDelegate.h"
#import "PinLunViewController.h"
#import "WritePinLunViewController.h"
#import "AGCustomShareViewController.h"

#define BaseURL [NSURL URLWithString:@"http://gaokao.tqedu.com"]

@interface ContentViewController ()

@end


@implementation ContentViewController


/**
 *    初始化
 *
 *    @param catid   栏目id
 *    @param nid     内容id
 *    @param title   内容标题
 *    @param content 内容
 *
 *    @return self
 */
- (id)initWithCatID:(NSString *)catid ContentID:(NSString *)nid ContentTitle:(NSString *)title Content:(NSString *)content Cimage:(NSString *)image NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	{
    if (self) {
        self.t.text = @"正文";
        self.CatID = catid;
        self.CatTitle = title;
        self.ContentID = nid;
        self.Content = content;
        Cimage = image;
        UserIsLoaded = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserIsLoaded"];
        
        [[NSNotificationCenter defaultCenter]
		 addObserver:self selector:@selector(reflashContentUI) name:@"reflashContentUI" object:nil];
    }
	}
	return self;
}

- (void)reflashContentUI {
	numberOfPinLunCountStr = [self numberOfPinLunCount];
	lb.text = numberOfPinLunCountStr;
}

/**
 *    评论按钮点击
 *
 *    @param sender <#sender description#>
 */
- (IBAction)pinlunButtonClick:(UIButton *)sender {
	/*
     WritePinLunViewController *write = [WritePinLunViewController new];
     [self presentViewController:write animated:YES completion: ^{
     //        <#code#>
     }];
	 */
    
	if (UserIsLoaded) {
		[CW_Tools ToastNotification:@"正在打开评论页面..." andView:self.myWebView andLoading:YES andIsBottom:NO doSomething: ^{
		    AGCustomShareViewController *vc = [[AGCustomShareViewController alloc] initWithImage:Cimage
		                                                                                 content:CONTENT title:self.CatTitle url:[NSString stringWithFormat:@"http://27.112.1.16/index.php?m=content&a=show&catid=%@&id=%@", self.CatID, self.ContentID] CatID:self.CatID ContentID:self.ContentID]
		    ;
		    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
		    [self presentViewController:naVC animated:YES completion: ^{
		        //
			}];
		}];
	}
	else {
		[CW_Tools ToastViewInView:self.view withText:@"请先登录后,再发表评论!"];
	}
}

/**
 *    分享按钮点击
 *
 *    @param sender <#sender description#>
 */
- (IBAction)fenxiangButtonClick:(UIButton *)sender {
	if (UserIsLoaded) {
		NSArray *shareList = [ShareSDK getShareListWithType:
		                      ShareTypeSinaWeibo,
		                      ShareTypeTencentWeibo,
		                      ShareTypeQQSpace,
		                      ShareTypeRenren,
		                      ShareTypeKaixin,
		                      nil];
        
        
		//定义容器
		id <ISSContainer> container = [ShareSDK container];
        
		[container setIPhoneContainerWithViewController:self];
        
        
        
		//定义分享内容
		id <ISSContent> publishContent = nil;
        
		NSString *contentString = CONTENT;
		NSString *titleString   = self.CatTitle;
		NSString *urlString     = [NSString stringWithFormat:@"http://27.112.1.16/index.php?m=content&a=show&catid=%@&id=%@", self.CatID, self.ContentID];
		NSString *description   = @"来自 Iphone 客户端";
        
		publishContent = [ShareSDK  content:contentString
		                     defaultContent:@""
		                              image:nil
		                              title:titleString
		                                url:urlString
		                        description:description
		                          mediaType:SSPublishContentMediaTypeNews];
        
		//定义分享设置
		id <ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"分享内容" shareViewDelegate:nil];
        
		[ShareSDK showShareActionSheet:container
		                     shareList:shareList
		                       content:publishContent
		                 statusBarTips:YES
		                   authOptions:nil
		                  shareOptions:shareOptions
		                        result:nil];
	}
	else {
		[CW_Tools ToastViewInView:self.view withText:@"请先登录后,再分享!"];
	}
}

/**
 *    收藏按钮点击
 *
 *    @param sender <#sender description#>
 */
- (IBAction)shoucangButtonClick:(UIButton *)sender {
	//------增加数据 练习错题 不需要这些功能
	if (sender.selected) {
		sender.selected = NO;
		[CW_Tools ToastViewInView:self.view withText:@"  取消收藏!  "];
		[LoadContentDB deleteTableValue:@"ShouCang_Table" Where:@"SC_Title" IS:[NSString stringWithFormat:@"\'%@\'", self.CatTitle] And:NO Where2:nil IS2:nil];
	}
	else {
		sender.selected = YES;
		__block NSString *content;
        
		//		[CW_Tools ToastNotification:@"收藏中..." andView:self.myWebView andLoading:YES andIsBottom:NO doSomething: ^{
		content = [self myWebDataDownLoad];
		//		}];
		if (content.length > 0) {
			NSString *SC_Time;
			NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
			[formatter setDateFormat:@"YYYY年MM月dd日 hh:mm:ss"];
			SC_Time = [formatter stringFromDate:[NSDate date]];
            
			NSArray *value2 = @[self.CatTitle, content, SC_Time];
			[LoadContentDB insertTable:@"ShouCang_Table" Where:@"SC_Title,SC_Content,SC_Time" Values:value2 Num:@"?,?,?"];
			[CW_Tools ToastViewInView:self.view withText:@"  收藏成功!  "];
		}
		else {
			[CW_Tools ToastViewInView:self.view withText:@"  收藏失败!  "];
		}
	}
}

/**
 *    返回按钮点击响应
 */
- (void)popback {
	if (self.myWebView.canGoBack) {
		[self.myWebView goBack];
	}
	else {
		[self dismissViewControllerAnimated:YES completion: ^{
		}];
	}
}

/**
 *    评论内容点击
 */
- (void)pinlunContent {
	if ([numberOfPinLunCountStr isEqualToString:@"0"]) {
		[CW_Tools ToastViewInView:self.view withText:@"暂无评论,快来添加吧!"];
	}
	else {
		[CW_Tools ToastNotification:@"正在打开评论..." andView:self.view andLoading:YES andIsBottom:NO doSomething: ^{
		    PinLunViewController *pinlunVC = [[PinLunViewController alloc]initWithCatID:self.CatID ContentID:self.ContentID];
		    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pinlunVC];
		    [self presentViewController:nav animated:YES completion: ^{
		        //            <#code#>
			}];
		}];
	}
}

/**
 *    当前内容页面评论的条数
 *
 *    @return 评论的条数 默认为0
 */
- (NSString *)numberOfPinLunCount {
	NSString *urlStr = [NSString stringWithFormat:@"http://gaokao.tqedu.com/index.php?m=content&c=khdindex&a=commentnum&catid=%@&id=%@", self.CatID, self.ContentID];
	DLog(@"%@", urlStr);
	NSURL *url = [NSURL URLWithString:urlStr];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request startSynchronous];
	NSError *error = [request error];
	NSString *response = @"0";
	if (!error) {
		response = [request responseString];
		DLog(@"response == %@", response);
	}
	return response;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

/**
 *    视图已加载
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	//-----初始化数据库
	if (![LoadContentDB isTableOK:@"GaoKaoWang.sqlite"]) {
		LoadContentDB = [[myDB sharedInstance] initWithDBName:@"GaoKaoWang.sqlite"];
	}
	//------创建表
	if (![LoadContentDB isTableOK:@"ShouCang_Table"]) {
		[LoadContentDB createTable:@"ShouCang_Table" withArguments:@"SC_Id integer PRIMARY KEY autoincrement,SC_Title text,SC_Content text,SC_Time text"];
	}
	//--------用title匹配
	NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM ShouCang_Table WHERE SC_Title=\'%@\'", self.CatTitle];
	FMResultSet *rs = [LoadContentDB findinTable:sqlString];
    
	while ([rs next]) {
		self.shoucangButton.selected = YES;
	}
    
	self.botView.image = [UIImage imageNamed:@"bottom.png"];
    
    
    
    
	//--------从收藏页面打开的话 catid = nil
	if (!self.CatID) {
		ShouCangFalg = YES;
		self.fenxiangButton.enabled = NO;
		self.pinlunButton.enabled = NO;
		self.navigationItem.rightBarButtonItem = nil;
	}
	else {
		//--------右上角查看评论
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"comment.png"]]];
		[button setFrame:CGRectMake(0, 0, 26, 21)];
		//TODO:更新评论条数
		numberOfPinLunCountStr = [self numberOfPinLunCount];
		DLog(@"numberOfPinLunCountStr == %@", numberOfPinLunCountStr);
		lb = [[UILabel alloc]initWithFrame:CGRectMake(0, -2, 26, 21)];
		lb.text = numberOfPinLunCountStr;
		lb.textColor = [UIColor whiteColor];
		lb.font = [UIFont systemFontOfSize:12];
		lb.textAlignment = 1;
		[button addSubview:lb];
        
		[button addTarget:self action:@selector(pinlunContent) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
		self.navigationItem.rightBarButtonItem = rightItem;
	}
    
    
	[CW_Tools ToastNotification:@"页面加载中..." andView:self.myWebView andLoading:YES andIsBottom:NO doSomething: ^{
	    if (ShouCangFalg) {
	        [self.myWebView loadHTMLString:self.Content baseURL:BaseURL];
		}
	    else {
	        NSString *webStr =   [self myMixedTask];
	        if ([webStr isEqualToString:@"error"] || !webStr) {
	            self.fenxiangButton.enabled = NO;
	            self.pinlunButton.enabled = NO;
	            self.navigationItem.rightBarButtonItem = nil;
			}
	        else {
	            [self.myWebView loadHTMLString:webStr baseURL:BaseURL];
			}
		}
	}];
}

/**
 *    收藏功能 下载网页到数据库
 *
 *    @return 网页源码
 */
- (NSString *)myWebDataDownLoad {
	NSString *urlstr = [NSString stringWithFormat:@"http://27.112.1.16/index.php?m=content&c=khdindex&a=show&catid=%@&id=%@", self.CatID, self.ContentID];
	NSURL *URL = [NSURL URLWithString:urlstr];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    
    
    
	//获取全局变量
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	//设置缓存方式
	[request setDownloadCache:appDelegate.asiCache];
	//设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {
		NSString *contentStr = [request responseString];
		return contentStr;
	}
	else {
		[CW_Tools ToastViewInView:self.view withText:@"连接服务器失败! "];
		return @"";
	}
}

/**
 *    加载页面,有缓存先用缓存
 */
- (NSString *)myMixedTask {
	NSString *urlstr = [NSString stringWithFormat:@"http://27.112.1.16/index.php?m=content&c=khdindex&a=show&catid=%@&id=%@", self.CatID, self.ContentID];
	NSURL *URL = [NSURL URLWithString:urlstr];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
	//获取全局变量
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	//设置缓存方式
	[request setDownloadCache:appDelegate.asiCache];
	//设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {
		// Use when fetching text data
		/*
         if ([request didUseCachedResponse]) {
         DLog(@"来自于缓存");
         }
         else {
         DLog(@"NO");
         }
		 */
		return [request responseString];
	}
	else {
		[CW_Tools ToastViewInView:self.view withText:@"连接服务器失败! "];
		return @"error";
	}
}

#pragma mark 网页
- (void)webViewDidStartLoad:(UIWebView *)webView {
	//
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	//    [HUD hide:YES afterDelay:0];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
	[alterview show];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
