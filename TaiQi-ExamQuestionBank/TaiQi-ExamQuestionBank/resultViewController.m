//
//  resultViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-27.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "resultViewController.h"
#import "answerViewController.h"
#import "SubType_Comm.h"

#import <AGCommon/UIColor+Common.h>
@interface resultViewController ()

@end

@implementation resultViewController
//@synthesize delegate;
@synthesize fatherType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        uNum = [ud integerForKey:@"uNum"];
        wrongSub = NO;
        buttonArray = [NSArray new];
    }
    return self;
}
-(void)passValue:(NSString *)value
{
    fatherType = value;
    NSString *MainType = [fatherType substringToIndex:2];
    NSLog(@"查看题目卡 MainType == %@",MainType);
    
    if ([MainType isEqualToString:@"错题"]) {
        wrongSub = YES;
        uNum = 15;
    }
    [self ShowMyUI];
}
-(void)ShowMyUI
{
    int num;
    int mark;
    [self initanswerData];
    buttonArray = @[self.Btn1,self.Btn2,self.Btn3,self.Btn4,self.Btn5,self.Btn6,self.Btn7,self.Btn8,self.Btn9,self.Btn10,self.Btn11,self.Btn12,self.Btn13,self.Btn14,self.Btn15];
    NSString *txtSTring;
    //--------这里随便用SubType_Special 或者fast 他们结构都一样
    if (!wrongSub) {
        txtSTring = [NSString stringWithFormat:@"%@-%@",((SubType_Comm *)[self.dataArray objectAtIndex:0]).Sub_Type,((SubType_Comm *)[self.dataArray objectAtIndex:0]).Sub_Name];
    } else {
        txtSTring = [NSString stringWithFormat:@"%@",fatherType];
    }
    txtLB.text = txtSTring;
    SubType_Fast_Temp *temp = [SubType_Fast_Temp new];
    
    for (int i = 0; i<uNum; i++)
        {
        temp = [self.dataTempArray objectAtIndex:i];
        num = [temp.Sub_Choosed intValue];
        mark = [temp.Sub_Mark intValue];
        UIButton *tmpBtn = (UIButton *)buttonArray[i];
        [tmpBtn setHidden:NO];
        
        if (num == 0)//未选择
            {
            [tmpBtn setBackgroundImage:[UIImage imageNamed:@"weizuo.png"] forState:UIControlStateNormal];
            [tmpBtn setTitleColor:UIColorFromRGB(0x2c7cff) forState:UIControlStateNormal];
            tmpBtn.tag = 0;
            if (mark == 1) {//标记了
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"tijiao3.png"] forState:UIControlStateNormal];
                [tmpBtn setTitleColor:UIColorFromRGB(0x2c7cff) forState:UIControlStateNormal];
                tmpBtn.tag = 1;
            }
            }else {
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"weidianji.png"] forState:UIControlStateNormal];
                [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                tmpBtn.tag = 0;
                if (mark == 1) {//标记了
                    [tmpBtn setBackgroundImage:[UIImage imageNamed:@"biaoji2.png"] forState:UIControlStateNormal];
                    [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    tmpBtn.tag = 1;
                }
            }
        
        }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)loadView
{
    [super loadView];
    
    //显示从前一个界面传过来的值
    //-----初始化数据库
    loadResultDB = [[myDB alloc]initWithDBName:@"ExamQuestionBank.db"];
    //------用于显示到LOGO上
    txtLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 150, 20)];
    txtLB.font = [UIFont systemFontOfSize:10.0];
    txtLB.textColor = UIColorFromRGB(0xa1a1a1);
    txtLB.text = @"";
    txtLB.textAlignment = 1;
    txtLB.backgroundColor = [UIColor clearColor];
    [self.Img_Title addSubview:txtLB];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

#define viewAppear @"viewAppear"
- (void)saveClickBtn:(UIButton *)btn index:(int)index
{
    int mark = btn.tag;
    NSArray *MarkArray = @[@(index-1),@(mark)]; //1 1
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickData" object:MarkArray];
    
}
- (IBAction)Btn1Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:1];
    }];
}
- (IBAction)Btn2Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:2];
    }];
}
- (IBAction)Btn3Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:3];
    }];
}
- (IBAction)Btn4Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:4];
    }];
}
- (IBAction)Btn5Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:5];
    }];
}
- (IBAction)Btn6Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:6];
    }];
}
- (IBAction)Btn7Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:7];
    }];
}
- (IBAction)Btn8Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:8];
    }];
}
- (IBAction)Btn9Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:9];
    }];
}
- (IBAction)Btn10Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:10];
    }];
}
- (IBAction)Btn11Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:11];
    }];
}
- (IBAction)Btn12Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:12];
    }];
}
- (IBAction)Btn13Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:13];
    }];
}
- (IBAction)Btn14Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:14];
    }];
}
- (IBAction)Btn15Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveClickBtn:sender index:15];
    }];
}

