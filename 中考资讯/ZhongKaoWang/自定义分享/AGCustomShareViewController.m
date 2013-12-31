//
//  AGCustomShareViewController.m
//  AGShareSDKDemo
//
//  Created by 冯 鸿杰 on 13-3-5.
//  Copyright (c) 2013年 vimfung. All rights reserved.
//

#import "AGCustomShareViewController.h"
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UIColor+Common.h>
#import <AGCommon/NSString+Common.h>
#import "AppDelegate.h"

#define IMAGE_WIDTH 80.0
#define IMAGE_HEIGHT 80.0
#define IMAGE_LANDSCAPE_WIDTH 50.0
#define IMAGE_LANDSCAPE_HEIGHT 50.0

#define TOOLBAR_HEIGHT 40

#define PADDING_LEFT 1.0
#define PADDING_TOP 1.0
#define PADDING_RIGHT 1.0
#define PADDING_BOTTOM 2.0
#define HORIZONTAL_GAP 2.0
#define VERTICAL_GAP 5.0

#define IMAGE_PADDING_TOP 19
#define IMAGE_PADDING_RIGHT 10

#define PIN_PADDING_TOP 4

#define AT_BUTTON_PADDING_LEFT 9
#define AT_BUTTON_PADDING_BOTTOM 6
#define AT_BUTTON_WIDTH 34
#define AT_BUTTON_HEIGHT 29
#define AT_BUTTON_HORIZONTAL_GAP 9.0

#define WORD_COUNT_LABEL_PADDING_RIGHT 10
#define WORD_COUNT_LABEL_PADDING_BOTTOM 19


@implementation AGCustomShareViewController

- (id)initWithImage:(NSString *)image
            content:(NSString *)content title:(NSString *)title url:(NSString *)url CatID:(NSString *)catid ContentID:(NSString *)nid
{
    self = [self init];
    if (self)
    {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _image = [image copy];
        _content = [content copy];
    _mytitle = [title copy];
    _myurl = [url copy];
    _catid = catid;
    _nid = nid;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
    
        UIButton *leftBtn = [[[UIButton alloc] init] autorelease];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"kuangkuang_1.png"]
                           forState:UIControlStateNormal];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        leftBtn.frame = CGRectMake(0.0, 0.0, 53.0, 30.0);
        [leftBtn addTarget:self action:@selector(cancelButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftBtn] autorelease];
        
        UIButton *rightBtn = [[[UIButton alloc] init] autorelease];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"kuangkuang_1.png"]
                           forState:UIControlStateNormal];
        [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        rightBtn.frame = CGRectMake(0.0, 0.0, 53.0, 30.0);
        [rightBtn addTarget:self action:@selector(publishButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];

        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightBtn] autorelease];
    
        self.title = @"内容分享";
    }
    return self;
}

