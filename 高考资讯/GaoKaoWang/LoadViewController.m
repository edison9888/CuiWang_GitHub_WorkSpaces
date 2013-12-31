//
//  LoadViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-27.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "LoadViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "SelectItemsViewController.h"
#import "GCDiscreetNotificationView.h"

#define isNetOk [CW_Tools checkNetworkConnection]

@interface LoadViewController ()

@end

@implementation LoadViewController
@synthesize PassValueDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        nameArray = @[@"帐号",@"密码"];
        inlineArray = @[@"邮箱 手机号码",@"****************"];
        thirdTypeArray = @[@"sn",@"qq",@"wb"];
        titleArray = [[NSMutableArray alloc]initWithCapacity:10];
        titleDictionary = [[NSMutableDictionary alloc]initWithCapacity:10];
        
        ud = [NSUserDefaults standardUserDefaults];
        name = [ud stringForKey:@"userName"];
        password = [ud stringForKey:@"userPasswd"];
        [ud setBool:NO forKey:@"UserIsLoaded"];
        [ud synchronize];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveSetting:) name:@"saveSetting" object:nil];//发送消息给root
    }
    return self;
}
#pragma mark 注册完 通知保存用户名和密码
-(void)saveSetting:(NSNotification *)notification
{
    [self reflashProfileImage];
    NSArray *saveSettingArray = [notification object];
    name = [saveSettingArray objectAtIndex:0];
    password = [saveSettingArray objectAtIndex:1];
    [self.myTableView reloadData];
}




#pragma mark -视图已加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    [self reflashProfileImage];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"biankuang.png"]];
}
#pragma mrak 获取栏目列表
-(void)getDataFromURL
{
    NSURL *url = [NSURL URLWithString:@"http://www.gkk12.com/index.php?m=content&c=khdindex&a=gkkhdmenu"];
     ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSData *data = [request responseData];
        NSDictionary *titlerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        [titleArray removeAllObjects];//清空
        for (NSDictionary *dic in titlerDic) {
            NSDictionary *thisDic = @{@"catid": [dic objectForKey:@"catid"],@"catname":[dic objectForKey:@"catname"]};
            [titleArray addObject:thisDic];
        }
        [ud setObject:titleArray forKey:@"titleArray"];
        [ud synchronize];
    }
}
#pragma mark 直接登录
-(void)addDataForJustLoad:(NSArray *)titleArrayTmp
{
    NSMutableArray *upArray = [[NSMutableArray alloc]initWithCapacity:10];
    NSDictionary *thisDic = @{@"catid": [titleArrayTmp[0] objectForKey:@"catid"],@"catname":[titleArrayTmp[0] objectForKey:@"catname"]};
    NSDictionary *thisDic2 = @{@"catid": [titleArrayTmp[1] objectForKey:@"catid"],@"catname":[titleArrayTmp[1] objectForKey:@"catname"]};
    [upArray addObject:thisDic];
    [upArray addObject:thisDic2];
    [ud setObject:upArray forKey:@"titleArray"];
    [ud synchronize];
}
- (IBAction)JustLoadClick:(id)sender {
  
    
       BOOL first = [ud boolForKey:@"HomeViewLoaded"];//是否进入过主页
    
       if (!first ) {//没有进入过 就先下载栏目
           //--------如果第一次进 而且没有网络 就直接返回
           if (!isNetOk) {
               [CW_Tools ToastViewInView:self.view withText:@"没有网络!"];
               return;
           } else {
               [self getDataFromURL];
           }
       }
    
       NSMutableArray *titleArrayTmp = [ud objectForKey:@"titleArray"];
    
       if (titleArrayTmp.count > 0)//如果栏目数量不为空
           {
           if (!first)//如果第一次进入 就只加载两个固定栏目
               {
               [self addDataForJustLoad:titleArrayTmp];
               }
           [ud setBool:NO forKey:@"UserIsLoaded"];
           [ud synchronize];
           //------打开页面
           
#if NS_BLOCKS_AVAILABLE
           MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
           [self.navigationController.view addSubview:hud];
           hud.labelText = @"直接进入...";
           __block subMMDrawerController * JustDrawerController;
           [hud showAnimated:YES whileExecutingBlock:^{
               AppDelegate *app = [[UIApplication sharedApplication] delegate];
               JustDrawerController = [app loadMainVC];
                [self.navigationController pushViewController:JustDrawerController animated:YES];
           } completionBlock:^{
               [hud removeFromSuperview];
               
           }];
#endif
          
           } else {
               [CW_Tools ToastViewInView:self.view withText:@"获取不到数据,请重试! "];
           }
    
    
}



#pragma mark 登录点击

