//
//  HomeViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-22.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "GKListViewController.h"
#import "DragButtonViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize VCArray;
@synthesize titleArray;
//@synthesize slideSwitchView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//--------栏目选择返回后  通知 刷新UI
-(void)reflashUI
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    titleArray = [ud objectForKey:@"titleArray"];
    [VCArray removeAllObjects];
    //--------加载视图数据
    for (int i = 0; i < titleArray.count; i++) {
        GKListViewController *tmpVC = [[GKListViewController alloc]init];
        tmpVC.title = [titleArray objectAtIndex:i];
        [VCArray addObject:tmpVC];
    }
    
    [slideSwitchView buildUI];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    VCArray = [[NSMutableArray alloc]initWithCapacity:10];
    //--------注册通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(reflashUI) name:@"reflashHomeUI" object:nil];
    //-------ios7去掉边距
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //--------导航栏 左右按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 16, 34);
    [leftBtn setImage:[UIImage imageNamed:@"i_1.png"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"i.png"] forState:UIControlStateSelected];
    [leftBtn setImage:[UIImage imageNamed:@"i.png"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(292, 25, 28, 34);
    [rightBtn setImage:[UIImage imageNamed:@"user_1.png"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateSelected];
    [rightBtn setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
    
    //--------设置导航栏 背景 左右按钮
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    //-------设置颜色
    slideSwitchView.tabItemNormalColor = [GKSlideSwitchView colorFromHexRGB:@"868686"];
    slideSwitchView.tabItemSelectedColor = [GKSlideSwitchView colorFromHexRGB:@"bb0b15"];
    slideSwitchView.shadowImage = [[UIImage imageNamed:@"qiehuan.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    //--------设置右边按钮
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSideButton setImage:[UIImage imageNamed:@"tianjia.png"] forState:UIControlStateNormal];
    [rightSideButton setImage:[UIImage imageNamed:@"tianjia_1.png"]  forState:UIControlStateHighlighted];
    rightSideButton.frame = CGRectMake(0, 0, 30.0f, 44.0f);
    [rightSideButton addTarget:self action:@selector(rightSideButtonClick) forControlEvents:UIControlEventTouchUpInside];
    slideSwitchView.rigthSideButton = rightSideButton;
    
    
    //--------加载root视图
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    titleArray = [ud objectForKey:@"titleArray"];
    //--------加载视图数据
    for (int i = 0; i < titleArray.count; i++) {
        GKListViewController *tmpVC = [[GKListViewController alloc]init];
        tmpVC.title = [titleArray objectAtIndex:i];
        [VCArray addObject:tmpVC];
    }
    
    [slideSwitchView buildUI];
}

#pragma mark - navigation点击事件
-(void)toggleLeftView
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)toggleRightView
{
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
-(void)rightSideButtonClick
{
    DragButtonViewController *pushMain = [[DragButtonViewController alloc]init];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"cube";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:pushMain animated:YES];
}
#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(GKSlideSwitchView *)view
{
    return VCArray.count;
}

- (UIViewController *)slideSwitchView:(GKSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    UIViewController *currentVC = [VCArray objectAtIndex:number];
    return currentVC;
}

- (void)slideSwitchView:(GKSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    subMMDrawerController *drawerController = (subMMDrawerController *)self.navigationController.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}

- (void)slideSwitchView:(GKSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    GKListViewController *vc = [VCArray objectAtIndex:number];
    [vc viewDidCurrentView];
}

#pragma mark - 内存报警
-(void)viewDidUnload
{
    //
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