- (void)dealloc
{
    _picImageView = nil;
    _textView = nil;
    _toolbar = nil;
    
    SAFE_RELEASE(_image);
    SAFE_RELEASE(_content);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t.font = [UIFont systemFontOfSize:20];
    t.textColor = [UIColor whiteColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = 1;
    t.text = title;
    self.navigationItem.titleView = t;
    [t release];
//    ((UILabel *)self.navigationItem.titleView).text = title;
//    [self.navigationItem.titleView sizeToFit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"comm_header.png"] forBarMetrics:UIBarMetricsDefault];
    
    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:SSRectEdgeBottom | SSRectEdgeLeft | SSRectEdgeRight];
    }
    
    self.view.backgroundColor = [UIColor blackColor];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    self.navigationController.navigationBar.translucent = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowHandler:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _contentBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"comm_header.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:11]];
    
    _contentBG.frame = CGRectMake(PADDING_LEFT, PADDING_TOP, self.view.width - PADDING_LEFT - PADDING_RIGHT, self.view.height - TOOLBAR_HEIGHT - VERTICAL_GAP - PADDING_BOTTOM);
    _contentBG.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_contentBG];
    [_contentBG release];
    
    _toolbarBG = [[UIImageView alloc] initWithImage:nil];
    _toolbarBG.frame = CGRectMake(PADDING_LEFT + 1, _contentBG.bottom + VERTICAL_GAP, self.view.width - PADDING_LEFT - PADDING_RIGHT - 2, TOOLBAR_HEIGHT);
    _toolbarBG.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_toolbarBG];
    [_toolbarBG release];
	
    //图片
    _picBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShareImageBG.png"]];
    _picBG.frame = CGRectMake(self.view.width - IMAGE_PADDING_RIGHT - _picBG.width, IMAGE_PADDING_TOP, _picBG.width, _picBG.height);
    _picBG.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:_picBG];
    [_picBG release];
    
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_picBG.left + 3, _picBG.top + 3, _picBG.width - 6, _picBG.height - 6)];
    _picImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_picImageView setImageWithURL:[NSURL URLWithString:_image]];
    [self.view addSubview:_picImageView];
    [_picImageView release];
    /*
    _pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SharePin.png"]];
    _pinImageView.frame = CGRectMake(self.view.width - _pinImageView.width, PIN_PADDING_TOP, _pinImageView.width, _pinImageView.height);
    _pinImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:_pinImageView];
    [_pinImageView release];
    */
    //文本框
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(PADDING_LEFT,
                                                             PADDING_TOP + 1,
                                                             _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:16.0];
    _textView.text = _content;
    _textView.delegate = self;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_textView];
    [_textView release];
    
    if (!_image)
    {
        _picBG.hidden = YES;
        _picImageView.hidden = YES;
        _pinImageView.hidden = YES;
        _textView.frame = CGRectMake(PADDING_LEFT,
                                     PADDING_TOP + 1,
                                     _contentBG.right - PADDING_RIGHT - PADDING_LEFT,
                                     _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
    }
    
    //工具栏
    _toolbar = [[AGCustomShareViewToolbar alloc] initWithFrame:CGRectMake(_toolbarBG.left + 2, _toolbarBG.top, _toolbarBG.width - 4, _toolbarBG.height)];
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_toolbar];
    [_toolbar release];
    
    _atButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_atButton setBackgroundImage:[UIImage imageNamed:@"atButton.png"] forState:UIControlStateNormal];
    _atButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
