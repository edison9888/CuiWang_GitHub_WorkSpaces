//
//  Created by tuo on 4/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RootViewController.h"
#import "CoverFlowView.h"

#import "webViewController.h"
@implementation RootViewController
@synthesize passDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
    //To change the template use AppCode | Preferences | File Templates.
}

- (void)viewDidLoad {
    [super viewDidLoad];  //To change the template use AppCode | Preferences | File Templates.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]];
    self.view.frame = CGRectMake(0, 0, 1024, 768);
    
    NSMutableArray *sourceImages = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i <7 ; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i]];
        
        [sourceImages addObject:image];
    }
    
    //CoverFlowView *coverFlowView = [CoverFlowView coverFlowViewWithFrame: frame andImages:_arrImages sidePieces:6 sideScale:0.35 middleScale:0.6];
    CoverFlowView *coverFlowView = [CoverFlowView coverFlowViewWithFrame:self.view.frame andImages:sourceImages sideImageCount:6 sideImageScale:0.6 middleImageScale:0.9];
    
    UIButton *regButton = [UIButton buttonWithType:UIButtonTypeCustom];
    regButton.frame = CGRectMake(930, 15, 74, 26);
    [regButton setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:regButton];
    [self.view addSubview:coverFlowView];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(OpenWebView:)
                                                 name: @"openWeb"
                                               object: nil];
    
}
-(void)OpenWebView:(NSNotification *)_notification
{
    NSString *url = [_notification object];
    
    webViewController *webView = [[webViewController alloc]init];
    
    self.passDelegate = webView;
    [self.passDelegate setUrlValue: url];
    
    [self presentViewController:webView animated:YES completion:^{
        NSLog(@"打开浏览器!");
    }];
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
}

@end