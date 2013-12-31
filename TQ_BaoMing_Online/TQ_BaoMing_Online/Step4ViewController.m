//
//  Step4ViewController.m
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-9-24.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "Step4ViewController.h"
#import "RootViewController.h"

@interface Step4ViewController ()

@end

@implementation Step4ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)backClick:(id)sender {
    RootViewController *rootV = [RootViewController new];
    [self presentViewController:rootV animated:YES completion:^{
        //            <#code#>
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
