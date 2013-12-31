//
//  answerViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-27.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "answerViewController.h"
#import "HomeViewController.h"
#import "History_Space.h"
#import "singleViewController.h"

@interface answerViewController ()

@end

@implementation answerViewController
@synthesize mTime;
@synthesize mTitle;
@synthesize Lb2;
@synthesize Lb4;
@synthesize num;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //        [self initanswerData];
        //-----初始化数据库
        loadAnswerDB = [[myDB alloc]initWithDBName:@"ExamQuestionBank.db"];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        uNum = [ud integerForKey:@"uNum"];
        isWrong = NO;
    }
    return self;
}

-(id)initWithIndex:(int)index Data:(NSString *)dataString Wrong:(BOOL)wrong
{
    if(self = [super init])
        {
        local = index;
        isWrong = wrong;
        History_Time = dataString;
        num = [[numView alloc]initWithFrame:CGRectMake(0, 200, 320, 200)];
        }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self passValue:History_Time];
}
- (void)passValue:(NSString *)value
{
    History_Time = value;
    thisHistory = [History_Space new];
    //------查询history数据库 用于显示数据
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM History_Space WHERE History_Time='%@'",History_Time];
    FMResultSet *rs= [loadAnswerDB findinTable:sqlString];
    while ([rs next])
        {
        thisHistory.History_Type = [rs stringForColumn:@"History_Type"];
        thisHistory.History_Name = [rs stringForColumn:@"History_Name"];
        thisHistory.History_Table = [rs stringForColumn:@"History_Table"];
        thisHistory.History_Serial = [rs stringForColumn:@"History_Serial"];
        thisHistory.History_Choosed = [rs stringForColumn:@"History_Choosed"];
        thisHistory.History_Right = [rs stringForColumn:@"History_Right"];
        thisHistory.History_Mark = [rs stringForColumn:@"History_Mark"];
        thisHistory.History_Time = [rs stringForColumn:@"History_Time"];
        thisHistory.History_Total = [rs intForColumn:@"History_Total"];
        thisHistory.History_RightNum =  [rs intForColumn:@"History_RightNum"];
        thisHistory.History_UseTime =  [NSNumber numberWithInt:[[rs stringForColumn:@"History_UseTime"] intValue]];
        }
    
    self.titleLbs.text = [NSString stringWithFormat:@"%@",thisHistory.History_UseTime];//练习用时多久
    Lb2.text = [NSString stringWithFormat:@"%@-%@",thisHistory.History_Type,thisHistory.History_Name] ;//练习类型
    Lb4.text = History_Time;//交卷时间
    _imgLb.text = [NSString stringWithFormat:@"%d",thisHistory.History_RightNum];//答对的题目个数
    
    
    //    NSLog(@"thisHistory.History_Choosed == %@",thisHistory.History_Choosed);
    
    NSArray *a  = [thisHistory.History_Right componentsSeparatedByString:@"|"];
    NSArray *b = [thisHistory.History_Choosed componentsSeparatedByString:@"|"];
    //    NSArray *c = [thisHistory.History_Mark componentsSeparatedByString:@","];
    NSArray *thisArray = @[num.bt1,num.bt2,num.bt3,num.bt4,num.bt5,num.bt6,num.bt7,num.bt8,num.bt9,num.bt10,num.bt11,num.bt12,num.bt13,num.bt14,num.bt15];
    NSArray *answerArray = @[@"空",@"A",@"B",@"C",@"D"];
    
    for (int i = 0; i<thisHistory.History_Total; i++)
        {
        NSString *choosed =[answerArray objectAtIndex: [[b objectAtIndex:i] integerValue]];
        NSString *right = [a objectAtIndex:i];
        UIButton *thisBtn = [thisArray objectAtIndex:i];
        [thisBtn setHidden:NO];
         [thisBtn addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];//第一题答错了
        //        NSString *mark = [c objectAtIndex:i];
        if (![right isEqualToString:choosed])
            {
            [thisBtn setBackgroundImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateNormal];//题答错了
            }
        }
    
}


