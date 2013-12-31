//
//  BaseViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-18.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize t;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        t.font = [UIFont systemFontOfSize:20];
        t.textColor = [UIColor whiteColor];
        t.backgroundColor = [UIColor clearColor];
        t.textAlignment = 1;
        t.text = @"";
        self.navigationItem.titleView = t;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"comm_header.png"] forBarMetrics:UIBarMetricsDefault];
    //  设置自定义返回按钮风格
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"toleft.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button addTarget:self action:@selector(popback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)popback
{
    /*
    void (^myblocks) (BOOL) = NULL;
    myblocks = ^(BOOL finish) {
        Dlog(@"finish? %@",finish?@"YES":@"NO");
        if (finish) {
            if (!self.HomeVC) {
                HomeViewController *homeVC = [HomeViewController new];
                self.HomeVC = [[UINavigationController alloc] initWithRootViewController:homeVC];
            }
            [self.mm_drawerController setCenterViewController:self.HomeVC];
        }
    };
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:myblocks];
     */
    
    [self dismissViewControllerAnimated:YES completion:^{
//        <#code#>
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
