//
//  BaseExamViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-11-8.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseExamViewController.h"
#import "HomeViewController.h"
#import "resultViewController.h"
#import "PanelView.h"

#import "GRAlertView.h"
#import "CommClass.h"
#import "WrongDataClass.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 5.0f

@interface BaseExamViewController ()

@end

@implementation BaseExamViewController
@synthesize panelsArray;
@synthesize tableDictionary;
@synthesize delegate;

-(id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(mytest:) name:@"clickData" object:nil];
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(clickover) name:@"timeover" object:nil];
         panelsArray = [[NSMutableArray alloc] initWithArray:@[@"A.png",@"B.png",@"C.png",@"D.png"]];
        //-----初始化数据库
        loadExamDB = [[myDB alloc]initWithDBName:@"ExamQuestionBank.db"];
        dataArray = [[NSMutableArray alloc]initWithCapacity:15];//初始化cell数据数组
        wrongViewOpen = NO;
        
        ud = [NSUserDefaults standardUserDefaults];
    }
    return self;
}
-(id)initViewWithTableDictionary:(NSArray *)tableDic AndTitle:(NSString *)title
{
    self = [self init];
    if (self) {
        self.tableDictionary = tableDic;
        wrongViewOpen = YES;
        uNum = 15;
        [ud setBool:NO forKey:@"SubType_Fast"];
        [ud setBool:NO forKey:@"SubType_Special"];
        [ud setBool:NO forKey:@"SubTpye_Real"];
        initTableName = title;
        thisString = @"错题智能练习";
        [loadExamDB deleteTable:@"SubType_Fast_Temp"]; //------丢弃表,并重建
        [loadExamDB createTable:@"SubType_Fast_Temp" withArguments:@"Sub_Num integer PRIMARY KEY autoincrement,Sub_Temp_Id int,Sub_Table text,Sub_Mark int,Sub_Choosed int,Sub_Choose_Right text,Sub_Time int"];
        
    }
    [self addTemporaryUI];
    [self initWrongDataArray:self.tableDictionary];
    return self;
}
- (id)initNeednewData:(BOOL)initnew andDataFromwitchTable:(NSString *)tableName selectWith:(NSString *)detail is:(NSString *)selectName where:(NSString *)where
{
    self = [self init];
	if (self)
        {
        initNew = initnew; //是否要更新
        initTableName = tableName;//需要查询的表名
        NSLog(@"initTableName == %@",initTableName);
        initIndexString = detail;//详细内容 (语法)
        initSelectName = selectName;//查找的内容是什么 fathername
        initWhere = where;//在题库表中的位置
        //------是否第一次启动?
        //------如果是新表,就丢弃进度 确保至多只有1个保存进度了
        if (initNew)
            {
            [ud setBool:NO forKey:@"SubType_Fast"];
            [ud setBool:NO forKey:@"SubType_Special"];
            [ud setBool:NO forKey:@"SubTpye_Real"];
            }
        thisString = [NSString stringWithFormat:@"%@-%@",initSelectName,initIndexString];//------语文专项-语文例题
        NSLog(@"thissring == %@",thisString);
        [ud setBool:YES forKey:thisString];//这里设置语法英语专项不是第一次使用
        Exam_isFirstLoad = [ud boolForKey:@"ExamFirst"];
        Exam_isSave = [ud boolForKey:initTableName];
        uNum = [ud integerForKey:@"uNum"];  
        //------如果是保存进度状态正确 则读取进度表 否则丢弃表,重写
        if (!Exam_isSave||initNew)//如果没有保存进度/如果初始化的时候要求新建表
            {
            [loadExamDB deleteTable:@"SubType_Fast_Temp"]; //------丢弃表,并重建
            [loadExamDB createTable:@"SubType_Fast_Temp" withArguments:@"Sub_Num integer PRIMARY KEY autoincrement,Sub_Temp_Id int,Sub_Table text,Sub_Mark int,Sub_Choosed int,Sub_Choose_Right text,Sub_Time int"];
            }
        }
    
    [self addTemporaryUI];
    [self initDataArray];
	return self;
}
#pragma mark 添加UI

