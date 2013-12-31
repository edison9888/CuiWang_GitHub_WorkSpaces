//
//  ResignsetrViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-19.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "ResignsetrViewController.h"

@interface ResignsetrViewController ()

@end

@implementation ResignsetrViewController
@synthesize maskBtn;
@synthesize theTableView;
@synthesize regex;
@synthesize regex2;
@synthesize HUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
        regex2 = @"^[a-zA-Z0-9]{6,16}$";
        
    }
    return self;
}
//--------
- (void)passValue:(NSString *)value
{
    NSLog(@"value == %@",value);
    userID = value;
}
//--------
- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.TopView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lianxijieguo_1.png"]];
    _TopView.userInteractionEnabled = YES;
    
    maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maskBtn.frame = CGRectMake(10, 11,24, 37);
    [maskBtn setImage:[UIImage imageNamed:@"zhuce_1.png"] forState:UIControlStateNormal];
    [maskBtn setImage:[UIImage imageNamed:@"zhuce_2.png"] forState:UIControlStateHighlighted];
    [maskBtn addTarget:self action:@selector(maskBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_TopView addSubview:maskBtn];
    [self.view addSubview:_TopView];
    
    [self loadTableView:theTableView TableViewStyle:UITableViewStyleGrouped];
}

-(void)loadTableView:(UITableView *)thetableView TableViewStyle:(UITableViewStyle )style
{
    thetableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0.0, 59.0, self.view.width, self.view.height-59.0)
                                                                style:UITableViewStyleGrouped];
    thetableView.rowHeight = 40.0;
    thetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    thetableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    thetableView.backgroundColor = [UIColor clearColor];
    thetableView.scrollEnabled = NO;
    thetableView.backgroundView = nil;
    thetableView.dataSource = self;
    thetableView.delegate = self;
    [self.view addSubview:thetableView];
}

-(void)maskBtnDidClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"关闭注册页面------回调");//这里打个断点，点击按钮模态视图移除后会回到这里
    }];
}