//--------第一次使用 加载引导页
-(void)isFirstLaunch
{
    BOOL first = [ud boolForKey:@"notFirstLaunch"];
    
    if (!first ) {//没有进入过 就先下载栏目
        [self getDataFromURL];
    }
}

#pragma mark -登录按钮点击
-(void)myLoadClickTask
{
    //--------正则校验
   
    
    BOOL isMobile = [CW_Tools isMobile:name];//是否是手机号码
    BOOL isEmail   = [CW_Tools isEmail:name];//是否是email
    BOOL isPassword = [CW_Tools isPassword:password];//是否是密码
    
    if ( isMobile || isEmail )//帐号合法
        {
        if (isPassword)//密码也合法
            {
            //--------是否第一次使用
            [self isFirstLaunch];
            NSString * response =  [self myLoginMixedTask];//登录 与服务器交互 返回是否有数据
            
            [self performSelectorOnMainThread:@selector(CompletionDownload:) withObject:response waitUntilDone:NO];
            
            
            } else {//输入的不是有效密码
                [self ShowMBView:@"密码输入有误!" Location:101];
            }
        }
    else {//输入的不是有效帐号
        [self ShowMBView:@"帐号输入有误!" Location:100];
    }
    
    
}
/**
 *    主线程中操作
 *
 *    @param response 返回的数据
 */
-(void)CompletionDownload:(NSString *)response
{
    [self myCompletionBlockWithData:response  TXT:@"连接服务器失败! "];
}

- (IBAction)LoadClick:(id)sender {
    
    if (!isNetOk) {
        [CW_Tools ToastViewInView:self.view withText:@"网络不存在!"];
        return;
    }
    
    //--------提示框
#if NS_BLOCKS_AVAILABLE
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:hud];
	hud.labelText = @"登录中...";
	
	[hud showAnimated:YES whileExecutingBlock:^{
        [self myLoadClickTask];
	} completionBlock:^{
		[hud removeFromSuperview];
	}];
#endif
   
}
#pragma mark 注册按钮点击
- (IBAction)RegisterClick:(id)sender {
    
    if (!isNetOk) {
        [CW_Tools ToastViewInView:self.view withText:@"网络不存在!"];
        return;
    }
    
    RegisterViewController *registerVC = [RegisterViewController new];
    [self presentViewController:registerVC animated:YES completion:^{
        //        <#code#>
    }];
}

#pragma mark 服务器交互完毕后的操作
//response 服务器返回的数据 hud 显示在哪的hud text response=0时显示的txt
-(void)myCompletionBlockWithData:(NSString *)response TXT:(NSString *)text
{
    //---------提取栏目列表
    NSMutableArray *titleArrayTmp = [ud objectForKey:@"titleArray"];
    
    
    if (![response isEqualToString:@"0"])//获取到的数据为1
        {
        if (titleArrayTmp.count > 0)//栏目列表不为空
            {
            
            if (![ud boolForKey:@"notFirstLaunch"])//是第一次登录使用 进入选择栏目页面
                {
                SelectItemsViewController *selectVC = [SelectItemsViewController new];
                
                [ud setBool:YES forKey:@"notFirstLaunch"];
                [ud synchronize];
                isThirdLoading = NO;
                
                
                
                [self.navigationController pushViewController:selectVC animated:YES];
                }   else//不是第一次登录使用 直接进入主页
                    {
                    //-------打开主页
                    AppDelegate *app = [[UIApplication sharedApplication] delegate];
                    DrawerController = [app loadMainVC];
                    
                    [ud setBool:YES forKey:@"UserIsLoaded"];
                    [ud synchronize];
                    isThirdLoading = NO;
                    
                    [self.navigationController pushViewController:DrawerController animated:YES];
                    
                    }
            } else {//栏目列表为空
                [CW_Tools ToastViewInView:self.view withText:@"获取不到数据,请重试! "];
                isThirdLoading = NO;
            }
        
        }
    else {//获取到的数据为0 并且text长度为 qq wb sn 等两位 就打开注册页面 注册 否则提示异常
         isThirdLoading = NO;
            if (text.length == 2) {
                RegisterViewController *registerVC = [RegisterViewController new];
                self.PassValueDelegate = registerVC;
                [self.PassValueDelegate passValue:text];
                [self presentViewController:registerVC animated:YES completion:^{
                }];
            } else {
                [CW_Tools ToastViewInView:self.view withText:text];
            }
        }
}