//    [_atButton addTarget:self action:@selector(addbuttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_atButton];
    
    _atTipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _atTipsLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _atTipsLabel.backgroundColor = [UIColor clearColor];
    _atTipsLabel.textColor = [UIColor colorWithRGB:0xd2d2d2];
    _atTipsLabel.text = @"如果不想转发,请不要勾选下方图标";
    _atTipsLabel.font = [UIFont boldSystemFontOfSize:12];
    [_atTipsLabel sizeToFit];
    _atTipsLabel.frame = CGRectMake( AT_BUTTON_HORIZONTAL_GAP,
                                    _atButton.top + (_atButton.height - _atTipsLabel.height) / 2,
                                    _atTipsLabel.width,
                                    _atTipsLabel.height);
    [self.view addSubview:_atTipsLabel];
    [_atTipsLabel release];
    
    //字数
    _wordCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _wordCountLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _wordCountLabel.backgroundColor = [UIColor clearColor];
    _wordCountLabel.textColor = [UIColor colorWithRGB:0xd2d2d2];
    _wordCountLabel.text = @"140";
    _wordCountLabel.font = [UIFont boldSystemFontOfSize:16];
    [_wordCountLabel sizeToFit];
    _wordCountLabel.frame = CGRectMake(_contentBG.right - WORD_COUNT_LABEL_PADDING_RIGHT - _wordCountLabel.width,
                                       _contentBG.bottom - WORD_COUNT_LABEL_PADDING_BOTTOM - _wordCountLabel.height,
                                       _wordCountLabel.width,
                                       _wordCountLabel.height);
    [self.view addSubview:_wordCountLabel];
    [_wordCountLabel release];
    
    [self updateWordCount];
    [_textView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


#pragma mark - Private

- (void)updateWordCount
{
    NSInteger count = 140 - [_textView.text length];
    _wordCountLabel.text = [NSString stringWithFormat:@"%d", count];
    
    if (count < 0)
    {
        _wordCountLabel.textColor = [UIColor redColor];
    }
    else
    {
        _wordCountLabel.textColor = [UIColor colorWithRGB:0xd2d2d2];
    }
    
    [_wordCountLabel sizeToFit];
    _wordCountLabel.frame = CGRectMake(_contentBG.right - WORD_COUNT_LABEL_PADDING_RIGHT - _wordCountLabel.width,
                                       _contentBG.bottom - WORD_COUNT_LABEL_PADDING_BOTTOM - _wordCountLabel.height,
                                       _wordCountLabel.width,
                                       _wordCountLabel.height);
}
/*
- (void)addbuttonClickHandler:(id)sender
{
    AGCustomAtPlatListViewController *vc = [[[AGCustomAtPlatListViewController alloc] initWithChangeHandler:^(NSArray *users, ShareType shareType) {
        NSMutableString *usersString = [NSMutableString string];
        for (int i = 0; i < [users count]; i++)
        {
            NSDictionary *userInfo = [users objectAtIndex:i];
            switch (shareType)
            {
                case ShareTypeTwitter:
                {
                    [usersString appendFormat:@" @%@ ", [userInfo objectForKey:@"screen_name"]];
                    break;
                }
                case ShareTypeTencentWeibo:
                {
                    [usersString appendFormat:@" @%@ ", [userInfo objectForKey:@"name"]];
                    break;
                }
                default:
                {
                    [usersString appendFormat:@" @%@ ", [userInfo objectForKey:@"screen_name"]];
                    break;
                }
            }
        }
        
        _textView.text = [_textView.text stringByAppendingString:usersString];
        [self updateWordCount];
        
        [_textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
    } cancelHandler:^{
        
        [_textView becomeFirstResponder];
        
    }] autorelease];
    UINavigationController *navVC = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    
    if ([UIDevice currentDevice].isPad)
    {
        navVC.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentModalViewController:navVC animated:YES];
}
*/
- (void)cancelButtonClickHandler:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/**
 *    发布到开放平台
 */
-(void)publishToSpaces
{
    NSArray *selectedClients = [_toolbar selectedClients];
    if ([selectedClients count] == 0)
        {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"请选择要发布的平台!"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"知道了"
//                                                  otherButtonTitles: nil];
//        [alertView show];
//        [alertView release];
        
        return;
        }
    //定义分享内容
    id<ISSContent> publishContent = nil;
    
    NSString *contentString = _content;
    NSString *titleString   = _mytitle;
    NSString *urlString     =_myurl;
    NSString *description   = @"来自 Iphone 客户端";
    
    publishContent = [ShareSDK content:contentString
                        defaultContent:@""
                                 image:nil
                                 title:titleString
                                   url:urlString
                           description:description
                             mediaType:SSPublishContentMediaTypeNews];
    
    
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:_appDelegate.viewDelegate];
    
    
    BOOL needAuth = NO;
    if ([selectedClients count] == 1)
        {
        ShareType shareType = [[selectedClients objectAtIndex:0] integerValue];
        if (![ShareSDK hasAuthorizedWithType:shareType])
            {
            needAuth = YES;
            [ShareSDK getUserInfoWithType:shareType
                              authOptions:authOptions
                                   result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                       
                                       if (result)
                                           {
                                           //分享内容
                                           [ShareSDK oneKeyShareContent:publishContent
                                                              shareList:selectedClients
                                                            authOptions:authOptions
                                                          statusBarTips:YES
                                                                 result:nil];
                                           
                                          
                                           }
                                       else
                                           {
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                               message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:@"知道了"
                                                                                     otherButtonTitles:nil];
                                           [alertView show];
                                           [alertView release];
                                           }
                                   }];
            }
        }
    
    if (!needAuth)
        {
        //分享内容
        [ShareSDK oneKeyShareContent:publishContent
                           shareList:selectedClients
                         authOptions:authOptions
                       statusBarTips:YES
                              result:nil];
        
        
        }
    
   

}
/**
 *    发表评论
 */
-(void)publishToHome
{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *userID = [ud stringForKey:@"UserLoadID"];
    
    
    
    
    NSString *utf8ParamValue1 = [_mytitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *utf8ParamValue2 = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *urlstr = [NSString stringWithFormat:@"http://www.gkk12.com/index.php?m=content&c=khdindex&a=comment&catid=%@&id=%@&userid=%@&title=%@&content=%@",_catid,_nid,userID,utf8ParamValue1,utf8ParamValue2];
    
    NSURL *url = [NSURL URLWithString:urlstr];
    
    
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        DLog(@"response == %@",response);
        if ([response isEqualToString:@"1"]) {
            [CW_Tools ToastViewInView:self.view withText:@"发布成功!"];
            [[NSNotificationCenter defaultCenter] postNotificationName: @"reflashContentUI"
                                                                object: nil];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            [CW_Tools ToastViewInView:self.view withText:@"发布失败!"];
        }
    } else {
        [CW_Tools ToastViewInView:self.view withText:@"服务器连接失败!"];
    }
    
    
   
}
- (void)publishButtonClickHandler:(id)sender
{
    DLog(@"发布!");
    [self publishToHome];
    [self publishToSpaces];
    
   }
