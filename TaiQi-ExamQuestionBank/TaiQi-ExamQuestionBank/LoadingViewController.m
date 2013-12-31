//
//  RegisterViewController.m
//  TaiQi
//
//  Created by cui wang on 13-5-6.
//
//

#import "LoadingViewController.h"
#import "ResignsetrViewController.h"
#import "HomeViewController.h"


@interface LoadingViewController ()

@end

@implementation LoadingViewController

@synthesize regex;  //用户名正则
@synthesize regex2; //密码正则
@synthesize PassValueDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.worldArray = @[@"账号 :",@"密码 :"];
        regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
        regex2 = @"^[a-zA-Z0-9]{6,16}$";
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    //--------保存设置 消息接收
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reRoadTableView:)
                                                name:@"saveSetting"//消息名
                                              object:nil];//注意是nil
    //--------table配置
    self.tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0.0, 190, self.view.width, 270) style:UITableViewStyleGrouped];
    _tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView =nil;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //--------加载table到view
    //    [self.view addSubview:bgView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"denglu2.png"]];
    [self.view addSubview:_tableView];
}

- (void) reRoadTableView:(NSNotification*) notification
{
    NSArray *saveSettingArray = [notification object];
    self.name = [saveSettingArray objectAtIndex:0];
    self.phone = [saveSettingArray objectAtIndex:1];
    [self.tableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //--------获取用户名和密码
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.name = [ud objectForKey:@"userName"];
    self.phone = [ud objectForKey:@"userPasswd"];
    [_tableView reloadData];
    
}

#pragma mark - UITableViewDataSource
//--------必须实现下面这个函数才能使得俩按钮可点
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else if(section == 1)
        {
        return 10;
        }
    else {
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

//---------头部视图自定义
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 320, 20)];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"   合作网站登录";
        //        title.textColor = UIColorFromRGB(0x3A3A3A);
        title.font = [UIFont systemFontOfSize:14];
        
        return title;
    }
    return nil;
}
//---------尾部视图自定义

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView*View = [[UIView alloc]initWithFrame:CGRectMake(0, 30,320, 20)];
        UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [regBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
        regBtn.frame = CGRectMake(140, 10,170, 16);
        [regBtn setBackgroundImage:[UIImage imageNamed:@"denglu_6.png"] forState:UIControlStateNormal];
        [View addSubview:regBtn];
        return View;
    }
    return nil;
}

