//
//  Step3ViewController.m
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-9-24.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "Step3ViewController.h"
#import "Step4ViewController.h"
#import "MBProgressHUD.h"
#import "RegexKitLite.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "payWebViewController.h"
@interface Step3ViewController ()

@end

@implementation Step3ViewController

@synthesize yuanjia;
@synthesize youhui;
@synthesize PasswebValueDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        regex = @"^[0-9]*$";
        saveArray = [NSArray new];
    }
    return self;
}
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (IBAction)payClick:(id)sender {
    //--------网络连接相关
    
#if NS_BLOCKS_AVAILABLE
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    __block NSString *loadStatus;
	[self.view addSubview:hud];
	hud.labelText = @"加载中...";
	[hud showAnimated:YES whileExecutingBlock:^{
        loadStatus  =   [self getDataFromURLUseString:@"http://bm.taiqiedu.com/site/login?r=rest/insermanager"];
	} completionBlock:^{
        NSLog(@"loadStatus == %@",loadStatus);
        if ([loadStatus isEqualToString:@"error"]) {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.delegate = self;
            [HUD show:YES];
            [HUD hide:YES afterDelay:3];
        } else
            {
//           http://yc.tqmba.com/tqmba/padinfo.php
            
            NSURL *url=[NSURL URLWithString:@"http://yc.tqmba.com/tqmba/padinfo.php"];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"type"] intValue]== 1) {
                [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"phase"] forKey:@"info"];
            } else {
                [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"detail"] forKey:@"info"];
            }
            
            NSString *stuid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
            NSLog(@"stuid == %@",stuid);
            NSRange range = NSMakeRange(1,stuid.length-2);
            NSString *newstuid = [stuid substringWithRange:range];
            NSLog(@"newstuid == %@",newstuid);
            
            [request setPostValue:youhui.text forKey:@"real_pay"];
            [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"should_pay"] forKey:@"should_pay"];
            [request setPostValue:newstuid forKey:@"stuname"];
            [request setPostValue:date forKey:@"pay_time"];
            [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"project_id"] forKey:@"project_id"];
            [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"class_id"] forKey:@"class_id"];
            [request setDelegate:self];
            //配置代理为本类
            [request setTimeOutSeconds:10];
            //设置超时
            [request setDidFailSelector:@selector(urlRequestFailed:)];
            [request setDidFinishSelector:@selector(urlRequestSucceeded:)];
            [request startAsynchronous];//异步传输
            }
	}];
#endif
    
}
#pragma mark - 网页post 表单
//失败
-(void)urlRequestFailed:(ASIHTTPRequest *)request
{
    NSError *error =[request error];
    NSLog(@"%@",error);
    NSLog(@"连接失败！");
    UIAlertView * alt=[[UIAlertView alloc] initWithTitle:@"提示" message:@"连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alt show];
}

//成功
-(void)urlRequestSucceeded:(ASIHTTPRequest *)request
{
    NSData *data=[request responseData];
    NSString *tmp=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"支付ID == \n%@",tmp);
    //--------返回支付id = 0 失败
    if ([tmp isEqualToString: @"0"]) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
        return;
    }
    //--------拼接url地址
    NSString *urlstr = [NSString stringWithFormat:@"http://yc.tqmba.com/tqmba/payTypes.php?stuid=%@",tmp];
    payWebViewController *payView = [payWebViewController new];
    self.PasswebValueDelegate = payView;
    [self.PasswebValueDelegate setwebValue:urlstr];
    [self presentViewController:payView animated:YES completion:^{
//        <#code#>
    }];
    
}


//------获取json数据
-(NSString *)getDataFromURLUseString:(NSString *)urlSS
{
    ASIFormDataRequest* formRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlSS]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    saveArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"saveArray"];
    NSString *stuid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSRange range = NSMakeRange(1,stuid.length-2);
    NSString *newstuid = [stuid substringWithRange:range];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"project_id"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"pp_id"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"class_id"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"type"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"phase"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"detail"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"discount"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"preferential_id"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"should_pay"]);
    NSLog(@"%@",youhui.text);
     NSLog(@"网上银行");
     NSLog(@"%@",date);
    NSLog(@"%@",[saveArray objectAtIndex:0]);
    NSLog(@"footTF == %@",footTF.text);
    
    [formRequest setPostValue:newstuid forKey:@"student_id"];
    [formRequest setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"project_id"] forKey:@"project_id"];
    [formRequest setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"pp_id"] forKey:@"pp_id"];
    [formRequest setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"class_id"] forKey:@"class_id"];
    [formRequest setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"type"] forKey:@"type"];
    [formRequest setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"phase"] forKey:@"phase"];
    [formRequest setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"detail"] forKey:@"detail"];
    [formRequest setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"discount"] forKey:@"discount"];
    [formRequest setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"preferential_id"] forKey:@"preferential_id"];
    [formRequest setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"should_pay"] forKey:@"should_pay"];
    [formRequest setPostValue:youhui.text forKey:@"real_pay"];
    [formRequest setPostValue:@"网上银行" forKey:@"pay_mode"];
    [formRequest setPostValue:date forKey:@"pay_time"];
    [formRequest setPostValue:[saveArray objectAtIndex:0] forKey:@"manager"];
    [formRequest setPostValue:footTF.text forKey:@"remarks"];
    [formRequest startSynchronous];
    NSError *error = [formRequest error];
    if (!error) {
        NSData *data = [formRequest responseData];
        NSString *tmp=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",tmp);
        return tmp;
    }
    return @"error";
}
/*
 *  正则校验
 */
