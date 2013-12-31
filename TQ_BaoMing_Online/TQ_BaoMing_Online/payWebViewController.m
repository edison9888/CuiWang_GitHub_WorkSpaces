//
//  payWebViewController.m
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-10-23.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "payWebViewController.h"
#import "Step4ViewController.h"

@interface payWebViewController ()

@end

@implementation payWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - 上个页面传过来的url
- (void)setwebValue:(NSString *)urlstring
{
    NSLog(@"setwebValue == %@",urlstring);
    urlString = urlstring;
    
//    [self.view setNeedsDisplay];
}
- (IBAction)webbackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
//        <#code#>
    }];
}
- (IBAction)nextStepClick:(id)sender {
    Step4ViewController *step4 = [Step4ViewController new];
    [self presentViewController:step4 animated:YES completion:^{
//        <#code#>
    }];
}
- (IBAction)webback:(id)sender {
    [self.payweb goBack];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:url];
    [self.payweb loadRequest:request1];
    [self.payweb setUserInteractionEnabled:YES];
    self.payweb.scalesPageToFit = YES;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    [self.view addSubview : activityIndicatorView] ;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicatorView stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"页面加载失败" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alterview show];
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