//------交卷按钮响应
- (IBAction)asClick:(UIButton *)sender {
    
    // 提醒存储时间
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timeover" object:nil];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"交卷";
	HUD.detailsLabelText = @"智能分析答案中...";
	HUD.square = YES;
	
	[HUD showWhileExecuting:@selector(myTaskd) onTarget:self withObject:nil animated:YES];
    
    
    
}
//------点击交卷后的数据操作方法
-(void)myTaskd {
	// Do something usefull in here instead of sleeping ...
    sleep(1);
    //创建数据库/插入数据库
   
    if (![loadResultDB isTableOK:@"History_Space"]) {
        [loadResultDB createTable:@"History_Space" withArguments:@"History_Type text,History_Name text,History_Table text,History_Serial text,History_Choosed text,History_Right text,History_Mark text,History_Time text PRIMARY KEY,History_Total int,History_RightNum int,History_UseTime int"];
    }
    //------创建 History_Space 表
    if (![loadResultDB isTableOK:@"Wrong_Space"]) {
        [loadResultDB createTable:@"Wrong_Space" withArguments:@"Wrong_Id integer PRIMARY KEY autoincrement,Wrong_Type text,Wrong_Name text,Wrong_Time text,Wrong_Table text,Wrong_Num int"];
    }
    //------插入数据
    
    //------History_Name 练习类型 在表 SubType_Fast Sub_Name字段 dataArray中
    NSString *History_Type =((SubType_Comm *)[self.dataArray objectAtIndex:0]).Sub_Type ;
    //------History_Name 练习类型 在表 SubType_Fast Sub_Name字段 dataArray中
    NSString *History_Name = ((SubType_Comm *)[self.dataArray objectAtIndex:0]).Sub_Name;
    //------History_Table 来自于哪个题库表 SubType_Fast_Temp Sub_Table; datatemparray中
    NSString *History_Table = ((SubType_Fast_Temp *)[self.dataTempArray objectAtIndex:0]).Sub_Table;
    //------History_Serial 在题库表中的序列号 SubType_Fast_Temp Fast_Id.
    NSMutableString *History_Serial = [NSMutableString stringWithCapacity:40];
    //------History_Choosed 用户选择的序列 SubType_Fast_Temp Sub_Choosed
    NSMutableString *History_Choosed = [NSMutableString stringWithCapacity:40];
    //------History_Right 正确选择的序列 SubType_Fast_Temp Sub_Choose_Right
    NSMutableString *History_Right = [NSMutableString stringWithCapacity:40];
    //------History_Mark 是否标记序列 SubType_Fast_Temp Sub_Mark
    NSMutableString *History_Mark = [NSMutableString stringWithCapacity:40];
    //------History_Time 交卷时间
    NSString* History_Time;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY年MM月dd日 hh:mm:ss"];
    History_Time = [formatter stringFromDate:[NSDate date]];
    //------History_Total 题目总数 目前就定死15条
    int History_Total = uNum;
    //------History_RightNum 答对的个数
    int History_RightNum = 0;
    //------History_UseTime 答题耗时,查询数据库最后一条
    int History_UseTime;
    NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM SubType_Fast_Temp WHERE Sub_Num='%d'",uNum];
    FMResultSet *rs= [loadResultDB findinTable:sqlstring];
    while ([rs next])
        {
        History_UseTime = [[rs stringForColumn:@"Sub_Time"] intValue];
        }
    
    for (SubType_Fast_Temp *temp in self.dataTempArray)
        {
        [History_Serial appendFormat:@"%@,",temp.Sub_Temp_Id];
        [History_Choosed appendFormat:@"%@|",temp.Sub_Choosed];
        [History_Right appendFormat:@"%@|",temp.Sub_Choose_Right];
        [History_Mark appendFormat:@"%@,",temp.Sub_Mark];
        NSArray *answerArray = @[@"空",@"A",@"B",@"C",@"D"];
        
        int choosed = [temp.Sub_Choosed intValue];
        
        NSString *usechoose = [answerArray objectAtIndex:choosed];
        
        
        if ([usechoose isEqualToString:temp.Sub_Choose_Right])
            {
            History_RightNum++;//计算答对的个数
            }
        else
            {
            NSArray *value2 = @[History_Type,History_Name,History_Time,temp.Sub_Table,temp.Sub_Temp_Id];
            [loadResultDB insertTable:@"Wrong_Space" Where:@"Wrong_Type,Wrong_Name,Wrong_Time,Wrong_Table,Wrong_Num" Values:value2 Num:@"?,?,?,?,?"];
            }
        }
    
    NSArray *value = @[History_Type,History_Name,History_Table,History_Serial,History_Choosed,History_Right,History_Mark,History_Time,@(History_Total),@(History_RightNum),@(History_UseTime)];
    //------插入数据
    [loadResultDB insertTable:@"History_Space" Where:@"History_Type,History_Name,History_Table,History_Serial,History_Choosed,History_Right,History_Mark,History_Time,History_Total,History_RightNum,History_UseTime" Values:value Num:@"?,?,?,?,?,?,?,?,?,?,?"];
    
	answerViewController *answer = [[answerViewController alloc]initWithIndex:0 Data:History_Time Wrong:wrongSub];
    [self presentViewController:answer animated:YES completion:^{
        NSLog(@"打开结果页面------回调");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:fatherType];//下次删除表
        [defaults synchronize];
    }];
    
}


