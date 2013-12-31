//
//  RegisterViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-27.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterContentViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
/**
 *    初始化
 *
 *    @param nibNameOrNil   <#nibNameOrNil description#>
 *    @param nibBundleOrNil <#nibBundleOrNil description#>
 *
 *    @return <#return value description#>
 *
 *    @since <#version number#>
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		nameArray = @[@"帐号", @"昵称", @"密码", @"密码确认"];
		inlineArray = @[@"example@163.com", @"不能含有特殊字符", @"6-16位数字或字母", @"再次输入密码"];
		shareArray = @[@"sina", @"qq", @"qqwb"];
        
		self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
	}
	return self;
}

/**
 *  视图已加载
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	self.myRegisterTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zhuce_biankuang.png"]];
}

#pragma mark 第三方登录 代理传值
- (void)passValue:(id)value {
	NSString *myValue = (NSString *)value;
	DLog(@"value == %@", myValue);
	userID = myValue;
}

#pragma mark -
#pragma mark 已读
- (IBAction)ReadClick:(UIButton *)button {
	RegisterContentViewController *contentV = [RegisterContentViewController new];
	UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:contentV];
	[self presentViewController:nv animated:YES completion: ^{
        //            <#code#>
	}];
}

#pragma mark 关闭
- (IBAction)closeClick:(id)sender {
	[self dismissViewControllerAnimated:YES completion: ^{
	}];
}

/**
 *    单选按钮点击
 *
 *    @param button 点击的按钮
 *
 *
 */
- (IBAction)danxuanButtonClick:(UIButton *)button {
	if (button.selected) {
		button.selected = NO;
	}
	else {
		button.selected = YES;
	}
}

#pragma mark -
#pragma mark tableview 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 10)];
	bg.backgroundColor = [UIColor clearColor];
	return bg;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITextField *textField;
	int myTag = 100;
	if (indexPath.section == 0) {
		myTag += indexPath.row;
	}
	else {
		myTag += indexPath.row + 2;
	}
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = [UIColor clearColor];
		textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 200, 34)];
		textField.backgroundColor = [UIColor clearColor];
		textField.tag = myTag;
		textField.returnKeyType = UIReturnKeyNext;
		textField.font = [UIFont systemFontOfSize:14.0f];
		textField.borderStyle = UITextBorderStyleNone;
		textField.textAlignment = 1;
		textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
		[textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
		if (indexPath.section == 1) {
			textField.secureTextEntry = YES; //密码
			textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		}
		if (indexPath.section == 0 && indexPath.row == 1) {
			textField.keyboardType = UIKeyboardTypeNamePhonePad;
		}
		else {
			textField.keyboardType = UIKeyboardTypeASCIICapable;
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[cell.contentView addSubview:textField];
	}
    
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
	UITextField *TxTFD = (UITextField *)[cell.contentView viewWithTag:myTag];
    
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = [nameArray objectAtIndex:indexPath.row];
			TxTFD.placeholder = [inlineArray objectAtIndex:indexPath.row];
			break;
            
		case 1:
			cell.textLabel.text = [nameArray objectAtIndex:indexPath.row + 2];
			TxTFD.placeholder = [inlineArray objectAtIndex:indexPath.row + 2];
			break;
            
		default:
			break;
	}
    
    
	return cell;
}

#pragma mark - 注册按钮点击
- (IBAction)registerButtonClick:(id)sender {
	BOOL isMobile = [CW_Tools isMobile:zhanghao];
	BOOL isEmail   = [CW_Tools isEmail:zhanghao];
	if (isMobile || isEmail) {
		if ([password isEqualToString:passwd]) {
			if ([CW_Tools isPassword:password]) {
				if (self.danxuanButton.selected) {
					HUD = [[MBProgressHUD alloc] initWithView:self.view];
					[self.view addSubview:HUD];
					HUD.delegate = self;
					HUD.labelText = @"提交注册信息";
					HUD.minSize = CGSizeMake(135.f, 135.f);
					//--------注册
					[HUD showWhileExecuting:@selector(myreMixedTask) onTarget:self withObject:nil animated:YES];
				}
				else {
					[self ShowMBView:@"请确认注册协议!" Location:0];
				}
			}
			else {
				[self ShowMBView:@"密码输入有误!" Location:103];
			}
		}
		else {
			[self ShowMBView:@"两次输入的密码不同!" Location:102];
		}
	}
	else {
		[self ShowMBView:@"帐号输入有误!" Location:100];
	}
}

