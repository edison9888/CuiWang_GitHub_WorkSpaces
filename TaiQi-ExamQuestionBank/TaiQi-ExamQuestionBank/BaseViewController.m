//
//  BaseViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-11-6.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
 *  正则校验
 */
-(void)regexForString:(NSString *)string Regex:(NSString *)gegex Word:(NSString *)word localtion:(int) local
{
    UITextField *t = (UITextField*)[self.view viewWithTag:local];
    
    if ([string isMatchedByRegex:gegex])
        {
        //        NSLog(@"通过校验！");
        }
    else
        {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = word;
        hud.labelFont = [UIFont fontWithName:@"Arial" size:18];
        //显示对话框
        [hud showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(2);
        } completionBlock:^{
            //操作执行完后取消对话框
            if (local == 1) {
                t.text = @"";
                t.placeholder = @"请输入您的帐号";
                [t setValue:[UIColor darkGrayColor]
                 forKeyPath:@"_placeholderLabel.textColor"];
                [t setValue:[UIFont systemFontOfSize:14]
                 forKeyPath:@"_placeholderLabel.font"];
            }
           else if (local == 2) {
                t.text = @"";
                t.placeholder = @"请输入6-18位数字或字母";
                [t setValue:[UIColor darkGrayColor]
                 forKeyPath:@"_placeholderLabel.textColor"];
                [t setValue:[UIFont systemFontOfSize:14]
                 forKeyPath:@"_placeholderLabel.font"];
            }
           else
               {
               [t setText:@""];
               [t setValue:[UIColor darkGrayColor]
                forKeyPath:@"_placeholderLabel.textColor"];
               [t setValue:[UIFont systemFontOfSize:14]
                forKeyPath:@"_placeholderLabel.font"];
               t.placeholder = @"6-18位数字或字母";
               [t becomeFirstResponder];
               }
            [hud removeFromSuperview];
        }];
        }
}
    
//------登录
-(NSString *)getDataFromURLUseString:(NSString *)urlSS
{
    NSURL *url = [NSURL URLWithString:urlSS];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
        {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSDictionary *resultDict = [response objectFromJSONString];
        return [resultDict objectForKey:@"Status"];
        }
    return @"error";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