#pragma mark 第三方登录
- (IBAction)thirdButtonClick:(id)sender {
    
    
    if (!isNetOk) {
        [CW_Tools ToastViewInView:self.view withText:@"网络不存在!"];
        return;
    }
    
    UIButton *thirdBtn = (UIButton *)sender;
    
    NSString *typeStr;
    ShareType shareType;
    
    int BtnTag = thirdBtn.tag;
    switch (BtnTag) {
        case 101:
            typeStr = thirdTypeArray[0];
            shareType = ShareTypeSinaWeibo;
            break;
        case 102:
            typeStr = thirdTypeArray[1];
            shareType = ShareTypeQQSpace;
            break;
        case 103:
            typeStr = thirdTypeArray[2];
             shareType = ShareTypeTencentWeibo;
            break;
        default:
            shareType = ShareTypeQQ;
            break;
    }
    
    if (!isThirdLoading) {
        isThirdLoading = YES;
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"登录中...";
        [HUD show:YES];
        
        [ShareSDK cancelAuthWithType:shareType];
        [ShareSDK getUserInfoWithType:shareType authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
         {
         if (result) {
             
             [ud setURL:[NSURL URLWithString:[userInfo profileImage]] forKey:@"profileImage"];
             [ud setObject:[userInfo nickname] forKey:@"nickname"];
             [ud setObject:[userInfo uid] forKey:[NSString stringWithFormat:@"%@UID",typeStr]];
             [ud synchronize];
             
             [self thirdLoadTaskUserID:[ud stringForKey:@"UserLoadID"] Type:typeStr UID:[userInfo uid]];
             
         }
         
         }];
        
        isThirdLoading = NO;
        [HUD hide:YES];
    }
}

-(void)thirdLoadTaskUserID:(NSString *)userID Type:(NSString *)type UID:(NSString *)uid
{
    [self isFirstLaunch];//是否第一次使用
    [self reflashProfileImage];//更新头像
    //Type 必须只有2个字
    NSString *urlStr = [NSString stringWithFormat:@"http://27.112.1.16/padapi/loginapifrom.php?userid=%@&logintype=%@&loginconnid=%@",userID?userID:@"0",type,uid];
    
    DLog(@"第三方登录 urlStr == %@",urlStr);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString* response = [request responseString];
        DLog(@"第三方登录 str == %@",[request responseString]);
        [self myCompletionBlockWithData:response  TXT:type];
    } else {
        [CW_Tools ToastViewInView:self.view withText:@"连接服务器失败! "];
        isThirdLoading = NO;
        DLog(@"failed:%@", [error localizedDescription]);
    }
}

#pragma mark 刷新头像
-(void)reflashProfileImage
{
//    self.profileImage.layer.cornerRadius = 10;
//    self.profileImage.layer.masksToBounds = YES;
    [self.profileImage setImageWithURL:[ud URLForKey:@"profileImage"]
            placeholderImage:[UIImage imageNamed:@"queen.png"]];
}
#pragma mark-
#pragma mark tableview 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
    return 1;
 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 200, 34)] ;
        textField.backgroundColor = [UIColor clearColor];
        textField.returnKeyType = UIReturnKeyNext;
        textField.borderStyle = UITextBorderStyleNone;
        textField.textAlignment = 1;
        textField.tag = indexPath.row+100;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        if (indexPath.row == 1) {
            textField.secureTextEntry = YES; //密码
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:textField];
    }
    
    UITextField *myTF = (UITextField *)[cell.contentView viewWithTag:indexPath.row+100];
    cell.textLabel.text = [nameArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        if (!name) {
            myTF.placeholder = [inlineArray objectAtIndex:indexPath.row];
        }else {
            myTF.text = name;
        }
    } else {
        if (!password) {
            myTF.placeholder = [inlineArray objectAtIndex:indexPath.row];
        }else {
            myTF.text = password;
        }
    }
    
    return cell;
}
#pragma mark -
#pragma mark 登录与服务器交互
-(NSString *)myLoginMixedTask
{
    NSString *surl = @"http://27.112.1.16/padapi/loginapi.php";
    NSURL *url = [NSURL URLWithString:surl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:name forKey:@"loginname"];
    [request setPostValue:password forKey:@"loginpwd"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
        {
        NSString *response = [request responseString];
        DLog(@"登录返回 State: == %@",response);
        [ud setObject:response forKey:@"UserLoadID"];
        [ud synchronize];
        return response;
        }
    else {
        return @"0";
    }
    
}
#pragma mark- 时时获取文本框中的文字
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 100: name = textField.text;break;
        case 101: password = textField.text;break;
        default:break;
    }
}
#pragma mark 弹出显示框
-(void)ShowMBView:(NSString *)word Location:(int) Index
{
    UITextField *t = (UITextField*)[self.view viewWithTag:Index];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.dimBackground = YES;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = word;
    hud.labelFont = [UIFont fontWithName:@"Arial" size:18];
    //显示对话框
    [hud showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(1.5);
    } completionBlock:^{
        //操作执行完后取消对话框
        t.text = @"";
        t.placeholder = inlineArray[Index-100];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
