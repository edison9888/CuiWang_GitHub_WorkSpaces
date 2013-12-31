//
//  englishViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-1.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "specialSecondViewController.h"
#import "BaseExamViewController.h"
#import "JSONKit.h"
@interface specialSecondViewController ()

@end

@implementation specialSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithType:(NSString *)type andIndex:(int)index
{
    self = [super init];
    if (self) {
        loadEnglishDB = [[myDB alloc]initWithDBName:@"ExamQuestionBank.db"];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        Fast_isSave = [ud boolForKey:@"SubType_Fast"];
        Special_isSave = [ud boolForKey:@"SubType_Special"];
        Real_isSave = [ud boolForKey:@"SubType_Real"];
        dataArray = [[NSMutableArray alloc]initWithCapacity:15];
        fatherType = type;
        fatherIndex = index;
       
        //------初始化数据  先从Special_Table数据库读取出 包含如英语专项的条目 结果应该是 语法|例句|单词 这种
        
        NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM Special_Table WHERE Special_Type='%@'",fatherType];
        //查询数据
        FMResultSet *rs= [loadEnglishDB findinTable:sqlstring];
        while ([rs next])
            {
            SpTB = [Special_Table new];
            SpTB.Sub_Id    = [NSNumber numberWithInt: [[rs stringForColumn:@"Sub_Id"] intValue]];
            SpTB.Special_Type = [rs stringForColumn:@"Special_Type"];
            SpTB.Special_Content = [rs stringForColumn:@"Special_Content"];
            SpTB.Special_Type_Id = [NSNumber numberWithInt: [[rs stringForColumn:@"Special_Type_Id"] intValue]];
            SpTB.Special_Type_Num =[NSNumber numberWithInt: [[rs stringForColumn:@"Special_Type_Num"] intValue]];
            [dataArray addObject:SpTB];
            }
        
    }
    
    return self;
}
-(void)loadView
{
    [super loadView];
    
    [self.maskBtn setImage:[UIImage imageNamed:@"zhuce_1.png"] forState:UIControlStateNormal];
    [self.maskBtn setImage:[UIImage imageNamed:@"zhuce_2.png"] forState:UIControlStateHighlighted];
    NSLog(@"fatherType == %@",fatherType);
    self.titleLB.text = fatherType;
}
-(void)maskBtnDidClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"关闭英语页面------回调");
        
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSInteger section = [indexPath section];
    
    static NSString  *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *txt = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
        txt.tag = 1;
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(220, 15, 72, 21)];
        img.tag = 2;
        [cell.contentView addSubview:txt];
        [cell.contentView addSubview:img];
        }
    UILabel *thisTxt = (UILabel *)[cell.contentView viewWithTag:1];
    UIImageView *thisImg = (UIImageView *)[cell.contentView viewWithTag:2];
    thisImg.image = [UIImage imageNamed:@"dianji15dao_1.png"];
    thisTxt.text = ((Special_Table *)[dataArray objectAtIndex:indexPath.row]).Special_Content;
    return cell;
}

//------专项智能练习 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    userClickIndex = indexPath.row;
    NSString *urlstring = [NSString stringWithFormat:@"http://tqool.tqedu.com/mobile/randomQuestion.action?id=%@",((Special_Table *)[dataArray objectAtIndex:userClickIndex]).Special_Type_Num];//-----服务器地址
    NSLog(@"专项智能练习 url == %@",urlstring);
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    detailString = ((Special_Table *)[dataArray objectAtIndex:indexPath.row]).Special_Content;//------英语专项下的子类  如语法
    
    NSString *thisString = [NSString stringWithFormat:@"%@-%@",fatherType,detailString];
    NSLog(@"thisString == %@",thisString);
    //-----这里要改
