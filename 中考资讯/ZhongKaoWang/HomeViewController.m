//
//  HomeViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-22.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "HomeViewController.h"
#import "GKListViewController.h"
#import "DragButtonViewController.h"
#import "titleClass.h"
#import "ContentViewController.h"
#import "WebOpenViewController.h"


#define isNetOk [CW_Tools checkNetworkConnection]

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize VCArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:YES forKey:@"HomeViewLoaded"];
        titleArray = [[NSMutableArray alloc]initWithCapacity:10];
        VCArray = [[NSMutableArray alloc]initWithCapacity:10];
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(reflashUI:) name:@"reflashHomeUI" object:nil];
    }
    return self;
}
#pragma mark 编辑栏目退出后 刷新UI
-(void)reflashUI:(NSNotification *)notification
{
    NSString *str = notification.object;
    if ([str isEqualToString:@"0"]) {
        //--------只保留前面两个视图
        for (int i = 2; i < VCArray.count; i++) {
            [VCArray removeLastObject];
        }
    }
    titleArray =[[NSUserDefaults standardUserDefaults] objectForKey:@"titleArray"];
    [slideSwitchView buildUI:YES];
}

-(void)OpenWebViewByUrl:(NSString *)url
{
    [CW_Tools ToastNotification:@"页面加载中..." andView:self.view andLoading:YES andIsBottom:NO doSomething:^{
        WebOpenViewController *webOpen;
        if (isIPhone5) {
          webOpen   = [[WebOpenViewController alloc]initWithUrl:url NibName:@"WebOpenViewController_ip5" bundle:nil];
        } else {
            webOpen = [[WebOpenViewController alloc]initWithUrl:url NibName:@"WebOpenViewController" bundle:nil];
        }
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:webOpen];
        [self presentViewController:nav animated:YES completion:^{
            //        <#code#>
        }];
    }];
}

