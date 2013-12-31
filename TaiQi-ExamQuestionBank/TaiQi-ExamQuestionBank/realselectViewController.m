//
//  realselectViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-1.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "realselectViewController.h"
#import "BaseExamViewController.h"
#import "Real_Table_QBZT.h"
#import "JSONKit.h"

@interface realselectViewController ()

@end

@implementation realselectViewController


-(id)initWithFatherType:(NSString *)type andContent:(NSString *)content
{
    self = [super init];
    if (self) {
        loadRealSelectDB = [[myDB alloc]initWithDBName:@"ExamQuestionBank.db"];
        
        realDataArray = [[NSMutableArray alloc]initWithCapacity:15];
        fatherType = type; //------QBZT
        fatherContent = content;//------上海
        //------读取配置信息 是否保存进度
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        Exam_isSave = [ud boolForKey:@"SubType_Fast"];
        Special_isSave = [ud boolForKey:@"SubType_Special"];
        Real_isSave = [ud boolForKey:@"SubType_Real"];
        
        NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM Real_Table WHERE Real_Type='%@' AND Real_Content = '%@'",fatherType,fatherContent];
        //查询数据
        FMResultSet *rs= [loadRealSelectDB findinTable:sqlstring];
        while ([rs next])
            {
            Real_Table_QBZT *quzt = [Real_Table_QBZT new];
            
            quzt.Real_Type = [rs stringForColumn:@"Real_Type"];
            quzt.Real_Content = [rs stringForColumn:@"Real_Content"];
            quzt.Real_Total = [NSNumber numberWithInt: [[rs stringForColumn:@"Real_Total"] intValue]];
            quzt.Real_Detail =[rs stringForColumn:@"Real_Detail"];
            quzt.Real_Detail_Num =[NSNumber numberWithInt: [[rs stringForColumn:@"Real_Detail_Num"] intValue]];
            [realDataArray addObject:quzt];
            }
    }
    
    return self;
}
-(void)loadView
{
    [super loadView];
    [self.maskBtn setImage:[UIImage imageNamed:@"zhuce_1.png"] forState:UIControlStateNormal];
    [self.maskBtn setImage:[UIImage imageNamed:@"zhuce_2.png"] forState:UIControlStateHighlighted];
    self.titleLB.text = fatherContent;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [realDataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    //    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    Real_Table_QBZT *qbzt1 = [Real_Table_QBZT new];
    qbzt1 = [realDataArray objectAtIndex:row];
    static NSString  *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *txt = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 250, 30)];
        txt.tag = 1;
        [cell.contentView addSubview:txt];
        }
   
    UILabel *thisTxt = (UILabel *)[cell.contentView viewWithTag:1];
    
            thisTxt.text = qbzt1.Real_Detail;
              
    //cell.textLabel.text = [_worldArray objectAtIndex:section];
    //cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    ExamViewController *exam = [[ExamViewController alloc]init];
    //    [self presentViewController:exam animated:YES completion:^{
    //        NSLog(@"打开习题页面------回调");
    //    }];
    NSString *urlstring = [NSString stringWithFormat:@"http://192.168.0.179:9867/tqWord/pad_userTest"];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    Real_Table_QBZT *qbzt = [Real_Table_QBZT new];
    qbzt = [realDataArray objectAtIndex:indexPath.row];
    value_zt = qbzt.Real_Detail;//------2013年北京市MBA真题
    //--------------
    //这里要改回来 (!)
    //--------------
    [ud setBool:YES forKey:value_zt];
    Real_isfirst = [ud boolForKey:value_zt];
    
    [self HUDonTheWay:indexPath.row andURLString:urlstring andReflash:!Real_isfirst];
    
}
-(void)HUDonTheWay:(int )index andURLString:(NSString *)urlString andReflash:(BOOL)flash
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    __block NSArray *resultDicts;//json解析后的数组
    netDataArray = [[NSMutableArray alloc]initWithCapacity:15];
    //------如果刷新 就重建表
    //    [loadEnglishDB deleteTable:@"SubType_Special"];
    [loadRealSelectDB createTable:@"SubType_Real" withArguments:@"Sub_Id integer PRIMARY KEY autoincrement,Sub_Type text,Sub_Name text,Sub_Title text,Sub_A text,Sub_B text,Sub_C text,Sub_D text,Sub_Right text,Sub_Analyse text"];
    //------
    if (!Real_isfirst||flash) {
        
        
        hud.labelText = @"正在访问服务器";
        [hud showAnimated:YES whileExecutingBlock:^{
            
            //        [loadEnglishDB deleteTable:@"SubType_Special"];
            //        [loadEnglishDB createTable:@"SubType_Special" withArguments:@"Special_Id integer PRIMARY KEY autoincrement,Sub_Name text,Sub_Title text,Sub_A text,Sub_B text,Sub_C text,Sub_D text,Sub_Right text,Sub_Analyse text"];
            
            resultDicts = (NSArray *)[self getDataFromURLUseString:urlString];
            //-----------------------------------------------------------------------
            NSLog(@"返回 %d 条数据",[resultDicts count]);
            for (int i = 0; i<[resultDicts count]; i++)
                {
                NSArray *CONTENT = @[
                                     [[resultDicts objectAtIndex:i] objectForKey:@"subType"] ,
                                     [[resultDicts objectAtIndex:i] objectForKey:@"subName"] ,
                                     [[resultDicts objectAtIndex:i] objectForKey:@"subTitle"],
                                     [[resultDicts objectAtIndex:i] objectForKey:@"subA"],
                                     [[resultDicts objectAtIndex:i] objectForKey:@"subB"],
                                     [[resultDicts objectAtIndex:i] objectForKey:@"subC"],
                                     [[resultDicts objectAtIndex:i] objectForKey:@"subD"],
                                     [[resultDicts objectAtIndex:i] objectForKey:@"subRight"],
                                     [[resultDicts objectAtIndex:i] objectForKey:@"subAnalyse"]];
                
                [netDataArray addObject:CONTENT];
                }
            //------更新题目
            
            //-----先删除后插入
            [loadRealSelectDB deleteTableValue:@"SubType_Real" Where:@"Sub_Name" IS:[[netDataArray objectAtIndex:0] objectAtIndex:0] And:NO Where2:nil IS2:nil];
            for (NSArray *CONTENT in netDataArray)
                {
                [loadRealSelectDB insertTable:@"SubType_Real" Where:@"Sub_Type,Sub_Name,Sub_Title,Sub_A,Sub_B,Sub_C,Sub_D,Sub_Right,Sub_Analyse" Values:CONTENT Num:@"?,?,?,?,?,?,?,?,?"];
                }
            //-----------------------------------------------------------------------
        } completionBlock:^{
            [hud removeFromSuperview];
            if ( [resultDicts count] != 0)
                {
                BaseExamViewController *kslsView = [[BaseExamViewController alloc]initNeednewData:YES andDataFromwitchTable:@"SubType_Real" selectWith:value_zt is:@"真题" where:@"Sub_Id"];
                [self presentViewController:kslsView animated:YES completion:^{
                    NSLog(@"打开快速练习------回调");
                }];
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
        alert = [[GRAlertView alloc] initWithTitle:@"您准备好了吗?"
                                           message:@"请选择您的操作"
                                          delegate:self
                                 cancelButtonTitle:@"我点错了"
                                 otherButtonTitles:@"开始练习",
                 nil];
        alert.style = GRAlertStyleInfo2;
        [alert show];
        }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)//------直接打开
        {
        if ((Exam_isSave||Special_isSave||Real_isSave)&&!stillnext)
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
            {//如果没有保存进度 就直接进去 不需要刷新 NO
                
                
                
                BaseExamViewController *kslsView = [[BaseExamViewController alloc]initNeednewData:YES andDataFromwitchTable:@"SubType_Real" selectWith:value_zt is:@"真题" where:@"Sub_Id"];
                
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