//    [ud setBool:YES forKey:thisString];
    Special_isfirst = [ud boolForKey:thisString];//是否第一次打开
    
    NSLog(@"Special_isfirst? == %@",Special_isfirst?@"YES":@"No");
    
    [self HUDonTheWay:0 andURLString:urlstring andReflash:Special_isfirst];
}
//-------访问服务器方法
-(void)HUDonTheWay:(int )index andURLString:(NSString *)urlString andReflash:(BOOL)flash
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    __block int count;
    netDataArray = [[NSMutableArray alloc]initWithCapacity:15];
    //------如果第一次打开
    if (!flash) {
        
        hud.labelText = @"正在访问服务器";
        [hud showAnimated:YES whileExecutingBlock:^{
            
            NSArray *resultDicts = (NSArray *)[self getDataFromURLUseString:urlString];
            NSArray *resultDict = [resultDicts valueForKey:@"sourceExamQuestionList"] ;//获取题目列表
            //-----------------------------------------------------------------------
            count = [resultDict count];
            NSLog(@"index == %d  返回 %d 条数据",index,count);
            for (int i = 0; i<count; i++)
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
                                     fatherType,
                                     detailString,
                                     [[resultDict objectAtIndex:i] objectForKey:@"seqTitle"],
                                     [tmpMutArr objectAtIndex:0],
                                     [tmpMutArr objectAtIndex:1],
                                     [tmpMutArr objectAtIndex:2],
                                     [tmpMutArr objectAtIndex:3],
                                     [[resultDict objectAtIndex:i] objectForKey:@"seqAnswer"],
                                     [[resultDict objectAtIndex:i] objectForKey:@"seqExplain"]];
                
                [netDataArray addObject:CONTENT];
                }
        } completionBlock:^{
            [hud removeFromSuperview];
            if ( count != 0) //如果有返回的题目
                {
                //------更新题目 删除题目 再插入
                [loadEnglishDB deleteTableValue:@"SubType_Special"
                                          Where:@"Sub_Type"
                                             IS:[NSString stringWithFormat:@"\'%@\'",fatherType]
                                            And:YES
                                         Where2:@"Sub_Name"
                                            IS2:[NSString stringWithFormat:@"\'%@\'",detailString]];
                //--------清除历史记录
                [loadEnglishDB deleteTableValue:@"History_Space"
                                          Where:@"History_Type"
                                             IS:[NSString stringWithFormat:@"\'%@\'",fatherType]
                                            And:YES
                                         Where2:@"History_Name"
                                            IS2:[NSString stringWithFormat:@"\'%@\'",detailString]];
                //--------清除错题空间
                [loadEnglishDB deleteTableValue:@"Wrong_Space"
                                          Where:@"Wrong_Type"
                                             IS:[NSString stringWithFormat:@"\'%@\'",fatherType]
                                            And:YES
                                         Where2:@"Wrong_Name"
                                            IS2:[NSString stringWithFormat:@"\'%@\'",detailString]];
                
                
                for (NSArray *CONTENT in netDataArray)
                    {
                    [loadEnglishDB insertTable:@"SubType_Special" Where:@"Sub_Type,Sub_Name,Sub_Title,Sub_A,Sub_B,Sub_C,Sub_D,Sub_Right,Sub_Analyse" Values:CONTENT Num:@"?,?,?,?,?,?,?,?,?"];
                    }
                //----------最多显示15道题 最少1道题
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                if (count >= 15) {
                    [ud setInteger:15 forKey:@"uNum"];
                    [ud synchronize];
                }
                else {
                    [ud setInteger:count forKey:@"uNum"];
                    [ud synchronize];
                }
                //----------下载完后 弹出对话框
                [self showAlertView];
                }
            else
                {
                NSLog(@"获取到空数据");
                [[CommClass sharedInstance] showMBdailog:@"获取不到数据,请联系管理员" inView:self.view];
                }
        }];
    }
    else
        {
        [self showAlertView];
        }
}
#pragma mark -
#pragma mark 弹出对话框
-(void)showAlertView
{
    alert = [[GRAlertView alloc] initWithTitle:@"您准备好了吗?"
                                       message:@"请选择您的操作"
                                      delegate:self
                             cancelButtonTitle:@"我再看看"
                             otherButtonTitles:@"准备好了",
             nil];
    NSString *tmpStr = [NSString stringWithFormat:@"更新 %@ 题库",detailString];
    [alert addButtonWithTitle:tmpStr];
    alert.style = GRAlertStyleInfo2;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //------准备好了
    if (buttonIndex == 1)
        {
        NSLog(@"%@,%@,%@",Fast_isSave?@"yes":@"no",Special_isSave?@"yes":@"no",Real_isSave?@"yes":@"no");
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
        //如果没有保存进度 就直接进去
        else
            {
            
//            NSString *whereStr = [NSString stringWithFormat:@"\"SubType_Special\" WHERE \"Sub_Type\"=\"%@\" AND \"Sub_Name\"=\"%@\"",fatherType,detailString];
//            int dataNum =  [loadEnglishDB getTableItemCount:whereStr];
//            if (dataNum >= 15) {
//                dataNum = 15;
//            }
//            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//            [ud setInteger:dataNum forKey:@"uNum"];
//            [ud synchronize];
            [self uNumSet];
                BaseExamViewController *kslsView = [[BaseExamViewController alloc]initNeednewData:YES andDataFromwitchTable:@"SubType_Special" selectWith:detailString is:fatherType where:@"Sub_Id"];
                [self presentViewController:kslsView animated:YES completion:^{
                    NSLog(@"打开快速练习------回调 ");
                }];
            }
        
        }
    //------我点错了
    else if(buttonIndex == 0)
        {
        stillnext = NO;
        return;
        }
    //------更新题库
    else
        {
        NSString *urlstring = [NSString stringWithFormat:@"http://tqool.tqedu.com/mobile/randomQuestion.action?id=%@",((Special_Table *)[dataArray objectAtIndex:userClickIndex]).Special_Type_Num];//-----服务器地址
        [self HUDonTheWay:1 andURLString:urlstring andReflash:NO];
        }
}
#pragma mark 设置uNum
-(void)uNumSet
{
    int dataNum;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT COUNT(*)  FROM SubType_Special WHERE Sub_Type=\'%@\' AND Sub_Name=\'%@\'",fatherType,detailString];
    NSLog(@"%@",sqlstr);
    FMResultSet *rs = [loadEnglishDB.DB executeQuery:sqlstr];
    while ([rs next])
        {
        dataNum = [rs intForColumnIndex:0];
        NSLog(@"专项练习数据条数    %d",dataNum);
        }
    if (dataNum >= 15) {
        dataNum = 15;
    }
    [ud setInteger:dataNum forKey:@"uNum"];
    [ud synchronize];
}
//------通过url获取data json
-(NSArray *)getDataFromURLUseString:(NSString *)urlSS
{
    NSURL *url = [NSURL URLWithString:urlSS];
    NSArray *resultDict;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
        {
        NSData *responseData = [request responseData];
        resultDict = [responseData  objectFromJSONData];
        //    NSDictionary *test = [responseData objectFromJSONData];
        //    NSLog(@"%@",[test objectForKey:@"type"]);
        return resultDict;
        }
    return resultDict;
}
@end
