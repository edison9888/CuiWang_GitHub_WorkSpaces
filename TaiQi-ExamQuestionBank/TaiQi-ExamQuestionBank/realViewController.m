//
//  realViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-1.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "realViewController.h"
#import "realselectViewController.h"
#import "Real_Table_QBZT.h"
#import "Real_Table_TJZT.h"
#import "JSONKit.h"
#import "BaseExamViewController.h"
#import <AGCommon/UIView+Common.h>
@interface realViewController ()

@end

@implementation realViewController
@synthesize leftBtn;
@synthesize rightBtn;
@synthesize listOfMovies;
@synthesize  retableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        realnameArray = [[NSMutableArray alloc]initWithCapacity:15];
        realtypeArray = [[NSMutableArray alloc]initWithCapacity:15];
        
        TJrealnameArray = [[NSMutableArray alloc]initWithCapacity:15];
        TJrealtypeArray = [[NSMutableArray alloc]initWithCapacity:15];
        
        //------读取配置信息 是否保存进度
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        Exam_isSave = [ud boolForKey:@"SubType_Fast"];
        Special_isSave = [ud boolForKey:@"SubType_Special"];
        Real_isSave = [ud boolForKey:@"SubType_Real"];
        
        loadRealDB = [[myDB alloc]initWithDBName:@"ExamQuestionBank.db"];
        
        NSString *sqlstring_qb = [NSString stringWithFormat:@"SELECT * FROM Real_Table WHERE Real_Type = 'QBZT'"];
        NSString *sqlstring_tj = [NSString stringWithFormat:@"SELECT * FROM Real_Table WHERE Real_Type = 'TJZT'"];
        //查询数据
        FMResultSet *rs= [loadRealDB findinTable:sqlstring_qb];
         FMResultSet *rs_tj= [loadRealDB findinTable:sqlstring_tj];
        
        while ([rs_tj next])
            {
            Real_Table_TJZT *tjzt = [Real_Table_TJZT new];
            
            tjzt.Real_Type = [rs stringForColumn:@"Real_Type"];
            tjzt.Real_Content = [rs stringForColumn:@"Real_Content"];
            tjzt.Real_Total = [NSNumber numberWithInt: [[rs stringForColumn:@"Real_Total"] intValue]];
            tjzt.Real_Detail =[rs stringForColumn:@"Real_Detail"];
            tjzt.Real_Detail_Num =[NSNumber numberWithInt: [[rs stringForColumn:@"Real_Detail_Num"] intValue]];
            [TJrealnameArray addObject:tjzt];
            [TJrealtypeArray addObject:[rs_tj stringForColumn:@"Real_Detail"]];
            }
        //---------
        while ([rs next])
            {
            Real_Table_QBZT *quzt = [Real_Table_QBZT new];
            
            quzt.Real_Type = [rs stringForColumn:@"Real_Type"];
            quzt.Real_Content = [rs stringForColumn:@"Real_Content"];
            quzt.Real_Total = [NSNumber numberWithInt: [[rs stringForColumn:@"Real_Total"] intValue]];
            quzt.Real_Detail =[rs stringForColumn:@"Real_Detail"];
            quzt.Real_Detail_Num =[NSNumber numberWithInt: [[rs stringForColumn:@"Real_Detail_Num"] intValue]];
            [realnameArray addObject:quzt];
            [realtypeArray addObject:[rs stringForColumn:@"Real_Content"]];
            }
        
        NSSet*  typeSet = [NSSet setWithArray:realtypeArray];
        realtypearray =  [typeSet allObjects];
        
        NSSet*  typeSet_tj = [NSSet setWithArray:TJrealtypeArray];
        TJrealtypearray =  [typeSet_tj allObjects];
    }
   
    return self;
}
-(void)loadView
{
    [super loadView];
    [self.titleLB setHidden:YES];
    
    
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(150, 13, 77, 36);
    [leftBtn setImage:[UIImage imageNamed:@"tuijianzhenti1.png"] forState:UIControlStateNormal];
     [leftBtn setImage:[UIImage imageNamed:@"tuijianzhenti2.png"] forState:UIControlStateHighlighted];
    [leftBtn setImage:[UIImage imageNamed:@"tuijianzhenti2.png"] forState:UIControlStateSelected];
     [leftBtn addTarget:self action:@selector(leftBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(232, 13, 77, 36);
    [rightBtn setImage:[UIImage imageNamed:@"quanbuzhenti1.png"] forState:UIControlStateNormal];
     [leftBtn setImage:[UIImage imageNamed:@"quanbuzhenti2.png"] forState:UIControlStateHighlighted];
    [rightBtn setImage:[UIImage imageNamed:@"quanbuzhenti2.png"] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(rightBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setSelected:YES];
    
    
    [self.view addSubview:leftBtn];
    [self.view addSubview:rightBtn];

}
-(void)loadTableView:(UITableView *)thetableView TableViewStyle:(UITableViewStyle )style
{
    self.retableView = thetableView;
    retableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 59.0, self.view.width, self.view.height-59.0) style:UITableViewStylePlain];
    retableView.rowHeight = 40.0;
    //    thetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    retableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    retableView.backgroundColor = [UIColor clearColor];
    retableView.scrollEnabled = YES;
    retableView.backgroundView = nil;
    retableView.dataSource = self;
    retableView.delegate = self;
    [self.view addSubview:retableView];
}
-(void)leftBtnDidClick:(UIButton *)sender
{
    
    if (sender.selected) {
//                sender.selected = NO;
    }
    else
        {
        sender.selected = YES;
        [rightBtn setSelected:NO];
        
         [self.retableView reloadData];
        }
   
    
}
-(void)rightBtnDidClick:(UIButton *)sender
{
    
    if (sender.selected) {
//        sender.selected = NO;
    }
    else
        {
        sender.selected = YES;
        [leftBtn setSelected:NO];
         [self.retableView reloadData];
        }
    
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (rightBtn.isSelected) {
        
        return [realtypearray count];
    }
    else
        {
        return [TJrealtypearray count];
        }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    //    NSInteger section = [indexPath section];
   
    NSInteger row = [indexPath row];
    NSString *value = [realtypearray objectAtIndex:row];
    NSString *value_tj = [TJrealtypearray objectAtIndex:row];
    
    static NSString  *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    UITableViewCell *cell;
    if (cell == nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        //       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.textLabel.textColor = [UIColor colorWithRGB:0x3a3a3a];
        UILabel *txt = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
        txt.tag = 1;
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(220, 15, 52, 19)];
        img.tag = 2;
        [cell.contentView addSubview:txt];
        [cell.contentView addSubview:img];
        }
    //    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    //    backgrdView.backgroundColor = [UIColor blueColor];
    //    cell.backgroundView = backgrdView;
    UILabel *thisTxt = (UILabel *)[cell.contentView viewWithTag:1];
    UIImageView *thisImg = (UIImageView *)[cell.contentView viewWithTag:2];
    
    if (rightBtn.isSelected) {
        [thisImg setHidden:NO] ;
   thisImg.image = [UIImage imageNamed:@"zhenti_1.png"];
    
            thisTxt.text = value;
           
  
     }
    else
        {
        [thisImg setHidden:YES] ;
        thisTxt.font = [UIFont systemFontOfSize:16.0];
        thisTxt.frame = CGRectMake(10, 10, 200, 30);
        thisTxt.text = value_tj;
        }
    //cell.textLabel.text = [_worldArray objectAtIndex:section];
    //cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
    
}
//-----点击响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ExamViewController *exam = [[ExamViewController alloc]init];
//    [self presentViewController:exam animated:YES completion:^{
//        NSLog(@"打开习题页面------回调");
//    }];
    valueString = [TJrealtypearray objectAtIndex:indexPath.row];
    valueCityString = [realtypearray objectAtIndex:indexPath.row];
    
     if (rightBtn.isSelected)
    {
    realselectViewController *realselectVC = [[realselectViewController alloc]initWithFatherType:@"QBZT" andContent:valueCityString];
    NSLog(@"valueCityString == %@",valueCityString);
        [self presentViewController:realselectVC animated:YES completion:^{
            NSLog(@"真题选择页面------回调");
        }];
     }
    else
        {
        NSLog(@"valueString == %@",valueString);
        NSString *urlstring = [NSString stringWithFormat:@"http://192.168.0.179:9867/tqWord/pad_userTest"];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        NSString *value_tj = [TJrealtypearray objectAtIndex:indexPath.row];
        //--------------
        //这里要改回来 (!)
        //--------------
        [ud setBool:YES forKey:value_tj];
        Real_isfirst = [ud boolForKey:value_tj];
        
        [self HUDonTheWay:(int)indexPath.row andURLString:urlstring andReflash:!Real_isfirst];
        }
    
}
-(void)HUDonTheWay:(int )index andURLString:(NSString *)urlString andReflash:(BOOL)flash
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    __block NSArray *resultDicts;//json解析后的数组
    netDataArray = [[NSMutableArray alloc]initWithCapacity:15];
    //------如果刷新 就重建表
    //    [loadEnglishDB deleteTable:@"SubType_Special"];
        [loadRealDB createTable:@"SubType_Real" withArguments:@"Sub_Id integer PRIMARY KEY autoincrement,Sub_Type text,Sub_Name text,Sub_Title text,Sub_A text,Sub_B text,Sub_C text,Sub_D text,Sub_Right text,Sub_Analyse text"];
    //------
    if (!Real_isfirst||flash) {
        
        
        hud.labelText = @"正在访问服务器";
        [hud showAnimated:YES whileExecutingBlock:^{
            
            //        [loadEnglishDB deleteTable:@"SubType_Special"];
            //        [loadEnglishDB createTable:@"SubType_Special" withArguments:@"Special_Id integer PRIMARY KEY autoincrement,Sub_Name text,Sub_Title text,Sub_A text,Sub_B text,Sub_C text,Sub_D text,Sub_Right text,Sub_Analyse text"];
            
            resultDicts = (NSArray *)[self getDataFromURLUseString:urlString];
            //-----------------------------------------------------------------------
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
            
            //------先删除 后插入
            [loadRealDB deleteTableValue:@"SubType_Real" Where:@"Sub_Name" IS:[[netDataArray objectAtIndex:0] objectAtIndex:0] And:NO Where2:nil IS2:nil];
            for (NSArray *CONTENT in netDataArray)
                {
                [loadRealDB insertTable:@"SubType_Real" Where:@"Sub_Type,Sub_Name,Sub_Title,Sub_A,Sub_B,Sub_C,Sub_D,Sub_Right,Sub_Analyse" Values:CONTENT Num:@"?,?,?,?,?,?,?,?"];
                }
            //-----------------------------------------------------------------------
        } completionBlock:^{
            [hud removeFromSuperview];
            if ( [resultDicts count] != 0)
                {
                BaseExamViewController *kslsView = [[BaseExamViewController alloc]initNeednewData:YES andDataFromwitchTable:@"SubType_Real" selectWith:valueString is:@"真题" where:@"Sub_Id"];
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
                
                
                
                BaseExamViewController *kslsView = [[BaseExamViewController alloc]initNeednewData:YES andDataFromwitchTable:@"SubType_Real" selectWith:valueString is:@"真题" where:@"Sub_Id"];
                
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
