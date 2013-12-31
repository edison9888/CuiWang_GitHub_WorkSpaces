//
//  webViewController.m
//  poptoolbar
//
//  Created by zzvcom on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "webViewController.h"
#import "Step1ViewController.h"


@interface webViewController ()

@end

@implementation webViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      
        webview  = [[UIWebView   alloc]  initWithFrame:CGRectMake( 0,  0 ,  1024 ,  768 )];
      
        webview.scalesPageToFit = TRUE;
        [ webview   setUserInteractionEnabled: YES ];	 //是否支持交互
        
        [ webview   setDelegate: self ];				 //委托
        
        [ webview   setOpaque: YES ];					 //透明
        
        [ self . view  addSubview : webview];			 //加载到自己的view
        
        
        CGSize viewSize = self.view.frame.size;
        float toolbarHeight = 74.0;
        CGRect toolbarFrame = CGRectMake(0,viewSize.height-toolbarHeight,viewSize.width,toolbarHeight);
        viewbar = [[UIView alloc] initWithFrame:toolbarFrame];
//        viewbar.backgroundColor = [UIColor clearColor];
        
        myToolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
        
        myToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth 
        | 
        UIViewAutoresizingFlexibleLeftMargin 
        | 
        UIViewAutoresizingFlexibleRightMargin 
        | 
        UIViewAutoresizingFlexibleTopMargin;
        
        
        UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"退出"
                                                                    style:UIBarButtonItemStyleBordered target:self 
                                                                   action:@selector(buttonClick3)];
    
        [button1 setWidth:100.0];
        
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                                    target:nil 
                                                                                    action:nil];
        
        UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithTitle:@"立即报名"
                                                                    style:UIBarButtonItemStyleBordered target:self
                                                                   action:@selector(buttonBM)];
        [trashButton setWidth:500.0];
        
        UIBarButtonItem *flexButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:nil
                                                                                    action:nil];
        UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                    style:UIBarButtonItemStyleBordered target:self
                                                                   action:@selector(buttonClick)];
        [button2 setWidth:100.0];
        NSArray *buttons = [[NSArray alloc] initWithObjects:button1, flexButton,trashButton,flexButton2,button2,nil];
        
        //cleanup
        
        [myToolbar setItems:buttons animated:YES];
        
        [myToolbar setTag:999];
        
//        [viewbar addSubview:myToolbar];
       [self.view addSubview:myToolbar];

        UIPanGestureRecognizer* singlePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]; 
        [self.view addGestureRecognizer:singlePan]; 
        singlePan.delegate = self; 
        singlePan.cancelsTouchesInView = NO; 

    }
    return self;
}
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url
//{
//   self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.urlString = url;
//    }
//    return  self;
//}
#pragma mark - 按钮点击
-(void)buttonClick
{
    [webview goBack];
}
-(void)buttonClick3
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"退出webview");
    }];
    
//    [self dismissModalViewControllerAnimated:YES];
}
-(void)buttonBM
{
    Step1ViewController * step1 = [Step1ViewController new];
    step1.modalTransitionStyle = 1;
    [self presentViewController:step1 animated:YES completion:^{
//        
    }];
}
#pragma mark - 手势识别
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    //    UIView *view = [gestureRecognizer view]; // 这个view是手势所属的view，也就是增加手势的那个view
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:{ // UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded // 正常情况下只响应这个消息
            NSLog(@"======UIGestureRecognizerStateEnded || UIGestureRecognizerStateRecognized");
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:nil context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:1.0];
            [[self.view viewWithTag:999] setAlpha:1.0f];
            [UIView commitAnimations];

            break;
        }
        case UIGestureRecognizerStateFailed:{ // 
            NSLog(@"======UIGestureRecognizerStateFailed");
            break;
        }
        case UIGestureRecognizerStatePossible:{ // 
            NSLog(@"======UIGestureRecognizerStatePossible");
            break;
        }
        default:{
            NSLog(@"======Unknow gestureRecognizer");
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:nil context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:1.0];
            [[self.view viewWithTag:999] setAlpha:0.0f];
            [UIView commitAnimations];
           
            break;
        }
    }  
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //    NSLog(@"handle touch");
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //    NSLog(@"1");
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //    NSLog(@"2");
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    }
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"webViewDidFinishLoad");
    
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"提示" message:[error localizedDescription]  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alterview show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}
- (void) setUrlValue:(NSString *) value
{
    self.urlString = value;
    NSLog(@"_urlString == %@",_urlString);
    if (_urlString.length > 0) {
        
        [webview loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString :_urlString]]];
    }
    else
        {
        [webview loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString :@"http://www.taiqiedu.com"]]];
        
        }
	// Do any additional setup after loading the view.
}
#pragma mark - 强制横屏
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    //return YES;
}

@end