#pragma mark - UITableViewDataSource
//必须实现下面这个函数才能使得俩按钮可点
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView*View = [[UIView alloc]initWithFrame:CGRectMake(0, 0,320, 50)];
        UIButton *thisButton = [UIButton buttonWithType:UIButtonTypeCustom];
        thisButton.frame = CGRectMake(10, 17, 16, 16);
        thisButton.enabled = NO;
        [thisButton setImage:[UIImage imageNamed:@"zhuce_3.png"] forState:UIControlStateNormal];
        
        UILabel *thisLabel = [[UILabel alloc]initWithFrame:CGRectMake(41, 5, 100, 40)];
        thisLabel.font = [UIFont boldSystemFontOfSize:16];
        thisLabel.textColor = [UIColor colorWithRGB:0x3a3a3a];
        thisLabel.text = @"帐号信息";
        [View addSubview:thisButton];
        [View addSubview:thisLabel];
        return View;
    }
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    [sender resignFirstResponder];
    //-------正则判断
    if (sender.tag == 1) {
        NSString *email = sender.text;
        [self regexForString:email Regex:regex Word:@"请输入合法的邮箱地址!" localtion:1];
    }else if(sender.tag == 2)
        {
        NSString *passwd = sender.text;
        [self regexForString:passwd Regex:regex2 Word:@"请输入6-18位数字或字母!" localtion:2];
        }else
            {
            NSString *passwd = sender.text;
            [self regexForString:passwd Regex:regex2 Word:@"请输入6-18位数字或字母!" localtion:3];
            }
    
    
    return YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    static NSString  *CellIdentifier = @"CellIdentifier";
    static NSString  *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell ;
    
    if (section == 0)
        {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
            {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor colorWithRGB:0x3a3a3a];
            }
        
        //cell.textLabel.text = [_worldArray objectAtIndex:section];
        //cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
        
        CGRect textFieldRect = CGRectMake(0.0, 0.0f, 185.0f, 31.0f);
        
        theTextField = [[UITextField alloc] initWithFrame:textFieldRect];
        theTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        theTextField.returnKeyType = UIReturnKeyDone;
        theTextField.clearButtonMode = YES;
        theTextField.tag = row+1;
        theTextField.delegate = self;
        
        //此方法为关键方法
        [theTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        switch (row)
            {
                case 0:
                {
                theTextField.placeholder = @"请输入您常用的邮箱";
                theTextField.keyboardType = UIKeyboardTypeEmailAddress;
                cell.textLabel.text = @"邮箱地址";
                }break;
                case 1:{
                    theTextField.placeholder = @"6-18位数字或字母";
                    theTextField.secureTextEntry = YES;
                    cell.textLabel.text = @"密码";
                }break;
                case 2:{
                    theTextField.placeholder = @"请再次输入密码";
                    theTextField.secureTextEntry = YES;
                    cell.textLabel.text = @"重复密码";
                }break;
                default:theTextField.placeholder = @"请再次输入新密码";break;
            }
        cell.accessoryView = theTextField;
        }
    else
        {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRGB:0x3a3a3a];
            }
        
        
        cell.textLabel.textColor = [UIColor colorWithRGB:0x2c7cff];
        cell.textLabel.textAlignment = 1;
        
        cell.textLabel.text = @"立即注册";
        }
    return cell;
    
}
//--------------获取text
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1: self.name = textField.text;break;
        case 2:self.phone = textField.text;break;
        case 3:self.email = textField.text;break;
        default:break;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
        {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"提交注册信息";
        HUD.minSize = CGSizeMake(135.f, 135.f);
        
        [HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
        }
    
    //    [self regexForString:self.name Regex:regex Word:@"帐号错误,请核对邮箱地址!" localtion:1];
    //    [self regexForString:self.phone Regex:regex2 Word:@"请输入6-18位数字或字母!" localtion:2];
    //        [self regexForString:self.email Regex:regex2 Word:@"请输入6-18位数字或字母!" localtion:3];
    
    //------与服务器交互
}
- (void)myMixedTask {
	sleep(1);
    UITextField *t1 = (UITextField*)[self.view viewWithTag:1];
    UITextField *t2 = (UITextField*)[self.view viewWithTag:2];
    UITextField *t3= (UITextField*)[self.view viewWithTag:3];
    
    [self regexForString:self.name Regex:regex Word:@"帐号错误,请核对邮箱地址!" localtion:1];
    [self regexForString:self.phone Regex:regex2 Word:@"请输入6-18位数字或字母!" localtion:2];
    [self regexForString:self.email Regex:regex2 Word:@"请输入6-18位数字或字母!" localtion:3];
    
    //------如果两次密码不同
    if (![self.phone isEqualToString:self.email]) {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"两次输入的密码不相同!";
        hud.labelFont = [UIFont fontWithName:@"Arial" size:18];
        //显示对话框
        [hud showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(2);
        } completionBlock:^{
            //操作执行完后取消对话框
            [t2 setText:@""];
            [t3 setText:@""];
            [hud removeFromSuperview];
        }];
        return;
    }
    else
        {
        
        //------提交注册信息 http://192.168.0.179:9867/tqWord/pad_userAdd?username=xin&password=11&empowerID=12345
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"完成";
        
        NSString *empowerID;
        if ([userID isEqualToString:@"sina"]) {
            empowerID = [ud objectForKey:@"sinaUID"];
        }else if ([userID isEqualToString:@"qq"]) {
            empowerID = [ud objectForKey:@"qqUID"];
        }else {
            empowerID = [ud objectForKey:@"renrenUID"];
        }
        
        NSString *surl = @"http://cuiwang.sinaapp.com/UserAdd.php";
        
        NSURL *url = [NSURL URLWithString:surl];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:self.name forKey:@"username"];
        [request setPostValue:self.phone forKey:@"password"];
        [request setPostValue:userID forKey:@"type"];
        [request setPostValue:empowerID forKey:@"empowerID"];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error)
            {
            NSString *response = [request responseString];
            NSLog(@"response == %@",response);
            NSDictionary *resultDict = [response objectFromJSONString];
            
            NSString *resultSS = [resultDict objectForKey:@"state"];
            if ([resultSS isEqualToString:@"1"])
                {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    NSString *string = [NSString stringWithString: self.name];
                    [ud setObject:string forKey:@"userName"];
                    NSString *string2 = [NSString stringWithString: self.phone];
                    [ud setObject:string2 forKey:@"userPasswd"];
                    [ud synchronize];
                    
                    NSArray *saveAy = @[string,string2];
                    NSLog(@"关闭注册页面------回调");//这里打个断点，点击按钮模态视图移除后会回到这里
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSetting" object:saveAy];//发送消息给root
                }];
                }
            
        else if ([resultSS isEqualToString:@"0"])
            {
            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:hud];
            hud.dimBackground = YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"用户名已存在!";
            hud.labelFont = [UIFont fontWithName:@"Arial" size:18];
            //显示对话框
            [hud showAnimated:YES whileExecutingBlock:^{
                //对话框显示时需要执行的操作
                sleep(1);
            } completionBlock:^{
                [t1 setText:@""];
                [hud removeFromSuperview];
                return ;
            }];
            }
        else
            {
            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:hud];
            hud.dimBackground = YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"注册失败,请检查网络!";
            hud.labelFont = [UIFont fontWithName:@"Arial" size:18];
            //显示对话框
            [hud showAnimated:YES whileExecutingBlock:^{
                //对话框显示时需要执行的操作
                sleep(2);
            } completionBlock:^{
                [t2 setText:@""];
                [t3 setText:@""];
                [hud removeFromSuperview];
                return ;
            }];
            }
        
        }
}
}
@end
