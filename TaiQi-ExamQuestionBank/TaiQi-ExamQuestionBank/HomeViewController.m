//
//  HomeViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-20.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "HomeViewController.h"
#import "BaseExamViewController.h"
#import "specialViewController.h"
#import "realViewController.h"
#import "assessViewController.h"
#import "userHomeViewController.h"
#import "wrongHomeViewController.h"

#import "SubType_Comm.h"
#import "myDB.h"
#import "GRAlertView.h"
#import "CommClass.h"

#define kuaisuzhinengURL @"http://tqool.tqedu.com/mobile/randomQuestion.action"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ud = [NSUserDefaults standardUserDefaults];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zhuye7.png"]];
        
        
//        [[CommClass sharedInstance] doSomeThing]; //单例测试
        
        //        Special_isFirst = [ud boolForKey:@"Special_isFirst"];
        //        Real_isFirst = [ud boolForKey:@"Real_isFirst"];
        //

    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    //-----初始化数据库
    loadDB = [[myDB alloc]initWithDBName:@"ExamQuestionBank.db"];
    Home_isFirstLoad = [ud boolForKey:@"HomeFirst"];
    if (!Home_isFirstLoad)
        {
        [self addPictrue:[UIImage imageNamed:@"zhishi1.png"]];
        [ud setBool:YES forKey:@"HomeFirst"];
        [ud synchronize];
        //------创建表
        [loadDB createTable:@"SubType_Fast" withArguments:@"Sub_Id integer PRIMARY KEY autoincrement,Sub_Type text,Sub_Name text,Sub_Title text,Sub_A text,Sub_B text,Sub_C text,Sub_D text,Sub_Right text,Sub_Analyse text"];
        [loadDB createTable:@"SubType_Special" withArguments:@"Sub_Id integer PRIMARY KEY autoincrement,Sub_Type text,Sub_Name text,Sub_Title text,Sub_A text,Sub_B text,Sub_C text,Sub_D text,Sub_Right text,Sub_Analyse text"];
        [loadDB createTable:@"Special_Table" withArguments:@"Sub_Id integer PRIMARY KEY autoincrement,Special_Type text,Special_Content text,Special_Type_Id int,Special_Type_Num int"];
        [loadDB createTable:@"Real_Table" withArguments:@"Sub_Id integer PRIMARY KEY autoincrement,Real_Type text,Real_Content text,Real_Type_Id int,Real_Type_Num int"];
        [loadDB createTable:@"SubType_Fast_Temp" withArguments:@"Sub_Num integer PRIMARY KEY autoincrement,Sub_Temp_Id int,Sub_Table text,Sub_Mark int,Sub_Choosed int,Sub_Choose_Right text,Sub_Time int"];
        }
    
}
#pragma mark -
#pragma mark 首次启动显示用户指引
-(void)addPictrue:(UIImage *)image{
    [ud setInteger:15 forKey:@"uNum"];
    [ud synchronize];
    self.topImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _topImgV.image = image;
    _topImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
    [_topImgV addGestureRecognizer:singleTap];
    [self.view addSubview:_topImgV];
}
-(void)addPictrue2:(UIImage *)image{
    self.BotImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _BotImgV.image = image;
    
    _BotImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked2:)];
    
    [_BotImgV addGestureRecognizer:singleTap];
    [self.view addSubview:_BotImgV];
}
- (void)UesrClicked:(UIGestureRecognizer *)gestureRecognizer {
    
    [self.topImgV setHidden:YES];
    
    [self addPictrue2:[UIImage imageNamed:@"zhishi2.png"]];
    
}
- (void)UesrClicked2:(UIGestureRecognizer *)gestureRecognizer {
    
    [self.BotImgV setHidden:YES];
    
}
#pragma mark -
#pragma mark 通过url获取data json
-(NSMutableArray *)getDataFromURLUseString:(NSString *)urlSS{
    NSURL *url = [NSURL URLWithString:urlSS];
    NSMutableArray *resultDict;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
        {
        NSData *responseData = [request responseData];
        
        NSMutableArray *resultDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        return resultDict;
        }
    return resultDict;
}
#pragma mark -
#pragma mark 写入数据库
-(BOOL)writeDB:(NSArray *)value index:(int) index{
    //------创建数据库
    switch (index) {
        case 1:
            [loadDB insertTable:@"SubType_Fast" Where:@"Sub_Type,Sub_Name,Sub_Title,Sub_A,Sub_B,Sub_C,Sub_D,Sub_Right,Sub_Analyse" Values:value Num:@"?,?,?,?,?,?,?,?,?"];
            break;
        case 2:
            [loadDB insertTable:@"Special_Table" Where:@"Special_Type,Special_Content,Special_Type_Id,Special_Type_Num" Values:value Num:@"?,?,?,?"];
            break;
        case 3:
            [loadDB insertTable:@"Real_Table" Where:@"Real_Type,Real_Content,Real_Type_Id,Real_Type_Num" Values:value Num:@"?,?,?,?"];
            break;
            
        default:
            break;
    }
    //------增加数据
    //------删除数据
    //     [loadDB deleteTableValue:@"SubType_Fast" Where:@"Name" IS:@"panhao"];
    //     //------更新数据
    //     NSArray *value2 = @[@"panhao",@"cuiwang"];
    //     [loadDB updateTable:@"SubType_Fast" SetName:@"Name" WhereName:@"Name" UserValue:value2];
    //     //查询数据
    //     FMResultSet *rs= [loadDB findinTable:@"SELECT * FROM SubType_Fast"];
    //     while ([rs next])
    //     {
    //     NSLog(@"%@ %@ %@",[rs stringForColumn:@"Sid"],[rs stringForColumn:@"Name"],[rs stringForColumn:@"Age"]);
    //     }
    
    return YES;
}
#pragma mark -
#pragma mark 通过索引 返回数组形式的数据
#pragma mark 1是快速智能练习 2是专项智能练习 3是真题模考练习
-(NSArray *)getDBWithIndex:(int) index andDataArray:(NSString *)urlString{
    NSMutableArray* result = [self getDataFromURLUseString:urlString];
    NSString *retMsg = [result valueForKey:@"msg"];
    NSArray *resultDict = [[NSArray alloc]init];
    
    //    NSDictionary *contentDic = [[resultDict valueForKey:@"sourceExamQuestionList"] valueForKey:@"sourceExamQuestionList"];
    NSLog(@"retMsg == %@",retMsg);
    //------快速智能
    //-----------------------------------------------------------------------
    if (index == 1)//------快速智能
        {
        resultDict = [result valueForKey:@"sourceExamQuestionList"] ;//获取题目列表
         //清除快速智能练习 index == 1 下历史空间和错题控件的记录 操作数据库
        [loadDB deleteTableValue:@"History_Space" Where:@"History_Type" IS:@"\'快速智能练习\'" And:NO Where2:nil IS2:nil];
        [loadDB deleteTableValue:@"Wrong_Space" Where:@"Wrong_Type" IS:@"\'快速智能练习\'" And:NO Where2:nil IS2:nil];
        [loadDB deleteTable:@"SubType_Fast"];
        [loadDB createTable:@"SubType_Fast" withArguments:@"Sub_Id integer PRIMARY KEY autoincrement,Sub_Type text,Sub_Name text,Sub_Title text,Sub_A text,Sub_B text,Sub_C text,Sub_D text,Sub_Right text,Sub_Analyse text"];
        
        int num = [resultDict count];
        if (num >= 15) {
            num = 15;
        }
        [ud setInteger:num forKey:@"uNum"];
        [ud synchronize];
        
        for (int i = 0; i<[resultDict count]; i++)
            {
            NSString *tmp = [[resultDict objectAtIndex:i] objectForKey:@"seqOptions"];
            NSArray *tmpArr =   [tmp componentsSeparatedByString:@"\n"];
            NSMutableArray *tmpMutArr = [[NSMutableArray alloc]initWithArray:tmpArr];
            //--------防止选项少于4个
            if ([tmpArr count] == 1) {
                [tmpMutArr addObject:@""];
                [tmpMutArr addObject:@""];
                [tmpMutArr addObject:@""];
            } else if([tmpArr count] == 2){
                [tmpMutArr addObject:@""];
                [tmpMutArr addObject:@""];
            } else if ([tmpArr count] == 3)
                {
                [tmpMutArr addObject:@""];
                }
            
            NSArray *CONTENT = @[
                                 @"快速智能练习",
                                 [NSString stringWithFormat:@"( %d 道)",num],
                                 [[resultDict objectAtIndex:i] objectForKey:@"seqTitle"],
                                 [tmpMutArr objectAtIndex:0],
                                 [tmpMutArr objectAtIndex:1],
                                 [tmpMutArr objectAtIndex:2],
                                 [tmpMutArr objectAtIndex:3],
                                 [[resultDict objectAtIndex:i] objectForKey:@"seqAnswer"],
                                 [[resultDict objectAtIndex:i] objectForKey:@"seqExplain"]];
            [self writeDB:CONTENT index:1];
            }
        }
    //------专项练习
    //-----------------------------------------------------------------------
    
    else if (index == 2)//------专项智能
        {
        resultDict = [result valueForKey:@"usrStudyMenuList"] ;//获取题目列表
        [loadDB deleteTable:@"Special_Table"];//------每次进入都重写数据库
        [loadDB createTable:@"Special_Table" withArguments:@"Sub_Id integer PRIMARY KEY autoincrement,Special_Type text,Special_Content text,Special_Type_Id int,Special_Type_Num int"];
        for (int i = 0; i<[resultDict count]; i++)
            {
            NSString *urlS = [NSString stringWithFormat:@"http://tqool.tqedu.com/mobile/findSubjectKnow.action?id=%@",[[resultDict objectAtIndex:i] objectForKey:@"usmId"]];
            NSMutableArray* results = [self getDataFromURLUseString:urlS];
            NSArray* resultDicts = [results valueForKey:@"usrStudyMenuList"] ;//获取二级题目列表
            
            for (int j = 0; j < [resultDicts count]; j++) {
                NSArray *special_array = @[
                                           [[resultDict objectAtIndex:i] objectForKey:@"usmName"],
                                           [[resultDicts objectAtIndex:j] objectForKey:@"usmName"],
                                           [[resultDict objectAtIndex:i] objectForKey:@"usmId"],
                                           [[resultDicts objectAtIndex:j] objectForKey:@"usmId"],
                                           ];
                [self writeDB:special_array index:2];
            }
            
            }
        }
    //------真题练习
    //-----------------------------------------------------------------------
    else
        {
        [loadDB deleteTable:@"Real_Table"];//------每次进入都重写数据库
        [loadDB createTable:@"Real_Table" withArguments:@"Sub_Id integer PRIMARY KEY autoincrement,Real_Type text,Special_Content text,Special_Type_Id int,Real_Type_Num int"];
        NSArray *resultDict = [self getDataFromURLUseString:urlString];
        for (int i = 0; i<[resultDict count]; i++)
            {
            NSArray *special_array = @[
                                       [[resultDict objectAtIndex:i] objectForKey:@"type"],//全部|真题|推荐真题 北京  卷子名字 卷子ID
                                       [[resultDict objectAtIndex:i] objectForKey:@"knows"],//
                                       [[resultDict objectAtIndex:i] objectForKey:@"SId"],
                                       [[resultDict objectAtIndex:i] objectForKey:@"id"]
                                       ];
            [self writeDB:special_array index:3];
            }
        }
    //-------------初始化完毕
    return resultDict;
}
#pragma mark -
#pragma mark获取到空数据的提示框
-(void)showGetNullData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"获取不到数据,请联系太奇技术部";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3];
}
#pragma mark -
#pragma mark 通过URL下载数据
-(void)HUDonTheWay:(int )index andURLString:(NSString *)urlString andFirst:(BOOL)isFirst andReflash:(BOOL)flash{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
    __block NSArray *resultDict;
    //--------快速智能练习 首次点击使用 先下载题库
    if (index == 1 && !isFirst) {
        NSLog(@"首次启动下载题库 快速智能练习");
        hud.labelText = @"首次启动下载题库";
        [hud showAnimated:YES whileExecutingBlock:^{
            resultDict = [self getDBWithIndex:index andDataArray:urlString]; //asi下载数据
            
            if (resultDict.count > 0) {
                [ud setBool:YES forKey:@"Fast_isFirst"]; //设置成不是第一次使用
                [ud synchronize];
            }
        } completionBlock:^{
            
            [hud removeFromSuperview];
            
            //--------弹出对话框
            [self  showAlertView];
        }];
    }
    else {
        //--------专项智能和真题模考 flash永远是true (快速智能练习刷新数据为true)
        if (flash)
            {
            hud.labelText = @"正在访问服务器";
            [hud showAnimated:YES whileExecutingBlock:^{
                resultDict = [self getDBWithIndex:index andDataArray:urlString]; //asi下载数据
            } completionBlock:^{
                [hud removeFromSuperview];
                [self completionWithIndex:index andDataArray:resultDict];
            }];
            }
        //--------如果不是第一次使用 直接提示打开
        else
            {
            [self showAlertView];
            }
    }
    
}
#pragma mark 下载完成后的操作
-( void )completionWithIndex:(int) index andDataArray:(NSArray *)resultDict{
    int count = [resultDict count];
    //------智能练习
    if (index == 1) {
        [self showAlertView];
    }
    //------专项练习
   else if(index == 2)
        {
        //打开专项智能练习
        if (count != 0)
            {
            specialViewController *specialVC = [[specialViewController alloc]init];
            [self presentViewController:specialVC animated:YES completion:^{
                NSLog(@"打开专项智能------回调");
            }];
            }
        else
            {
            [self showGetNullData];
            }
        }
    //------真题练习
    else
        {
        //打开真题模考
        realViewController *realVC = [[realViewController alloc]init];
        [self presentViewController:realVC animated:YES completion:^{
            NSLog(@"打开真题模考------回调");
        }];
        }
}
#pragma mark 弹出对话框
-(void)showAlertView
{
    alert = [[GRAlertView alloc] initWithTitle:@"您准备好了吗?"
                                       message:@"请选择您的操作"
                                      delegate:self
                             cancelButtonTitle:@"我点错了"
                             otherButtonTitles:@"直接练习",
             nil];
    [alert addButtonWithTitle:@"更新题库"];
    alert.style = GRAlertStyleInfo1;
    [alert show];
}
#pragma mark 对话框点击响应
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    Fast_isSave = [ud boolForKey:@"SubType_Fast"];
    Special_isSave = [ud boolForKey:@"SubType_Special"];
    Real_isSave = [ud boolForKey:@"SubType_Real"];
    
    if (buttonIndex == 1)//------直接打开
        {
        if ((Fast_isSave||Special_isSave||Real_isSave)&&!stillnext)
            {
            alert = [[GRAlertView alloc] initWithTitle:@"警告:  继续将丢失进度!"
                                               message:@"您有保存的进度未完成,请在主页中点击[继续上次练习]"
                                              delegate:self
                                     cancelButtonTitle:@"取消退出"
                                     otherButtonTitles:@"仍然继续",
                     nil];
            alert.style = GRAlertStyleInfored;
            stillnext = YES;
            [alert show];
            }
        else
            {
           [self uNumSet];
            BaseExamViewController   *kslsView = [[BaseExamViewController alloc]initNeednewData:YES andDataFromwitchTable:@"SubType_Fast" selectWith:@"" is:@"" where:@"Sub_Id"];
            [self presentViewController:kslsView animated:YES completion:^{
                NSLog(@"打开快速练习------回调");
            }];
            
            }
        }
    else if(buttonIndex == 0)//------我点错了
        {
        stillnext = NO;
        return;
        }
    else//------更新快速智能题库
        {
        Fast_isFirst = [ud boolForKey:@"Fast_isFirst"];
        [self HUDonTheWay:1 andURLString:kuaisuzhinengURL andFirst:Fast_isFirst  andReflash:YES];
        }
}
#pragma mark 设置uNum
-(void)uNumSet
{
    int dataNum;
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT COUNT(*)  FROM %@", @"SubType_Fast"];
    FMResultSet *rs = [loadDB.DB executeQuery:sqlstr];
    while ([rs next])
        {
         dataNum = [rs intForColumnIndex:0];
        }
    if (dataNum >= 15) {
        dataNum = 15;
    }
    [ud setInteger:dataNum forKey:@"uNum"];
    [ud synchronize];
}
#pragma mark 关闭对话框
- (void)closeAlert:(NSTimer*)timer {
    [(UIAlertView*) timer.userInfo  dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma mark -
#pragma mark 点击响应
#pragma mark 快速智能练习点击响应
- (IBAction)ksls_click:(id)sender{
    Fast_isFirst = [ud boolForKey:@"Fast_isFirst"];
    [self HUDonTheWay:1 andURLString:kuaisuzhinengURL andFirst:Fast_isFirst andReflash:NO];
}
#pragma mark 专项智能练习点击响应
- (IBAction)zxzl_click:(id)sender{
    [self HUDonTheWay:2 andURLString:@"http://tqool.tqedu.com/mobile/findSubject.action" andFirst:YES  andReflash:YES];
}
#pragma mark 真题模考练习点击响应
- (IBAction)ztmk_click:(id)sender{
//    [self HUDonTheWay:3 andURLString:@"http://192.168.0.179:9867/tqWord/pad_findType" andFirst:YES andReflash:YES];
}
#pragma mark 能力评估点击响应
- (IBAction)nlpg_click:(id)sender{
    //    assViewController *assessVC = [[assViewController alloc]init];
    assessViewController *assessVC = [[assessViewController alloc]init];
    [self presentViewController:assessVC animated:YES completion:^{
        NSLog(@"打开能力评测------回调");
    }];
}
#pragma mark 继续练习点击响应
- (IBAction)jxlx_click:(id)sender {
    
    Fast_isSave = [ud boolForKey:@"SubType_Fast"];
    Special_isSave = [ud boolForKey:@"SubType_Special"];
    Real_isSave = [ud boolForKey:@"SubType_Real"];
    
    if (Fast_isSave)
        {
        //------这里要改
        BaseExamViewController *kslsView = [[BaseExamViewController alloc]initNeednewData:NO andDataFromwitchTable:@"SubType_Fast" selectWith:@"" is:@"" where:@"Sub_Id"];
        [self presentViewController:kslsView animated:YES completion:^{
            NSLog(@"打开快速练习------回调");
        }];
        }
    else if (Special_isSave)//------只需要table 和 table ID
        {
        BaseExamViewController *kslsView = [[BaseExamViewController alloc]initNeednewData:NO andDataFromwitchTable:@"SubType_Special" selectWith:@"Sub_Id" is:@"Sub_Name" where:@"Sub_Id"];
        [self presentViewController:kslsView animated:YES completion:^{
            NSLog(@"打开快速练习------回调");
        }];
        }
    else if (Real_isSave)
        {
        BaseExamViewController *kslsView = [[BaseExamViewController alloc]initNeednewData:NO andDataFromwitchTable:@"SubType_Real" selectWith:@"Sub_Id" is:@"Sub_Name" where:@"Sub_Id"];
        [self presentViewController:kslsView animated:YES completion:^{
            NSLog(@"打开快速练习------回调");
        }];
        }
    else
        {
        alert = [[GRAlertView alloc] initWithTitle:@"温馨提示"
                                           message:@"您没有保存记录!"
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        alert.style = GRAlertStyleInfo;
        [NSTimer scheduledTimerWithTimeInterval:1.2f target:self selector:@selector(closeAlert:) userInfo:alert repeats:NO];
        [alert show];
        }
}
#pragma mark 考前冲刺点击响应
- (IBAction)kqcc_click:(id)sender {
    
    NSString *message =  @"考前冲刺为付费用户提供由教研专家及名师教授编制的独家密卷及重要考点练习.";
    GRAlertView *alertjxlx = [[GRAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"关闭", nil];
    
    [alertjxlx setTopColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.5]
               middleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.5]
               bottomColor:[UIColor colorWithRed:0.4 green:0 blue:0 alpha:.1]
                 lineColor:[UIColor colorWithRed:0.3 green:0.5 blue:0.7 alpha:1]];
    
    [alertjxlx setFontName:@"Airal"
                 fontColor:[UIColor blackColor]
           fontShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    
    [alertjxlx show];
    
}
#pragma mark 历史记录点击响应
- (IBAction)lsjl_click:(id)sender {
    wrongHomeViewController *wrongVC = [[wrongHomeViewController alloc]init];
    [wrongVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:wrongVC animated:YES completion:^{
        NSLog(@"打开错题中心------回调");
    }];
}
#pragma mark 用户中心点击响应
- (IBAction)yhzx_click:(id)sender{
    userHomeViewController *userVC = [[userHomeViewController alloc]init];
    [userVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:userVC animated:YES completion:^{
        NSLog(@"打开用户中心------回调");
    }];
    
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}
#pragma mark -
#pragma mark 视图卸载
- (void)viewDidUnload {
    [super viewDidUnload];
    [loadDB close]; //关闭数据库
}

@end