//------初始化数据
-(void)initanswerData
{
    self.dataArray = [NSMutableArray new];
    self.dataTempArray = [NSMutableArray new];
    for (int i = 0; i<uNum; i++)
        {
        // 查临时库全部15条数据
        NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM SubType_Fast_Temp WHERE Sub_Num='%d'",i+1];
        //查询数据
        FMResultSet *rs= [loadResultDB findinTable:sqlstring];
        while ([rs next])
            {
            thisTempSub = [SubType_Fast_Temp new];
            thisTempSub.Sub_Temp_Id =[NSNumber numberWithInt: [[rs stringForColumn:@"Sub_Temp_Id"] intValue]];//在题库中的ID
            thisTempSub.Sub_Table = [rs stringForColumn:@"Sub_Table"];//在哪个题库
            thisTempSub.Sub_Num = [rs stringForColumn:@"Sub_Num"];//在本表中的位置
            thisTempSub.Sub_Mark = [rs stringForColumn:@"Sub_Mark"];//是否标记
            thisTempSub.Sub_Choosed = [rs stringForColumn:@"Sub_Choosed"];//选则的哪个
            thisTempSub.Sub_Choose_Right = [rs stringForColumn:@"Sub_Choose_Right"];//正确的是
            thisTempSub.Sub_Time = [NSNumber numberWithInt:[[rs stringForColumn:@"Sub_Time"] intValue]];//耗时多久
            [_dataTempArray addObject:thisTempSub]; //临时库数组
            [self initDataUseFMResultSet];
            }
        }
    
}
-(void)initDataUseFMResultSet
{
        //------通过题库表名 和 那个题库中的题号 查数据
        NSString *sqlstringnext = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE Sub_Id='%@'",thisTempSub.Sub_Table,thisTempSub.Sub_Temp_Id];
        FMResultSet *rs= [loadResultDB findinTable:sqlstringnext];
        while ([rs next])
            {
            thisSub = [SubType_Comm new];
            thisSub.Sub_Id                 = [NSNumber numberWithInt: [rs intForColumn:@"Sub_Id"]];
            thisSub.Sub_Type             = [rs stringForColumn:@"Sub_Type"];
            thisSub.Sub_Name            = [rs stringForColumn:@"Sub_Name"];
            thisSub.Sub_Title               = [rs stringForColumn:@"Sub_Title"];
            thisSub.Sub_A                   = [rs stringForColumn:@"Sub_A"];
            thisSub.Sub_B                   = [rs stringForColumn:@"Sub_B"];
            thisSub.Sub_C                   = [rs stringForColumn:@"Sub_C"];
            thisSub.Sub_D                   = [rs stringForColumn:@"Sub_D"];
            thisSub.Sub_Right           = [rs stringForColumn:@"Sub_Right"];
            thisSub.Sub_Analyse        = [rs stringForColumn:@"Sub_Analyse"];
            
            [_dataArray addObject:thisSub];
            }
}
@end
