//
//  LoadViewController.m
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-9-16.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "LoadViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "RootViewController.h"


#import "Step1ViewController.h"
#import "Step2ViewController.h"
#import "Step22ViewController.h"
@interface LoadViewController ()




@property (strong, nonatomic) IBOutlet UIButton *denglu;


@end

@implementation LoadViewController

@synthesize denglu;
@synthesize jizhumima;
@synthesize name;
@synthesize password;


-(void)viewDidLoad
{
    [super viewDidLoad];
    [name addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [password addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    NSArray *saveArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"saveArray"];
    if ([saveArray count] > 0) {
        name.text = [saveArray objectAtIndex:0];
        password.text = [saveArray objectAtIndex:1];
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"selected"] == YES) {
        jizhumima.selected = YES;
    } else {
        jizhumima.selected = NO;
    }
    
}
//--------文本框下一步
- (void)textFieldDone:(id)sender {
    if (sender == name) {
        [name resignFirstResponder];
        [password becomeFirstResponder];
    } else {
        [password resignFirstResponder];
    }
    
}
- (void)viewDidUnload
{
    [self setDenglu:nil];
    [super viewDidUnload];
}
- (IBAction)jizhumimaClick:(UIButton *)sender {
    denglu = (UIButton *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (denglu.selected) {
        denglu.selected = NO;
        [userDefaults setBool:NO forKey:@"selected"];
        [userDefaults synchronize];
    }else {
        denglu.selected = YES;
        [userDefaults setBool:YES forKey:@"selected"];
        [userDefaults synchronize];
    }
}

//--------强制横屏
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


#pragma mark - 登录点击
- (IBAction)dengluClick:(UIButton *)sender {
    
    //--------判断用户名和密码有效性
    if (name.text.length == 0 || password.text.length == 0 )
        {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"用户名或密码不能为空!";
        hud.margin = 10.f;
        hud.yOffset = 170.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return;
        }
    //--------判断是否记住密码
    if (jizhumima.selected) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *saveArray = @[name.text,password.text];
        [userDefaults setObject:saveArray forKey:@"saveArray"];
        [userDefaults synchronize];
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *saveArray = @[name.text,@""];
        [userDefaults setObject:saveArray forKey:@"saveArray"];
        [userDefaults synchronize];
    }
    //--------网络连接相关
    
#if NS_BLOCKS_AVAILABLE
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    __block NSString *loadStatus;
	[self.view addSubview:hud];
	hud.labelText = @"登录中...";
	[hud showAnimated:YES whileExecutingBlock:^{
        loadStatus  =   [self getDataFromURLUseString:@"http://bm.taiqiedu.com/site/login?r=rest/users"];
	} completionBlock:^{
        NSLog(@"%@",loadStatus);
        if ([loadStatus isEqualToString:@"error"]) {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.delegate = self;
            [HUD show:YES];
            [HUD hide:YES afterDelay:3];
        } else if([loadStatus isEqualToString:@"1"])
            {
            RootViewController *c = [RootViewController new];
            //            Step2ViewController *c = [Step2ViewController new];
            //            Step22ViewController *c = [Step22ViewController new];
            c.modalTransitionStyle = 2;
            [self presentViewController:c animated:YES completion:^{
                [hud removeFromSuperview];
            }];
            }
        else
            {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning1.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.delegate = self;
            [HUD show:YES];
            [HUD hide:YES afterDelay:3];
            }
	}];
#endif
}

//------获取json数据
-(NSString *)getDataFromURLUseString:(NSString *)urlSS
{
    
    ASIFormDataRequest* formRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlSS]];
    [formRequest setPostValue:name.text forKey:@"user"];
    [formRequest setPostValue:password.text forKey:@"pwd"];
    [formRequest startSynchronous];
    NSError *error = [formRequest error];
    if (!error) {
        
        NSData *data = [formRequest responseData];
        //        NSString *tmp=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"字典里面的内容为-->%@", weatherDic );
        //        for (NSDictionary * key in weatherDic)
        //                 {
        //                 NSLog(@"%@   %@",[key objectForKey:@"id"],[key objectForKey:@"name"]);
        //                 }
        
        //        NSLog(@"%@",[weatherDic objectForKey:@"cou"]);
        //
        return [weatherDic objectForKey:@"cou"];
    }
    return @"error";
}

@end