#pragma mark - 注册
- (void)myreMixedTask {
	UITextField *t0 = (UITextField *)[self.view viewWithTag:100];
	UITextField *t1 = (UITextField *)[self.view viewWithTag:101];
    
    
    
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
	NSString *empowerID;
	if (userID) {
		if ([userID isEqualToString:@"sina"]) {
			empowerID = [ud stringForKey:@"sinaUID"];
		}
		else if ([userID isEqualToString:@"qq"]) {
			empowerID = [ud stringForKey:@"qqUID"];
		}
		else {
			empowerID = [ud stringForKey:@"qqwbUID"];
		}
	}
    
	DLog(@"zhanghao = %@  nicheng = %@  password = %@  passwd = %@  userID = %@  empowerID = %@", zhanghao, nicheng, password, passwd, userID, empowerID);
    
	HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		HUD.progress = progress;
		usleep(10000);
	}
    
	NSString *surl = @"http://27.112.1.16/padapi/insermemberfrom.php";
    
	NSURL *url = [NSURL URLWithString:surl];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:password forKey:@"pwd"];
	[request setPostValue:zhanghao forKey:@"loginname"];
	[request setPostValue:nicheng forKey:@"username"];
	[request setPostValue:empowerID forKey:@"connid"];
	[request setPostValue:userID forKey:@"from"];
	[request startSynchronous];
	NSError *error = [request error];
    
    
    
	if (!error) {
		NSString *response = [request responseString];
		DLog(@"注册  response == %@", response);
        
		if (![response isEqualToString:@"0"]) {
			__block UIImageView *imageView;
			dispatch_sync(dispatch_get_main_queue(), ^{
			    UIImage *image = [UIImage imageNamed:@"37x-Checkmark.png"];
			    imageView = [[UIImageView alloc] initWithImage:image];
			});
			HUD.customView = imageView;
			HUD.mode = MBProgressHUDModeCustomView;
			HUD.labelText = @"注册成功";
			sleep(1);
            
			[self dismissViewControllerAnimated:YES completion: ^{
			    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//			    [ud setURL:nil forKey:@"profileImage"]; //清空头像 取消授权
			    if (!userID) {
			        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
			        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
			        [ShareSDK cancelAuthWithType:ShareTypeTencentWeibo];
				}
                [ud setBool:NO forKey:@"notFirstLaunch"];
			    [ud setObject:response forKey:@"UserLoadID"];
			    NSString *string = [NSString stringWithString:zhanghao];
			    [ud setObject:string forKey:@"userName"];
			    [ud setObject:[NSString stringWithString:nicheng] forKey:@"nickname"];
			    NSString *string2 = [NSString stringWithString:password];
			    [ud setObject:string2 forKey:@"userPasswd"];
			    [ud synchronize];
                
			    NSArray *saveAy = @[string, string2];
			    DLog(@"关闭注册页面------回调"); //这里打个断点，点击按钮模态视图移除后会回到这里
			    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSetting" object:saveAy]; //发送消息给root
			}];
		}
		else if ([response isEqualToString:@"b"]) {
			MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
			[self.view addSubview:hud];
			hud.dimBackground = YES;
			hud.mode = MBProgressHUDModeText;
			hud.labelText = @"帐号已存在!";
			hud.labelFont = [UIFont fontWithName:@"Arial" size:18];
			//显示对话框
			[hud showAnimated:YES whileExecutingBlock: ^{
			    //对话框显示时需要执行的操作
			    sleep(1);
			} completionBlock: ^{
			    [t0 setText:@""];
			    t0.placeholder = inlineArray[0];
			    [hud removeFromSuperview];
			    return;
			}];
		}
		else if ([response isEqualToString:@"c"]) {
			MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
			[self.view addSubview:hud];
			hud.dimBackground = YES;
			hud.mode = MBProgressHUDModeText;
			hud.labelText = @"昵称已存在!";
			hud.labelFont = [UIFont fontWithName:@"Arial" size:18];
			//显示对话框
			[hud showAnimated:YES whileExecutingBlock: ^{
			    //对话框显示时需要执行的操作
			    sleep(1);
			} completionBlock: ^{
			    [t1 setText:@""];
			    t1.placeholder = inlineArray[1];
			    [hud removeFromSuperview];
			    return;
			}];
		}
	}
	else {
		DLog(@"failed:%@", [error localizedDescription]);
		[HUD removeFromSuperview];
		MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
		[self.view addSubview:hud];
		hud.dimBackground = YES;
		hud.mode = MBProgressHUDModeText;
		hud.labelText = @"注册失败!";
		hud.labelFont = [UIFont fontWithName:@"Arial" size:18];
		//显示对话框
		[hud showAnimated:YES whileExecutingBlock: ^{
		    //对话框显示时需要执行的操作
		    sleep(2);
		} completionBlock: ^{
		    [hud removeFromSuperview];
		    return;
		}];
	}
}

#pragma mark- 时时获取文本框中的文字
- (void)textFieldWithText:(UITextField *)textField {
	switch (textField.tag) {
		case 100: zhanghao = textField.text; break;
            
		case 101: nicheng = textField.text; break;
            
		case 102: password = textField.text; break;
            
		case 103: passwd = textField.text; break;
            
		default: break;
	}
}

#pragma mark 弹出显示框
- (void)ShowMBView:(NSString *)word Location:(int)Index {
	UITextField *t = (UITextField *)[self.view viewWithTag:Index];
	MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
	[self.view addSubview:hud];
	hud.dimBackground = YES;
	hud.mode = MBProgressHUDModeText;
	hud.labelText = word;
	hud.labelFont = [UIFont fontWithName:@"Arial" size:18];
	//显示对话框
	[hud showAnimated:YES whileExecutingBlock: ^{
	    //对话框显示时需要执行的操作
	    sleep(1.5);
	} completionBlock: ^{
	    //操作执行完后取消对话框
	    if (Index == 102) {
	        UITextField *t2 = (UITextField *)[self.view viewWithTag:103];
	        t2.text = @"";
	        t2.placeholder = inlineArray[3];
		}
	    else if (Index == 103) {
	        UITextField *t2 = (UITextField *)[self.view viewWithTag:102];
	        t2.text = @"";
	        t2.placeholder = inlineArray[2];
            
	        t.text = @"";
	        t.placeholder = inlineArray[Index - 100];
		}
	    else {
	        if (Index != 0) {
	            t.text = @"";
	            t.placeholder = inlineArray[Index - 100];
			}
		}
	    [hud removeFromSuperview];
	}];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

/**
 *    内存警告
 */
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