#pragma mark - 视图已经加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
     slideSwitchView = [[GKSlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    slideSwitchView.slideSwitchViewDelegate = self;
    [self.view addSubview:slideSwitchView];
    //-----ios7
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //--------导航栏 左右按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(20, 25, 16, 34);
    [leftBtn setImage:[UIImage imageNamed:@"i_1.png"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"i.png"] forState:UIControlStateSelected];
    [leftBtn setImage:[UIImage imageNamed:@"i.png"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(292, 25, 28, 34);
//    [rightBtn setImage:[UIImage imageNamed:@"user_1.png"] forState:UIControlStateNormal];
//    [rightBtn setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateSelected];
//    [rightBtn setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateHighlighted];
//    [rightBtn addTarget:self action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
    

    
    //--------设置导航栏 背景 左右按钮
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_header.png"] forBarMetrics:UIBarMetricsDefault];
    
//    [self.view addSubview:leftBtn];
    [self.navigationController.view addSubview:leftBtn];
    /*
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    */
    //-------设置颜色
    slideSwitchView.tabItemNormalColor = [CW_Tools colorFromHexRGB:@"868686"];
    slideSwitchView.tabItemSelectedColor = [CW_Tools colorFromHexRGB:@"bb0b15"];
    slideSwitchView.shadowImage = [UIImage imageNamed:@"qiehuan.png"];
    
    //--------设置右边按钮
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightSideButton.backgroundColor = [UIColor whiteColor];
    [rightSideButton setImage:[UIImage imageNamed:@"tianjia.png"] forState:UIControlStateNormal];
    [rightSideButton setImage:[UIImage imageNamed:@"tianjia_1.png"]  forState:UIControlStateHighlighted];
    rightSideButton.frame = CGRectMake(0, 0, 30.0f, 44.0f);
    [rightSideButton addTarget:self action:@selector(rightSideButtonClick) forControlEvents:UIControlEventTouchUpInside];
    slideSwitchView.rigthSideButton = rightSideButton;
    
    titleArray =[[NSUserDefaults standardUserDefaults] objectForKey:@"titleArray"];
    [self addVtoRootVC];
//
    [slideSwitchView buildUI:NO];
}

#pragma mark - 打开内容页面 代理
-(void)OpenCVCByCID:(NSString *)catid NID:(NSString *)nid Title:(NSString *)title Image:(NSString *)image
{
//    DLog(@"OpenCVCByCID  catid == %@",catid);
    [CW_Tools ToastNotification:@"正在打开页面..." andView:self.view andLoading:YES andIsBottom:NO doSomething:^{
        
        ContentViewController *contentVC;
        
        if (isIPhone5) {
            contentVC = [[ContentViewController alloc]initWithCatID:catid ContentID:nid ContentTitle:title Content:nil Cimage:image NibName:@"ContentViewController_ip5" bundle:nil];

        } else {
            
            contentVC = [[ContentViewController alloc]initWithCatID:catid ContentID:nid ContentTitle:title Content:nil Cimage:image NibName:@"ContentViewController" bundle:nil];
        }
        
        
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:contentVC];
        nav.modalTransitionStyle = 2;
        [self presentViewController:nav animated:YES completion:^{
            //        <#code#>
        }];
    }];
    
   
}

/**
 *   添加前两个
 *   视图进rootscrollview 后面的不添加
 */
-(void)addVtoRootVC
{
    NSUserDefaults *udtest = [NSUserDefaults standardUserDefaults];
    NSMutableArray *myViewDidLoadArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    [myViewDidLoadArr addObject:@"推荐"];
    [myViewDidLoadArr addObject:@"热点"];
    
    [udtest setObject:myViewDidLoadArr forKey:@"myViewDidLoad"];
    [udtest synchronize];
    //--------加载两个默认的视图数据
     GKListViewController *tmpVC ;
        for (int i = 0; i < 2; i++) {
            if (isIPhone5) {
                tmpVC = [[GKListViewController alloc]initWithNibName:@"GKListViewController_ip5" bundle:nil];
                
            } else {
                tmpVC = [[GKListViewController alloc]initWithNibName:@"GKListViewController" bundle:nil];
            }
            tmpVC.delegate = self;
            NSDictionary *thisDic = [titleArray objectAtIndex:i];
            tmpVC.title = [thisDic objectForKey:@"catname"];
            tmpVC.catid =[thisDic objectForKey:@"catid"];
            [VCArray addObject:tmpVC];
    }
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
    
    if (isNetOk) {
        
        DragButtonViewController *pushMain = [DragButtonViewController new];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pushMain];
        [self presentViewController:nav animated:YES completion:^{
            //        <#code#>
        }];
    }
    else {
        [CW_Tools ToastViewInView:self.view withText:@"没有网络!"];
    }
    
}
#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(GKSlideSwitchView *)view
{
    return titleArray.count;
}

- (GKListViewController *)slideSwitchView:(GKSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    NSString *title = [((NSDictionary *)[titleArray objectAtIndex:number]) objectForKey:@"catname"];
    NSString *titleid = [((NSDictionary *)[titleArray objectAtIndex:number]) objectForKey:@"catid"];
    
    for (int i = 0; i < VCArray.count; i++) {
        if ([((GKListViewController *)VCArray[i]).title isEqualToString:title]) {
            GKListViewController *currentVC = [VCArray objectAtIndex:i];
           return currentVC;
        }
    }
    
        GKListViewController *tmpVC ;
    if (isIPhone5) {
        tmpVC = [[GKListViewController alloc]initWithNibName:@"GKListViewController_ip5" bundle:nil];
        
    } else {
        tmpVC = [[GKListViewController alloc]initWithNibName:@"GKListViewController" bundle:nil];
    }
    tmpVC.delegate = self;
        tmpVC.title = title;
        tmpVC.catid = titleid;
        [VCArray addObject:tmpVC];
        return tmpVC;
}

- (void)slideSwitchView:(GKSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    subMMDrawerController *drawerController = (subMMDrawerController *)self.navigationController.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}

- (void)slideSwitchView:(GKSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    NSString *title = [((NSDictionary *)[titleArray objectAtIndex:number]) objectForKey:@"catname"];
    NSString *titleid = [((NSDictionary *)[titleArray objectAtIndex:number]) objectForKey:@"catid"];
    BOOL isHere = NO;
    for (int i = 0; i < VCArray.count; i++) {
        if ([((GKListViewController *)VCArray[i]).title isEqualToString:title]) {
            isHere = YES;
            GKListViewController *currentVC = [VCArray objectAtIndex:i];
            [currentVC viewDidCurrentView];
        }
    }
    if (!isHere) {
        
        GKListViewController *tmpVC ;
        if (isIPhone5) {
            tmpVC = [[GKListViewController alloc]initWithNibName:@"GKListViewController_ip5" bundle:nil];
            
        } else {
            tmpVC = [[GKListViewController alloc]initWithNibName:@"GKListViewController" bundle:nil];
        }
        
        tmpVC.delegate = self;
        tmpVC.title = title;
        tmpVC.catid = titleid;
        [VCArray addObject:tmpVC];
        [tmpVC viewDidCurrentView];
    }
}

#pragma mark - 内存报警

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