- (void)addTemporaryUI
{
    _TopView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lianxijieguo__03.png"]];
    _TopView.userInteractionEnabled = YES;
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10, 11,24, 37);
    [_backBtn setImage:[UIImage imageNamed:@"zhuce_1.png"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"zhuce_2.png"] forState:UIControlStateHighlighted];
    [_backBtn addTarget:self action:@selector(backBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tipBtn.frame = CGRectMake(92, 11,24, 37);
    [_tipBtn setImage:[UIImage imageNamed:@"biaoji_2.png"] forState:UIControlStateNormal];
    [_tipBtn setImage:[UIImage imageNamed:@"biaoji_1.png"] forState:UIControlStateHighlighted];
    [_tipBtn setImage:[UIImage imageNamed:@"biaoji_1.png"] forState:UIControlStateSelected];
    [_tipBtn setSelected:YES];
    [_tipBtn addTarget:self action:@selector(tipBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _cardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cardBtn.frame = CGRectMake(184, 11,24, 37);
    [_cardBtn setImage:[UIImage imageNamed:@"card_1.png"] forState:UIControlStateNormal];
    [_cardBtn setImage:[UIImage imageNamed:@"card.png"] forState:UIControlStateHighlighted];
    [_cardBtn addTarget:self action:@selector(cardBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeBtn.frame = CGRectMake(286, 5,24, 37);
    [_timeBtn setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal];
    
    _timeLb = [[UILabel alloc]initWithFrame:CGRectMake(280, 35, 40, 14)];
    _timeLb.textAlignment = 1;
    _timeLb.font = [UIFont systemFontOfSize:10.0];
    _timeLb.text = [NSString stringWithFormat:@"%d 秒",mTime];
    
    [_TopView addSubview:_timeBtn];
    [_TopView addSubview:_tipBtn];
    [_TopView addSubview:_cardBtn];
    [_TopView addSubview:_backBtn];
    [_TopView addSubview:_timeLb];
    
    [self.view addSubview:_TopView];
     [self StartTimer];
}
//--------初始化数据
-(void)initWrongDataArray:(NSArray *)dic
{
    
    for (WrongDataClass *wrongData in dic)
        {
        NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%d'",wrongData.tableStr,@"Sub_Id",wrongData.tableIndex];
        //查询数据
        FMResultSet *rs= [loadExamDB findinTable:sqlstring];
        [self addDataUseFMResultSet:rs andNeedInit:YES AndTable:wrongData.tableStr];
        }

}

-(void)initDataArray
{
    NSLog(@"initDataArray");
    //------除了快速练习 其他的一般都是new
    if (!Exam_isSave||initNew) //如果是 不保存状态 就刷新题目 写入数据库
        {
            //------专项练习初始化
            if ([initTableName isEqualToString:@"SubType_Special"])
                {
                NSLog(@"SubType_Special");
                NSString *sqlstring =[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@' AND %@='%@' ORDER BY RANDOM() limit %d",initTableName,@"Sub_Type",initSelectName,@"Sub_Name",initIndexString,uNum];
                FMResultSet *rs= [loadExamDB findinTable:sqlstring];
                 [self addDataUseFMResultSet:rs andNeedInit:YES AndTable:nil];
               
                }
            //------真题模考
            else if ([initTableName isEqualToString:@"SubType_Real"])
                {
                NSLog(@"SubType_Real");
                NSString *sqlstring =[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@' AND %@='%@' ORDER BY RANDOM() limit %d",initTableName,@"Sub_Type",initSelectName,@"Sub_Name",initIndexString,uNum];
                FMResultSet *rs= [loadExamDB findinTable:sqlstring];
                [self addDataUseFMResultSet:rs andNeedInit:YES AndTable:nil];
                
                }
            //------快速智能初始化
            else
                {
                NSLog(@"SubType_Fast");
                thisString = @"快速智能练习";
                NSString *sqlstring =[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY RANDOM() limit %d",initTableName,uNum];
                FMResultSet *rs= [loadExamDB findinTable:sqlstring];
                    [self addDataUseFMResultSet:rs andNeedInit:YES AndTable:nil];
                }
            //--------同步数据条数
            [ud setInteger:uNum forKey:@"uNum"];
            [ud synchronize];
            //-----这个可以删掉?
            
        }
    else //从临时表中读取进度
        {
        uNum = [ud integerForKey:@"uNum"];
        
        for (int i = 0; i<uNum; i++)
            {
            //         NSLog(@"查询数据 %@",[randomArray objectAtIndex:i]);
            NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%d'",@"SubType_Fast_Temp",@"Sub_Num",i+1];
            //查询数据
            FMResultSet *rs= [loadExamDB findinTable:sqlstring];
            while ([rs next])
                {
                mTime = [[rs stringForColumn:@"Sub_Time"] intValue];
                NSString *sqlstringnext = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'",[rs stringForColumn:@"Sub_Table"],initWhere,[rs stringForColumn:@"Sub_Temp_Id"]];
                NSLog(@"%@",sqlstringnext);
                FMResultSet *rsnext= [loadExamDB findinTable:sqlstringnext];
                //------快速练习 加载数据
                [self addDataUseFMResultSet:rsnext andNeedInit:NO AndTable:nil];
                }
            //------其他两种
            }
        }
    //-------刷新Table
//   [self flashtableview];
}
//------快速练习 通过rs加载数据
-(void)addDataUseFMResultSet:(FMResultSet *)rs andNeedInit:(BOOL)NeedInit AndTable:(NSString *)table
{
    while ([rs next])
        {
        thisSub = [[SubType_Comm alloc]init];
        
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
        
        [dataArray addObject:thisSub];
        
        
        
        if (NeedInit)
            {
            NSArray *temp2;
            if (!wrongViewOpen) {
                temp2 = @[thisSub.Sub_Id,initTableName,@(0),@(0),thisSub.Sub_Right,@(0)];
            } else {
                temp2 = @[thisSub.Sub_Id,table,@(0),@(0),thisSub.Sub_Right,@(0)];
            }
            [loadExamDB insertTable:@"SubType_Fast_Temp" Where:@"Sub_Temp_Id,Sub_Table,Sub_Mark,Sub_Choosed,Sub_Choose_Right,Sub_Time" Values:temp2 Num:@"?,?,?,?,?,?"];
            }
        }
    //------其他两种
}

#pragma mark - 通知
//------通知交卷响应---在第15条数据 更新时间
-(void)clickover
{
    NSArray *temp2;
    if (!wrongViewOpen) {
        temp2 = @[@(self->mTime),@(uNum)];
    } else {
        temp2 = @[@(self->mTime),@(15)];
    }
    [loadExamDB updateTable:@"SubType_Fast_Temp" SetName:@"Sub_Time" WhereName:@"Sub_Num" UserValue:temp2];
}
- (void) mytest:(NSNotification*) notification
{
    NSArray *MarkArray = [notification object] ;//获取到传递的对象
    [self.scrollView setContentOffset:CGPointMake(([self panelViewSize].width+2*GAP)*[[MarkArray objectAtIndex:0] integerValue],0) animated:NO];
    
    [self flashtableview];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
	if (currentPage!=lastDisplayedPage)
        {
		PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
		[panelView pageDidAppear];
        }
	lastDisplayedPage = currentPage;
    [self flashtableview];
}
//--------initdata和viewdidappear和scrolldidend调用了
-(void)flashtableview
{
    PanelView *panelView = [self panelViewAtPage:currentPage];
    NSArray *findResult = [self findTmpTable:currentPage+1];
    int row =   [[findResult objectAtIndex:0] intValue];
    int mark = [[findResult objectAtIndex:1] intValue];
    if (row != 0 ) {
        NSIndexPath *ip=[NSIndexPath indexPathForRow:row inSection:0];
        [panelView.tableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
    if (mark == 1) {
        NSLog(@"MARK");
        [_tipBtn setSelected:NO];
    } else {
        [_tipBtn setSelected:YES];
    }
}
-(NSArray *)findTmpTable:(int)index
{
    NSString *sqlstring = [NSString stringWithFormat:@"SELECT Sub_Choosed,Sub_Mark FROM %@ WHERE %@='%d'",@"SubType_Fast_Temp",@"Sub_Num",index];
    NSArray *result;
    //查询数据
    FMResultSet *rs= [loadExamDB findinTable:sqlstring];
    while ([rs next])
        {
        result = @[[rs stringForColumn:@"Sub_Choosed"],[rs stringForColumn:@"Sub_Mark"]];
        }
    return result;
}

#pragma mark - 是否第一次使用
-(void)isFirstLoad
{
    //--------是否第一次使用
    if (!Exam_isFirstLoad)
        {
        NSLog(@"first load");
        [self addPictrue:[UIImage imageNamed:@"zhishi3.png"]];
        [ud setBool:true forKey:@"ExamFirst"];
        //------创建表
        [loadExamDB deleteTable:@"SubType_Fast_Temp"];
        [loadExamDB createTable:@"SubType_Fast_Temp" withArguments:@"Sub_Num integer PRIMARY KEY autoincrement,Sub_Temp_Id int,Sub_Table text,Sub_Mark int,Sub_Choosed int,Sub_Choose_Right text,Sub_Time int"];
        } else {
            //--------开始计时
            [self StartTimer];
        }
}

//------首次启动显示
-(void)addPictrue:(UIImage *)image
{
    topImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    topImgV.image = image;
    
    
    topImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
    
    [topImgV addGestureRecognizer:singleTap];
    [self.view addSubview:topImgV];
}

- (void)UesrClicked:(UIGestureRecognizer *)gestureRecognizer {
    
    //do something....
    [topImgV setHidden:YES];
     [self StartTimer];//定时器 开始走
    
    
}
#pragma mark -计时器相关
//--------计时器
- (void)StartTimer
{
    //repeats设为YES时每次 invalidate后重新执行，如果为NO，逻辑执行完后计时器无效
    mTime = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAdvanced:) userInfo:nil repeats:YES];
}
//--------这个函数将会执行一个循环的逻辑
- (void)timerAdvanced:(NSTimer *)time
{
    //加一个计数器
    if (mTime == 0)
        {
        [time invalidate];
        [self StartTimer];
        }
    mTime++;
    if (mTime > 60) {
        _timeLb.textColor = [UIColor orangeColor];
    }
    if (mTime > 120) {
        _timeLb.textColor = [UIColor yellowColor];
    }
    if (mTime > 180) {
        _timeLb.textColor = [UIColor redColor];
    }
    _timeLb.text = [NSString stringWithFormat:@"%d 秒",mTime];
}
#pragma mark -标记点击
//--------标记点击
-(void)tipBtnDidClick:(UIButton *)sender
{
    //------增加数据 练习错题 不需要这些功能
    if (sender.selected)
        {
        sender.selected = NO;
        NSArray *temp1 = @[@(1),@(self->currentPage+1)];
        [loadExamDB updateTable:@"SubType_Fast_Temp" SetName:@"Sub_Mark" WhereName:@"Sub_Num" UserValue:temp1];
        //------其他两种
        }
    else
        {
        sender.selected = YES;
        NSArray *temp1 = @[@(0),@(self->currentPage+1)];
        [loadExamDB updateTable:@"SubType_Fast_Temp" SetName:@"Sub_Mark" WhereName:@"Sub_Num" UserValue:temp1];
        //------其他两种
        }
}
#pragma mark -后退点击
//--------后退点击
-(void)backBtnDidClick:(id)sender
{
    if (!wrongViewOpen) {
        GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"提醒"
                                                        message:@"您还有未做完的题,需要保存吗?"
                                                       delegate:self
                                              cancelButtonTitle:@"保存退出"
                                              otherButtonTitles:@"取消继续", nil];
        alert.style = GRAlertStyleInfo;
        
        [alert show];
    } else {
        GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"提醒"
                                                        message:@"退出后记录将不被保存,退出?"
                                                       delegate:self
                                              cancelButtonTitle:@"退出"
                                              otherButtonTitles:@"取消", nil];
        alert.style = GRAlertStyleInfo;
        
        [alert show];
    }
    
}
//--------弹出框响应
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!wrongViewOpen) {
        if (buttonIndex == 0) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSLog(@"%@ 练习中,退出保存",initTableName);
            if ([initTableName isEqualToString:@"SubType_Fast"])
                {
                [defaults setBool:NO forKey:@"SubType_Special"];
                [defaults setBool:NO forKey:@"SubType_Real"];
                }else if ([initTableName isEqualToString:@"SubType_Special"])
                    {
                    [defaults setBool:NO forKey:@"SubType_Fast"];
                    [defaults setBool:NO forKey:@"SubType_Real"];
                    }
                else
                    {
                    [defaults setBool:NO forKey:@"SubType_Fast"];
                    [defaults setBool:NO forKey:@"SubType_Special"];
                    }
            [defaults setBool:YES forKey:initTableName];
            [defaults synchronize];
            
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"关闭练习页面------回调");//这里打个断点，点击按钮模态视图移除后会回到这里
                if (timer.isValid) {
                    //关闭定时器
                    NSArray *temp2 = @[@(mTime),@(uNum)];
                    [loadExamDB updateTable:@"SubType_Fast_Temp" SetName:@"Sub_Time" WhereName:@"Sub_Num" UserValue:temp2];
                    [timer invalidate];
                }
            }];
            
        }
    }
    else {
        //--------练习错题 主页退出
        if (buttonIndex == 0) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (timer.isValid) {
                    //关闭定时器
                    [timer invalidate];
                }
            }];
        }
    }
}

