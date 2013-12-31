//
//  userHomeViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-2.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "userHomeViewController.h"
#import "surveyViewController.h"
#import "LoadingViewController.h"
#import <AGCommon/UIView+Common.h>
@interface userHomeViewController ()

@end

@implementation userHomeViewController
@synthesize usertableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *nickname = [ud objectForKey:@"nickName"];//-----UID
    NSString *username = [ud objectForKey:@"userName"];//-----UID
    
    NSLog(@"nickname == %@",nickname);
    if (nickname.length>0) {
        self.titleLB.text = nickname;
    } else {
        self.titleLB.text = username;
    }
    
    [self.theTableView setHidden:YES];
    
    //------第1部分
    UIImageView *timeImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 70, 20, 19)];
    timeImg.image = [UIImage imageNamed:@"user_-(1).png"];
    [self.view addSubview:timeImg];
    
    UILabel *timeLB = [[UILabel alloc]initWithFrame:CGRectMake(40, 73, 270, 20)];
    timeLB.font = [UIFont systemFontOfSize:12];
    timeLB.text = @"你的帐号有效期到2013年8月13日 , 你可以续费";
    [self.view addSubview:timeLB];
    //------第2部分
    UIButton *lf1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    lf1Btn.frame = CGRectMake(10, 100, 94, 64);
    [lf1Btn setImage:[UIImage imageNamed:@"user (1).png"]  forState:UIControlStateNormal];
    UIButton *lf2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    lf2Btn.frame = CGRectMake(114, 100, 94, 64);
    [lf2Btn setImage:[UIImage imageNamed:@"user (2).png"]  forState:UIControlStateNormal];
    UIButton *lf3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    lf3Btn.frame = CGRectMake(218, 100, 94, 64);
    [lf3Btn setImage:[UIImage imageNamed:@"user (3).png"]  forState:UIControlStateNormal];
    
    [self.view addSubview:lf1Btn];
    [self.view addSubview:lf2Btn];
    [self.view addSubview:lf3Btn];
    
    UIButton *rt1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    rt1Btn.frame = CGRectMake(10, 180, 71, 48);
    [rt1Btn setImage:[UIImage imageNamed:@"user (4).png"]  forState:UIControlStateNormal];
    UIButton *rt2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    rt2Btn.frame = CGRectMake(87, 180, 71, 48);
    [rt2Btn setImage:[UIImage imageNamed:@"user (5).png"]  forState:UIControlStateNormal];
    UIButton *rt3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    rt3Btn.frame = CGRectMake(164, 180, 71, 48);
    [rt3Btn setImage:[UIImage imageNamed:@"user (6).png"]  forState:UIControlStateNormal];
    UIButton *rt4Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    rt4Btn.frame = CGRectMake(241, 180, 71, 48);
    [rt4Btn setImage:[UIImage imageNamed:@"user (7).png"]  forState:UIControlStateNormal];
    
    [self.view addSubview:rt1Btn];
    [self.view addSubview:rt2Btn];
    [self.view addSubview:rt3Btn];
    [self.view addSubview:rt4Btn];
    
    //------第3部分
    UIImageView *logImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 240, 13, 21)];
    logImg.image = [UIImage imageNamed:@"user_-(2).png"];
    [self.view addSubview:logImg];
    
    UILabel *logLB = [[UILabel alloc]initWithFrame:CGRectMake(35, 240, 270, 20)];
    logLB.font = [UIFont systemFontOfSize:14];
    logLB.text = @"使用反馈";
    [self.view addSubview:logLB];
    //------第4部分
    UIButton *fellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fellBtn.frame = CGRectMake(10, 280, 299, 49);
   [fellBtn setImage:[UIImage imageNamed:@"user (8).png"]  forState:UIControlStateNormal];
    [fellBtn addTarget:self action:@selector(fellsurvey) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fellBtn];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(10, 350, 299, 49);
    [exitBtn setImage:[UIImage imageNamed:@"user (9).png"]  forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];
    
}
-(void)maskBtnDidClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)exitClick
{
    LoadingViewController *loadVC = [[LoadingViewController alloc]init];
    [loadVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal]; //翻转 
    [self presentViewController:loadVC animated:YES completion:^{
    }];
}
-(void)fellsurvey
{
    surveyViewController *surveyVC = [[surveyViewController alloc]init];
    
    [self presentViewController:surveyVC animated:YES completion:^{
        //
    }];
}
-(void)loadTableView:(UITableView *)thetableView TableViewStyle:(UITableViewStyle )style
{

}

@end
