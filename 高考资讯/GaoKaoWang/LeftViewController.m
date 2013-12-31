//
//  LeftViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-19.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "LeftViewController.h"
//--------左边视图
#import "SearchViewController.h"
#import "MessageViewController.h"
#import "ShoucanViewController.h"
#import "OffLineDownViewController.h"
#import "SetingViewController.h"
#import "FeedBackViewController.h"


#define isNetOk [CW_Tools checkNetworkConnection]

@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        imageNameArray = @[@"search.png",@"geren_shoucang.png",@"set.png",@"fankui.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_bg4.png"]];
    self.LoadImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked)];
    [self.LoadImageView addGestureRecognizer:singleTap];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reflashProfileImage];
}
#pragma mark 刷新头像
-(void)reflashProfileImage
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
//        self.LoadImageView.layer.cornerRadius = 10;
//        self.LoadImageView.layer.masksToBounds = YES;
    
//    
//    if ([ud boolForKey:@"UserIsLoaded"]) {
//        
//    }
    
    [self.LoadImageView setImage:[UIImage imageNamed:@"lijidenglu@2x.png"]];
    if ([ud boolForKey:@"UserIsLoaded"]) {
        self.userlabel.text = [ud stringForKey:@"nickname"];
        self.userlabel.hidden = NO;
        [self.LoadImageView setImageWithURL:[ud URLForKey:@"profileImage"]
                           placeholderImage:[UIImage imageNamed:@"queen.png"]];
    }
}
- (void)UesrClicked {
    
    GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"提醒"
                                                    message:@"您确定要退回到登录界面吗?"
                                                   delegate:self
                                          cancelButtonTitle:@"退回"
                                          otherButtonTitles:@"取消", nil];
    alert.style = GRAlertStyleInfo;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//                }];
    }
}

- (void)searchButtonClick {
    
    if (isNetOk) {
        [CW_Tools ToastNotification:@"loading..." andView:self.view andLoading:YES andIsBottom:YES doSomething:^{
            if (!self.searchVC) {
                SearchViewController *searchVc = [SearchViewController new];
                self.searchVC = [[UINavigationController alloc] initWithRootViewController:searchVc];
            }
        }];
        
        [self presentViewController:self.searchVC animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName: @"reflashSearchUI"
                                                                object: nil];
        }];
    } else {
        [CW_Tools ToastViewInView:self.view withText:@"请连接网络后再使用!"];
    }
    
   
}

- (IBAction)messageButtonClick:(id)sender {
    
    if (!self.messageVC) {
        MessageViewController *messageVc = [MessageViewController new];
        self.messageVC = [[UINavigationController alloc] initWithRootViewController:messageVc];
    }
    
    [self presentViewController:self.messageVC animated:YES completion:^{
        //        <#code#>
    }];
}
- (void)shoucanButtonClick {
    
    if (!self.shoucanVC) {
        
        ShoucanViewController *shoucanVc;
        if (isIPhone5) {
            shoucanVc = [[ShoucanViewController alloc]initWithNibName:@"ShoucanViewController_ip5" bundle:nil];
        } else {
            shoucanVc = [[ShoucanViewController alloc]initWithNibName:@"ShoucanViewController" bundle:nil];
        }
        
       
        self.shoucanVC = [[UINavigationController alloc] initWithRootViewController:shoucanVc];
    }
    
    [self presentViewController:self.shoucanVC animated:YES completion:^{
        //        <#code#>
    }];
}
- (IBAction)offlineButtonClick:(id)sender {
    
    if (!self.offLineVC) {
        OffLineDownViewController *offlineVc = [OffLineDownViewController new];
        self.offLineVC = [[UINavigationController alloc] initWithRootViewController:offlineVc];
    }
    
    [self presentViewController:self.offLineVC animated:YES completion:^{
        //        <#code#>
    }];
}
- (void)setButtonClick {
    
    if (!self.setVC) {
        SetingViewController *setVc = [SetingViewController new];
        self.setVC = [[UINavigationController alloc] initWithRootViewController:setVc];
    }
    
    [self presentViewController:self.setVC animated:YES completion:^{
        //        <#code#>
    }];
}
- (void)fankuiButtonClick {
    
//    if (!self.fankuiVC) {
//        FanKuiViewController *fankuiVc = [FanKuiViewController new];
//        self.fankuiVC = [[UINavigationController alloc] initWithRootViewController:fankuiVc];
//    }
//    
//    [self presentViewController:self.fankuiVC animated:YES completion:^{
//        //        <#code#>
//    }];
    
    if (!self.fankuiVC) {
         FeedBackViewController *feedBack = [FeedBackViewController new];
        self.fankuiVC = [[UINavigationController alloc] initWithRootViewController:feedBack];
    }
    
//
//    CATransition *transition = [CATransition animation];
//    transition.duration = 1.0f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = @"oglFlip";
//    transition.subtype = kCATransitionFromRight;
//    transition.delegate = self;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    
//    [self.navigationController pushViewController:nav animated:YES];
    
    [self presentViewController:self.fankuiVC animated:YES completion:^{
//        <#code#>
    }];
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self searchButtonClick];
            break;
        case 1:
            [self shoucanButtonClick];
            break;
        case 2:
            [self setButtonClick];
            break;
        case 3:
            [self fankuiButtonClick];
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *cellImageV = [[UIImageView alloc]initWithFrame:CGRectMake(54, 25.5, 68, 19)];
    cellImageV.image = [UIImage imageNamed:imageNameArray[indexPath.row]];

    [cell.contentView addSubview:cellImageV];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 1;
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