#pragma mark -答题卡点击
//--------答题卡点击
-(void)cardBtnDidClick:(id)sender
{
    resultViewController *result = [[resultViewController alloc]initWithNibName:@"resultViewController" bundle:nil];
    self.delegate = result;
    
    [self presentViewController:result animated:YES completion:^{
        [self.delegate passValue:initTableName];
        NSLog(@"打开答题卡页面------回调");
    }];
}

//--------自定义对话框
- (void)showCustomDialog
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在进入答题卡";
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        float progress = 0.0f;
        while (progress < 1.0f) {
            progress += 0.01f;
            HUD.progress = progress;
            usleep(10000);
        }
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
        
        resultViewController *result = [[resultViewController alloc]initWithNibName:@"resultViewController" bundle:nil];
        self.delegate = result;
        NSLog(@"init %@",initTableName);
        [self presentViewController:result animated:YES completion:^{
            [self.delegate passValue:initTableName];
            
            NSLog(@" 打开答题卡页面------回调 %@", _timeLb.text);
        }];
    }];  }

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    DLog();
    PanelView *panelView = [self panelViewAtPage:currentPage];
	[panelView pageWillAppear];
    
    [self flashtableview];

}
- (void)dealloc
{
    //移除observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"timeover" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickData2" object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark panel views delegate/datasource

- (NSInteger)numberOfPanels
{
    if (wrongViewOpen) {
        return 15;
    }
	return uNum;
}

- (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
{
	return 5;
}
- (CGFloat)panelView:(PanelView *)panelView Page:(NSInteger)pageNumber  heightForRowAtIndexPath:(PanelIndexPath *)indexPath
{
    
    NSLog(@"pageNumber == %d",pageNumber);
    if (dataArray.count > 0) {
        
        cellData = [dataArray objectAtIndex:indexPath.page];
        NSArray *cellDataArray = @[cellData.Sub_Title,cellData.Sub_A,cellData.Sub_B,cellData.Sub_C,cellData.Sub_D];
        NSString *cellString = [cellDataArray objectAtIndex:indexPath.row];
        NSString *text = [[[CommClass sharedInstance] flattenHTML:cellString trimWhiteSpace:YES] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:FONT_SIZE] forKey:NSFontAttributeName];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        
        
        CGFloat height = MAX(size.height, 44.0f);
        
        NSLog(@"height == %f",height);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    
    return 44.0f;
    
    
}


/**
 *
 *  设置头视图
 */
- (CGFloat)panelView:(id)panelView heightForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section
{
    return 40.0f;
}
- (UIView *)panelView:(id)panelView viewForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section
{
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
      topView.backgroundColor = UIColorFromRGB(0xF0F8FF);
    
    UILabel *llb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.width-20-150 , 30)];
    llb.text = thisString;
    llb.backgroundColor = [UIColor clearColor];
    
    UILabel *mlb = [[UILabel alloc]initWithFrame:CGRectMake(240, 5, self.view.width-20-250 , 30)];
    mlb.text = [NSString stringWithFormat:@"%d",(int)pageNumber+1];
      mlb.backgroundColor = [UIColor clearColor];
    mlb.textColor = [UIColor blueColor];
    
    UILabel *rlb = [[UILabel alloc]initWithFrame:CGRectMake(260, 5, self.view.width-20-250 , 30)];
    rlb.text = [NSString stringWithFormat:@"| %d",uNum];
    rlb.backgroundColor = [UIColor clearColor];
    
    
    
    [topView addSubview:llb];
    [topView addSubview:mlb];
    [topView addSubview:rlb];

    return topView;
}