-(void)loadView
{
    [super loadView];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    //    CGFloat width = size.width;
    CGFloat height = size.height;
    //------
    self.view.backgroundColor = [UIColor whiteColor];
    //-----头部
    self.TopView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lianxijieguo__03.png"]];
    _TopView.userInteractionEnabled = YES;
    
    UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maskBtn.frame = CGRectMake(10, 11,24, 37);
    
    [maskBtn setImage:[UIImage imageNamed:@"zhuce_1.png"] forState:UIControlStateNormal];
    [maskBtn setImage:[UIImage imageNamed:@"zhuce_2.png"] forState:UIControlStateHighlighted];
    [maskBtn addTarget:self action:@selector(maskBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_TopView addSubview:maskBtn];
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 140, 30)];
    titleLb.text = @"答题用时        秒!";
    titleLb.textAlignment = 1;
    
    
    self.titleLbs = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 40, 30)];
    self.titleLbs.text =@"";
    _titleLbs.textAlignment = 1;
    _titleLbs.backgroundColor = [UIColor clearColor];
    _titleLbs.textColor = UIColorFromRGB(0x2c7cff);
    
    [titleLb addSubview:_titleLbs];
    [_TopView addSubview:titleLb];
    
    //-----中部  改高度
    
    self.MidView = [[UIView alloc]initWithFrame:CGRectMake(0, 57, 320, height-59)];
//    [self.MidView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"answerBG.png"]]];
    
    UILabel *Lb1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 30)];
    Lb1.text = @"练习类型:";
    Lb1.font = [UIFont systemFontOfSize:13.0];
    Lb1.backgroundColor = [UIColor clearColor];
    
    Lb2 = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, 200, 30)];
    Lb2.text = @"";//练习类型
    Lb2.font = [UIFont systemFontOfSize:13.0];
    Lb2.backgroundColor = [UIColor clearColor];
    
    UILabel *Lb3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 70, 30)];
    Lb3.text = @"交卷时间:";
    //    Lb1.textAlignment = 1;
    Lb3.font = [UIFont systemFontOfSize:15.0];
    Lb3.backgroundColor = [UIColor clearColor];
    
    
    //交卷时间 查询数据库
    
    Lb4 = [[UILabel alloc]initWithFrame:CGRectMake(85, 30, 200, 30)];
    Lb4.text = @"";
    //    Lb1.textAlignment = 1;
    Lb4.font = [UIFont systemFontOfSize:15.0];
    Lb4.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lianxijieguo_2.png"]];
    imgView.frame = CGRectMake(10, 80, 295, 85);
    
    self.imgLb = [[UILabel alloc]initWithFrame:CGRectMake(170, 5, 70, 80)];
    _imgLb.text = @"15";//答对的题目个数
    _imgLb.textAlignment = 1;
    _imgLb.textColor = UIColorFromRGB(0x4bb900);
    _imgLb.font = [UIFont systemFontOfSize:62.0];
    _imgLb.backgroundColor = [UIColor clearColor];
    
    
    
    
    
    
    [imgView addSubview:_imgLb];
    [_MidView addSubview:Lb1];
    [_MidView addSubview:Lb2];
    [_MidView addSubview:Lb3];
    [_MidView addSubview:Lb4];
    [_MidView addSubview:imgView];
    [_MidView addSubview:num];
    
    [self.view addSubview:_TopView];
    [self.view addSubview:_MidView];
    
}


-(void)onclick:(id)sender{
    
    UIButton* btn = (UIButton*)sender;
    int currentNum = [btn.currentTitle intValue]; //按钮的标题1~15
    NSLog(@"currentNum == %d",currentNum);
    NSArray *dataArray = @[thisHistory];
    
    singleViewController *singelVC = [[singleViewController alloc]initWithIndex:currentNum Data:dataArray];
    
    [self presentViewController:singelVC animated:YES completion:^{
        
    }];
    
}

-(void)maskBtnDidClick:(id)sender
{
    if (local == 0)
        {
        HomeViewController *home = [[HomeViewController alloc]init];
        [self presentViewController:home animated:YES completion:^{
            if (isWrong) {
                [loadAnswerDB deleteTableValue:@"History_Space" Where:@"History_Time" IS:[NSString stringWithFormat:@"\'%@\'",History_Time] And:NO Where2:nil IS2:nil];
            }
            NSLog(@"结果返回主页------回调");
        }];
        }
    else
        {
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"结果页面返回------回调");
        }];
        }
}

@end