//-----BUTTON 响应
-(void)commit:(id)sender
{
    ResignsetrViewController *RGView = [[ResignsetrViewController alloc]init];
    [RGView setModalTransitionStyle:UIModalTransitionStyleCrossDissolve]; //渐变
    [self presentViewController:RGView animated:YES completion:^{
        NSLog(@"打开注册页面------回调");
    }];
}
//---------cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *CellIdentifier = @"Cell";//由于用了两种界面模式所以两个tag
    static NSString *cellIdentifier = @"cell";
    static NSString *SellIdentifier = @"Sell";
    UITableViewCell *cell ;
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    //---第一个section
    if (section == 0)
        {
        cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        if (cell == nil)
            {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
            }
        
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.textLabel.text = [_worldArray objectAtIndex:row];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        //--------
        CGRect textFieldRect = CGRectMake(40.0, 0.0f, 275.0f, 31.0f);
        theTextField = [[UITextField alloc] initWithFrame:textFieldRect];
        theTextField.backgroundColor = [UIColor clearColor];
        theTextField.textColor = [UIColor blackColor];
        theTextField.textAlignment = 1;
        theTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        theTextField.returnKeyType = UIReturnKeyDone;
        theTextField.clearButtonMode = YES;
        theTextField.tag = row+1;
         theTextField.delegate = self;
        [theTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        
        if (row == 1)
            {
            theTextField.secureTextEntry = YES;
            //        theTextField.keyboardType = UIKeyboardTypePhonePad;
            }
        else
                {
                theTextField.keyboardType = UIKeyboardTypeURL;
                }
       
       //------------
        switch (row)
            {
                case 0:
                {
                if (!self.name) {
                    theTextField.placeholder = @"请输入邮箱地址";
                }
                else
                    {
                    theTextField.text = self.name;
                    }
                [theTextField setValue:[UIColor darkGrayColor]
                            forKeyPath:@"_placeholderLabel.textColor"];
                [theTextField setValue:[UIFont systemFontOfSize:14]
                            forKeyPath:@"_placeholderLabel.font"];
                }break;
                case 1:
                {
                if (!self.phone) {
                    
                    theTextField.placeholder = @"请输入密码";
                }
                else
                    {
                    theTextField.text = self.phone;
                    }
                [theTextField setValue:[UIColor darkGrayColor]
                            forKeyPath:@"_placeholderLabel.textColor"];
                [theTextField setValue:[UIFont systemFontOfSize:14]
                            forKeyPath:@"_placeholderLabel.font"];
                }break;
                //        case 2:theTextField.placeholder = @"6-20位,区分大小写";break;
                default:theTextField.placeholder = @"请再次输入新密码";break;
            }
        cell.accessoryView = theTextField;
        }
    
    else if(section == 1)
        {
        
        cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        }
        //---------------------------
        //  设置图片和大小图标
        //---------------------------
        //  设置辅助图标 '>'
        cell.textLabel.text = @"登  录";
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = UIColorFromRGB(0x2C7CFF);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = 1;
        }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier: SellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *tempView = [[UIView alloc] init];
            [cell setBackgroundView:tempView];
            cell.backgroundColor = [UIColor clearColor];
            //  自定义图片
            UIButton  *imageView1=[[UIButton alloc] initWithFrame:CGRectMake(10, 5, 60, 40)];
            imageView1.tag = 11;
            //  自定义图片
            UIButton  *imageView2=[[UIButton alloc] initWithFrame:CGRectMake(120, 5, 60, 40)];
            imageView2.tag = 12;
            //  自定义图片
            UIButton  *imageView3=[[UIButton alloc] initWithFrame:CGRectMake(230, 5, 60, 40)];
            imageView3.tag = 13;
            
            [cell.contentView addSubview:imageView1];
            [cell.contentView addSubview:imageView2];
            [cell.contentView addSubview:imageView3];
        }
        //---------------------------
        //  设置图片和大小图标
        //---------------------------
        //  设置辅助图标 '>'
        //  设置image图片 setUserInteractionEnabled:YES
        UIButton *imageview11 = (UIButton *)[cell.contentView viewWithTag:11];
        [imageview11 setBackgroundImage:[UIImage imageNamed:@"denglu4.png"] forState:UIControlStateNormal];
        [imageview11 addTarget:self action:@selector(thirdLoad:) forControlEvents:UIControlEventTouchUpInside];
        
        //  设置image图片
        UIButton *imageview12 = (UIButton *)[cell.contentView viewWithTag:12];
        [imageview12 setBackgroundImage:[UIImage imageNamed:@"denglu5.png"] forState:UIControlStateNormal];
        [imageview12 addTarget:self action:@selector(thirdLoad:) forControlEvents:UIControlEventTouchUpInside];
        //  设置image图片
        UIButton *imageview13 = (UIButton *)[cell.contentView viewWithTag:13];
        [imageview13 setBackgroundImage:[UIImage imageNamed:@"denglu1.png"] forState:UIControlStateNormal];
        [imageview13 addTarget:self action:@selector(thirdLoad:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return cell;
    
}

//------第三方登录
-(void)thirdLoad:(id)sender
{
    UIButton *thisBtn = (UIButton *)sender;
    
    switch (thisBtn.tag) {
        case 11:
        {
        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error)
         {
         if (result) {
             NSLog(@"%@",[userInfo uid]);
             NSLog(@"%@",[userInfo nickname]);
             
             NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
             [ud setObject:[userInfo uid] forKey:@"sinaUID"];
             [ud setObject:[userInfo nickname] forKey:@"nickName"];
             [ud synchronize];
             
             NSString *urlSS = [NSString stringWithFormat:@"http://cuiwang.sinaapp.com/thridLoad.php?sinaUID=%@&type=sina",[userInfo uid]];
             if ([[self getDataFromURLUseString:urlSS] isEqualToString:@"0"])
                 {
                 //-----未注册 跳到注册页面
                 ResignsetrViewController *RGView = [[ResignsetrViewController alloc]init];
                 RGView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                 self.PassValueDelegate = RGView;
                 [self presentViewController:RGView animated:YES completion:^{
                     [self.PassValueDelegate passValue:@"sinaUID"];
                     NSLog(@"打开注册页面------回调");
                 }];
                 }
             else
                 {
                 //------已经注册,跳到登录页面
                 HomeViewController *homeView = [[HomeViewController alloc]init];
                 [self presentViewController:homeView animated:YES completion:^{
                     NSLog(@"打开主页页面------回调");
                 }];
                 }
             
             NSLog(@"成功");
         } else {
             NSLog(@"失败");
         }
         }
         ];
        }
            break;
        case 12:
        {
        [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error)
         {
         if (result) {
             NSLog(@"%@",[userInfo uid]);
             NSLog(@"%@",[userInfo nickname]);
             
             NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
             [ud setObject:[userInfo uid] forKey:@"qqUID"];
             [ud setObject:[userInfo nickname] forKey:@"nickName"];
             [ud synchronize];
             
             NSString *urlSS = [NSString stringWithFormat:@"http://cuiwang.sinaapp.com/thridLoad.php?qqUID=%@&type=qq",[userInfo uid]];
             if ([[self getDataFromURLUseString:urlSS] isEqualToString:@"0"])
                 {
                 //-----未注册 跳到注册页面
                 ResignsetrViewController *RGView = [[ResignsetrViewController alloc]init];
                 RGView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                 self.PassValueDelegate = RGView;
                 [self presentViewController:RGView animated:YES completion:^{
                     [self.PassValueDelegate passValue:@"qqUID"];
                     NSLog(@"打开注册页面------回调");
                 }];
                 }
             else
                 {
                 //------已经注册,跳到登录页面
                 HomeViewController *homeView = [[HomeViewController alloc]init];
                 [self presentViewController:homeView animated:YES completion:^{
                     NSLog(@"打开主页页面------回调");
                 }];
                 }
         } else {
             NSLog(@"失败");
         }
         }
         ];
        }
            break;
        case 13:
        {
        [ShareSDK getUserInfoWithType:ShareTypeRenren authOptions:nil result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error)
         {
         if (result) {
             NSLog(@"%@",[userInfo uid]);
             NSLog(@"%@",[userInfo nickname]);
             
             NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
             [ud setObject:[userInfo uid] forKey:@"renrenUID"];
             [ud setObject:[userInfo nickname] forKey:@"nickName"];
             [ud synchronize];
             
             NSString *urlSS = [NSString stringWithFormat:@"http://cuiwang.sinaapp.com/thridLoad.php?renrenUID=%@&type=rr",[userInfo uid]];
             if ([[self getDataFromURLUseString:urlSS] isEqualToString:@"0"])
                 {
                 //-----未注册 跳到注册页面
                 ResignsetrViewController *RGView = [[ResignsetrViewController alloc]init];
                 RGView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                 self.PassValueDelegate = RGView;
                 // [self presentModalViewController:modalView animated:YES];  ios 6 弃用了该方法
                 
                 [self presentViewController:RGView animated:YES completion:^{
                     [self.PassValueDelegate passValue:@"renrenUID"];
                     NSLog(@"打开注册页面------回调");
                 }];
                 }
             else
                 {
                 //------已经注册,跳到登录页面
                 HomeViewController *homeView = [[HomeViewController alloc]init];
                 [self presentViewController:homeView animated:YES completion:^{
                     NSLog(@"打开主页页面------回调");
                 }];
                 }
         } else
             {
             NSLog(@"失败");
             }
         }
         ];
        }
            break;
        default:
            break;
    }
    
}