-( CGSize )sizeOfTheSetText:(NSString *)text
{
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:text attributes:@{
                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]
                                                                                                     }];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size;
}
- (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    UILabel *label = nil;
    cellData = [dataArray objectAtIndex:indexPath.page];
    NSArray *cellDataArray = @[cellData.Sub_Title,cellData.Sub_A,cellData.Sub_B,cellData.Sub_C,cellData.Sub_D];
    NSString *cellString = [cellDataArray objectAtIndex:row];
    NSString *displayStr = [[[CommClass sharedInstance] flattenHTML:cellString trimWhiteSpace:YES] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
	
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label setMinimumScaleFactor:FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setTag:1];
        [label setBackgroundColor:[UIColor clearColor]];
        
        
//        [[label layer] setBorderWidth:2.0f];
        
        [[cell contentView] addSubview:label];
        
    
     CGSize size = [self sizeOfTheSetText:displayStr];
    if (!label)
        {
        label = (UILabel*)[cell viewWithTag:1];
        }
    
    
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN+60, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2) - 60, MAX(size.height, 44.0f))];
    if (row != 0) {
        [label setText:displayStr];
        NSString *imageName = [panelsArray objectAtIndex:indexPath.row-1];
        cell.imageView.image = [UIImage imageNamed:imageName];
    }else {
        NSString *str =[NSString stringWithFormat:@"— %@",displayStr];
        [label setText:str];
        cell.contentView.backgroundColor = UIColorFromRGB(0xF0F8FF);
        cell.userInteractionEnabled = NO;
        [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    }
   
    
    
    
    
    
    
   
    
    
	return cell;
}


