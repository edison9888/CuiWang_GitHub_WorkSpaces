//
//  webViewController.m
//  poptoolbar
//
//  Created by zzvcom on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()

@end

@implementation webViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)   
        {
            webview  = [[UIWebView   alloc]  initWithFrame:CGRectMake( 0,  0 ,  768 ,  1004.0 )];	
        }
        else {
            webview  = [[UIWebView   alloc]  initWithFrame:CGRectMake( 0,  0 ,  320.0 ,  460.0 )];	
        }
        
        webview.scalesPageToFit = TRUE;
        [ webview   setUserInteractionEnabled: YES ];	 //是否支持交互
        
        [ webview   setDelegate: self ];				 //委托
        
        [ webview   setOpaque: YES ];					 //透明
        
        [ self . view  addSubview : webview];			 //加载到自己的view
        
        activityIndicator = [[ UIActivityIndicatorView   alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicator setCenter:self.view.center];
        
        [self.view addSubview:activityIndicator];

        CGSize viewSize = self.view.frame.size;
        float toolbarHeight = 44.0;
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
        
        UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"首页" 
                                                                    style:UIBarButtonItemStylePlain target:self 
                                                                   action:@selector(buttonClick:)];
        
        UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithTitle:@"通讯录" 
                                                                    style:UIBarButtonItemStyleBordered 
                                                                   target:self 
                                                                   action:@selector(buttonClick:)];
        [button2 setWidth:100.0];
        UIBarButtonItem *button3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"apple_icon.png"] 
                                                                    style:UIBarButtonItemStyleBordered 
                                                                   target:self 
                                                                   action:@selector(buttonClick:)];
        
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                                    target:nil 
                                                                                    action:nil];
        
        UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
                                                                                     target:self 
                                                                                     action:@selector(buttonClick:)];
        
        NSArray *buttons = [[NSArray alloc] initWithObjects:button1,button2,button3, flexButton,trashButton,nil];
        
        //cleanup
        [button1 release];
        [button2 release];
        [button3 release];
        [flexButton release];
        [trashButton release];
        
        [myToolbar setItems:buttons animated:YES];
        
        [myToolbar setTag:999];
        [buttons release];
        
//        [viewbar addSubview:myToolbar];
       [self.view addSubview:myToolbar];

        UIPanGestureRecognizer* singlePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]; 
        [self.view addGestureRecognizer:singlePan]; 
        singlePan.delegate = self; 
        singlePan.cancelsTouchesInView = NO; 
        [singlePan release]; 

    }
    return self;
}
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
    [webview loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString :@"http://www.baidu.com"]]];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