-(BOOL)regexForString:(NSString *)string Regex:(NSString *)gegex Word:(NSString *)word localtion:(int) local
{
    if ([string isMatchedByRegex:gegex])
        {
        NSLog(@"通过校验！%@",string);
        return YES;
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
            [hud removeFromSuperview];
        }];
         return NO;
        }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *yuanjiaStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"should_pay"];
    yuanjia.text = yuanjiaStr;
    youhui.text = yuanjiaStr;
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 765, 70)];
    headV.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"surprise.png"]];
    imageV.frame = CGRectMake(50, 0, 145, 28);
    
    [headV addSubview:imageV];
    return headV;
}// custom view for header. will be adjusted to default or specified header height

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *cellLB = [[UILabel alloc]initWithFrame:CGRectMake(220, 0, 100, 70)];
    cellLB.font = [UIFont systemFontOfSize:25];
    cellLB.textColor = [UIColor colorWithRed:0.56 green:0.01 blue:0.01 alpha:1];
    
    if (indexPath.row == 0) {
        cellLB.text = @"价格优惠";
        jgTF = [[UITextField alloc]initWithFrame:CGRectMake(340, 0, 400, 70)];
        jgTF.placeholder = @"无";
        jgTF.delegate = self;
        jgTF.tag = indexPath.row;
        [jgTF setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
        [jgTF setKeyboardType:UIKeyboardTypeNumberPad];
        jgTF.font = [UIFont systemFontOfSize:24];
        jgTF.clearsOnBeginEditing = YES; //再次编辑就清空
        jgTF.textAlignment = UITextAlignmentCenter;
        
        UILabel *rlb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 70)];
        rlb.textColor = [UIColor colorWithRed:0.56 green:0.01 blue:0.01 alpha:1];
        rlb.text = @"元";
        rlb.font = [UIFont systemFontOfSize:24];
        jgTF.rightView=rlb;
        jgTF.rightViewMode = UITextFieldViewModeAlways;
        //此方法为关键方法

        [cell.contentView addSubview:jgTF];
    } else if(indexPath.row == 1){
        cellLB.text = @"折扣优惠";
        zkTF = [[UITextField alloc]initWithFrame:CGRectMake(340, 0, 400, 70)];
        zkTF.placeholder = @"无";
        zkTF.delegate = self;
        zkTF.tag = indexPath.row;
        [zkTF setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
        [zkTF setKeyboardType:UIKeyboardTypeNumberPad];
        zkTF.font = [UIFont systemFontOfSize:27];
        zkTF.clearsOnBeginEditing = YES; //再次编辑就清空
        zkTF.textAlignment = UITextAlignmentCenter;
        
        UILabel *rlb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 70)];
        rlb.textColor = [UIColor colorWithRed:0.56 green:0.01 blue:0.01 alpha:1];
        rlb.text = @"%";
        rlb.font = [UIFont systemFontOfSize:30];
        zkTF.rightView=rlb;
        zkTF.rightViewMode = UITextFieldViewModeAlways;
        
        //此方法为关键方法
        
        [cell.contentView addSubview:zkTF];
    } else {
        cellLB.text = @"备注";
        footTF = [[UITextField alloc]initWithFrame:CGRectMake(340, 0, 400, 70)];
        footTF.placeholder = @"";
        footTF.delegate = self;
        footTF.tag = indexPath.row;
        [footTF setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
        [footTF setKeyboardType:UIKeyboardTypeNumberPad];
        footTF.font = [UIFont systemFontOfSize:27];
        footTF.clearsOnBeginEditing = YES; //再次编辑就清空
        footTF.textAlignment = UITextAlignmentCenter;
        //此方法为关键方法
        
        [cell.contentView addSubview:footTF];
    }
    
    [cell.contentView addSubview:cellLB];
    return cell;
}

#pragma mark - 获取输入内容
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
//- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing");
    youhui.text = yuanjia.text; //--------价格还原
    if (textField == jgTF) {
        zkTF.text = @"";
    } else if(textField == zkTF){
        jgTF.text = @"";
    } else{
        //
    }
    return YES;
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (textField == jgTF) {
        zkTF.text = @"";
        
      if(  [self regexForString:jgTF.text Regex:regex Word:@"非法字符!" localtion:0] )
          {
          int jgint =   [youhui.text intValue] - [textField.text intValue] ;
          if (jgint < 0) {
              youhui.text = @"0.0";
              return;
          } else {
              NSString *jgStr = [NSString stringWithFormat:@"%d",jgint];
              youhui.text = jgStr;
              [userDefaults setObject:[NSNumber numberWithInt:100] forKey:@"discount"];
              [userDefaults setObject:[NSNumber numberWithInt:[youhui.text intValue]] forKey:@"preferential_id"];
              [userDefaults synchronize];
          }
          } else {
              textField.text = @"";
          }
    } else if(textField == zkTF){
        jgTF.text = @"";
        if( [self regexForString:jgTF.text Regex:regex Word:@"非法字符!" localtion:0] )
            {
            if ([textField.text intValue] > 100 || [textField.text intValue] < 0) {
                youhui.text = yuanjia.text;
            } else {
                [userDefaults setObject:[NSNumber numberWithInt:[textField.text intValue]] forKey:@"discount"];
                [userDefaults setObject:[NSNumber numberWithInt:0] forKey:@"preferential_id"];
                [userDefaults synchronize];
                
                NSString *zkStr = [NSString stringWithFormat:@"%.2f", ( [youhui.text intValue] * ([textField.text intValue] / 100.0) )];
                youhui.text = zkStr;
            }
            } else {
                textField.text = @"";
            }
    } else{
        //
    }
    
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