- (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return;
    }
    
	PGnum = indexPath.page+1; //num  ==  1-15
    //------保存点击值
    [self saveTableviewOffset:indexPath.row];
    if (PGnum == uNum)
        {//------如果到了最后一题
            [self showCustomDialog];
        }
    else
        {
        //------偏移到下一个页面
        [self.scrollView setContentOffset:CGPointMake(([self panelViewSize].width+2*GAP)*PGnum,0) animated:YES];
        [panelView pageWillAppear];
        }
}
//------重写 panelview中的方法 保存选择状态
- (void)saveTableviewOffset:(int)index
{
	//------写数据库
    //------增加数据
    NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM SubType_Fast_Temp WHERE Sub_Num='%d'",self->currentPage+1];
    //查询数据
    FMResultSet *rs= [loadExamDB findinTable:sqlstring];
    if ([rs next])
        {
        NSArray *temp1 = @[@(index),@(self->currentPage+1)];
        [loadExamDB updateTable:@"SubType_Fast_Temp" SetName:@"Sub_Choosed" WhereName:@"Sub_Num" UserValue:temp1];
        NSArray *temp2 = @[@(self->mTime),@(self->currentPage+1)];
        [loadExamDB updateTable:@"SubType_Fast_Temp" SetName:@"Sub_Time" WhereName:@"Sub_Num" UserValue:temp2];
        }else
            {
            SubType_Comm *cellData2 = [dataArray objectAtIndex:self->currentPage];
            NSArray *temp2 = @[@(0),@(index),cellData2.Sub_Right,@(self->mTime)];
            [loadExamDB insertTable:@"SubType_Fast_Temp" Where:@"Sub_Mark,Sub_Choosed,Sub_Choose_Right,Sub_Time" Values:temp2 Num:@"?,?,?,?"];
            }
}


@end