//--------按下确定键

- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    
    [sender resignFirstResponder];
    //-------正则判断
    if (sender.tag == 1) {
        NSString *email = sender.text;
        [self regexForString:email Regex:regex Word:@"请输入合法的邮箱地址!" localtion:1];
    }else
        {
        NSString *passwd = sender.text;
        [self regexForString:passwd Regex:regex2 Word:@"请输入6-18位数字或字母!" localtion:2];
        }
    return YES;
}
//--------------获取text
- (void)textFieldWithText:(UITextField *)textField
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    switch (textField.tag)
    {
        case 1:
        {
        NSString *string = [NSString stringWithString: textField.text];
        [ud setObject:string forKey:@"userName"];
        self.name = string;
        }
        break;
        case 2:
        {
        NSString *string = [NSString stringWithString: textField.text];
        [ud setObject:string forKey:@"userPasswd"];
        self.phone = string;
        }
        break;
        default:break;
    }
    [ud synchronize];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeViewController *homeView = [[HomeViewController alloc]init];
    [homeView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal]; //翻转
    [self presentViewController:homeView animated:YES completion:^{
        NSLog(@"登录验证程序 打开主页页面------回调");
    }];
    /*
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@  %@",self.name,self.phone);
    if (self.name.length >0 && self.phone.length > 0) {
        
        if (indexPath.section == 1) {
            
            MBProgressHUD *huds = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:huds];
            huds.labelText = @"登录中...";
            
            [huds showAnimated:YES whileExecutingBlock:^{
                [self myTask];
                
            } completionBlock:^{
     
                NSLog(@"%@",loadStat);
                HomeViewController *homeView = [[HomeViewController alloc]init];
                if([loadStat isEqualToString:@"error"])
                    {
                    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
                    [self.view addSubview:hud];
                    hud.dimBackground = YES;
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"连接服务器失败!";
                    hud.labelFont = [UIFont fontWithName:@"Arial" size:18];
                    //显示对话框
                    [hud showAnimated:YES whileExecutingBlock:^{
                        //对话框显示时需要执行的操作
                        sleep(2);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                        return ;
                    }];
                    }
                else   if ([loadStat isEqualToString:@"1"])
                    {
                    [homeView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal]; //翻转
                    [self presentViewController:homeView animated:YES completion:^{
                        NSLog(@"登录验证程序 打开主页页面------回调");
                        [huds removeFromSuperview];
                    }];
                    }
                else if([loadStat isEqualToString:@"0"])
                    {
                    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
                    [self.view addSubview:hud];
                    hud.dimBackground = YES;
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"帐号未注册!";
                    hud.labelFont = [UIFont fontWithName:@"Arial" size:18];
                    //显示对话框
                    [hud showAnimated:YES whileExecutingBlock:^{
                        //对话框显示时需要执行的操作
                        sleep(2);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                    }];
                    }
                
            }];
        }
    }
    else
        {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"用户名或密码不正确!";
        hud.labelFont = [UIFont fontWithName:@"Arial" size:18];
        //显示对话框
        [hud showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(2);
        } completionBlock:^{
            [hud removeFromSuperview];
        }];
        }*/
}

- (void)myTask {
    [self regexForString:self.name Regex:regex Word:@"帐号错误,请核对邮箱地址!" localtion:1];
    [self regexForString:self.phone Regex:regex2 Word:@"请输入6-18位数字或字母!" localtion:2];
    loadStat = [self getDataFromURLUseString:[NSString stringWithFormat:@"http://cuiwang.sinaapp.com/userLoad.php?name=%@&password=%@",self.name,self.phone]] ;
}

@end