#pragma mark - 键盘相关
- (void)keyboardWillShowHandler:(NSNotification *)notif
{
    CGRect keyboardFrame;
    NSValue *value =[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    [value getValue:&keyboardFrame];
    
    CGFloat fixedHeight = 0;
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        _keyboardHeight = keyboardFrame.size.width;
        
        fixedHeight = (self.view.height + self.navigationController.navigationBar.height) - ([UIScreen mainScreen].bounds.size.width - _keyboardHeight - 20);
    }
    else
    {
        _keyboardHeight = keyboardFrame.size.height;
        
        fixedHeight = _keyboardHeight - ([UIScreen mainScreen].bounds.size.height - self.view.height - self.navigationController.navigationBar.height - 20) / 2;
    }
    
    [UIView beginAnimations:@"change" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.15];
    
    if ([UIDevice currentDevice].isPad)
    {
        _toolbarBG.hidden = NO;
        _atTipsLabel.hidden = NO;
        _wordCountLabel.hidden = NO;
        _keyboardHeight = keyboardFrame.size.height;
        
        _contentBG.frame = CGRectMake(PADDING_LEFT,
                                      PADDING_TOP,
                                      self.view.width - PADDING_LEFT - PADDING_RIGHT,
                                      self.view.height - TOOLBAR_HEIGHT - VERTICAL_GAP - PADDING_BOTTOM - fixedHeight);
        _toolbarBG.frame = CGRectMake(PADDING_LEFT + 1,
                                      _contentBG.bottom + VERTICAL_GAP,
                                      self.view.width - PADDING_LEFT - PADDING_RIGHT - 2,
                                      TOOLBAR_HEIGHT);
        
        if (_image)
        {
            _textView.frame = CGRectMake(PADDING_LEFT,
                                         PADDING_TOP + 1,
                                         _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                         _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
        }
        else
        {
            _textView.frame = CGRectMake(PADDING_LEFT,
                                         PADDING_TOP + 1,
                                         _contentBG.right - PADDING_RIGHT - PADDING_LEFT,
                                         _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
        }
        
        
        _toolbar.frame = CGRectMake(_toolbarBG.left + 2, _toolbarBG.top, _toolbarBG.width - 4, _toolbarBG.height);
        
        _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
        _atTipsLabel.frame = CGRectMake(_atButton.right + AT_BUTTON_HORIZONTAL_GAP,
                                        _atButton.top + (_atButton.height - _atTipsLabel.height) / 2,
                                        _atTipsLabel.width,
                                        _atTipsLabel.height);
        _wordCountLabel.frame = CGRectMake(_contentBG.right - WORD_COUNT_LABEL_PADDING_RIGHT - _wordCountLabel.width,
                                           _contentBG.bottom - WORD_COUNT_LABEL_PADDING_BOTTOM - _wordCountLabel.height,
                                           _wordCountLabel.width,
                                           _wordCountLabel.height);
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            _toolbarBG.hidden = YES;
            _atTipsLabel.hidden = YES;
            _wordCountLabel.hidden = YES;
            _keyboardHeight = keyboardFrame.size.width;
            
            _contentBG.frame = CGRectMake(PADDING_LEFT,
                                          PADDING_TOP,
                                          self.view.width - PADDING_LEFT - PADDING_RIGHT,
                                          self.view.height - PADDING_BOTTOM - _keyboardHeight);
            
            if (_image)
            {
                _textView.frame = CGRectMake(PADDING_LEFT,
                                             PADDING_TOP + 1,
                                             _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
            }
            else
            {
                _textView.frame = CGRectMake(PADDING_LEFT,
                                             PADDING_TOP + 1,
                                             _contentBG.right - PADDING_RIGHT - PADDING_LEFT,
                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
            }
            
            _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
            _toolbar.frame = CGRectMake(_atButton.right + HORIZONTAL_GAP, _contentBG.bottom - TOOLBAR_HEIGHT,_picBG.left - _atButton.right - 2 *HORIZONTAL_GAP, TOOLBAR_HEIGHT);
        }
        else
        {
            _toolbarBG.hidden = NO;
            _atTipsLabel.hidden = NO;
            _wordCountLabel.hidden = NO;
            _keyboardHeight = keyboardFrame.size.height;
            
            _contentBG.frame = CGRectMake(PADDING_LEFT,
                                          PADDING_TOP,
                                          self.view.width - PADDING_LEFT - PADDING_RIGHT,
                                          self.view.height - TOOLBAR_HEIGHT - VERTICAL_GAP - PADDING_BOTTOM - _keyboardHeight);
            _toolbarBG.frame = CGRectMake(PADDING_LEFT + 1,
                                          _contentBG.bottom + VERTICAL_GAP,
                                          self.view.width - PADDING_LEFT - PADDING_RIGHT - 2,
                                          TOOLBAR_HEIGHT);
            
            if (_image)
            {
                _textView.frame = CGRectMake(PADDING_LEFT,
                                             PADDING_TOP + 1,
                                             _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
            }
            else
            {
                _textView.frame = CGRectMake(PADDING_LEFT,
                                             PADDING_TOP + 1,
                                             _contentBG.right - PADDING_RIGHT - PADDING_LEFT,
                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
            }
            
            _toolbar.frame = CGRectMake(_toolbarBG.left + 2, _toolbarBG.top, _toolbarBG.width - 4, _toolbarBG.height);

            _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
            _atTipsLabel.frame = CGRectMake(_atButton.right + AT_BUTTON_HORIZONTAL_GAP,
                                            _atButton.top + (_atButton.height - _atTipsLabel.height) / 2,
                                            _atTipsLabel.width,
                                            _atTipsLabel.height);
            _wordCountLabel.frame = CGRectMake(_contentBG.right - WORD_COUNT_LABEL_PADDING_RIGHT - _wordCountLabel.width,
                                               _contentBG.bottom - WORD_COUNT_LABEL_PADDING_BOTTOM - _wordCountLabel.height,
                                               _wordCountLabel.width,
                                               _wordCountLabel.height);
        }
    }
    [UIView commitAnimations];
}

- (void)keyboardWillHideHandler:(NSNotification *)notif
{
    _keyboardHeight = 0;
    
    [UIView beginAnimations:@"change" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.15];
    
    _toolbarBG.hidden = NO;
    _atTipsLabel.hidden = NO;
    
    _contentBG.frame = CGRectMake(PADDING_LEFT,
                                  PADDING_TOP,
                                  self.view.width - PADDING_LEFT - PADDING_RIGHT,
                                  self.view.height - TOOLBAR_HEIGHT - VERTICAL_GAP - PADDING_BOTTOM - _keyboardHeight);
    _toolbarBG.frame = CGRectMake(PADDING_LEFT + 1,
                                  _contentBG.bottom + VERTICAL_GAP,
                                  self.view.width - PADDING_LEFT - PADDING_RIGHT - 2,
                                  TOOLBAR_HEIGHT);
    
    if (_image)
    {
        _textView.frame = CGRectMake(PADDING_LEFT,
                                     PADDING_TOP + 1,
                                     _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                     _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
    }
    else
    {
        _textView.frame = CGRectMake(PADDING_LEFT,
                                     PADDING_TOP + 1,
                                     _contentBG.right - PADDING_RIGHT - PADDING_LEFT,
                                     _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
    }
    
    _toolbar.frame = CGRectMake(_toolbarBG.left + 2, _toolbarBG.top, _toolbarBG.width - 4, _toolbarBG.height);
    
    _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
    _atTipsLabel.frame = CGRectMake(_atButton.right + AT_BUTTON_HORIZONTAL_GAP,
                                    _atButton.top + (_atButton.height - _atTipsLabel.height) / 2,
                                    _atTipsLabel.width,
                                    _atTipsLabel.height);
    _wordCountLabel.frame = CGRectMake(_contentBG.right - WORD_COUNT_LABEL_PADDING_RIGHT - _wordCountLabel.width,
                                       _contentBG.bottom - WORD_COUNT_LABEL_PADDING_BOTTOM - _wordCountLabel.height,
                                       _wordCountLabel.width,
                                       _wordCountLabel.height);
    
    [UIView commitAnimations];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateWordCount];
}

@end
