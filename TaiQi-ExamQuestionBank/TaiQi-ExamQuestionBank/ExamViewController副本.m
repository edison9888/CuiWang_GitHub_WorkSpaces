//
//  ExamViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-20.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "ExamViewController.h"
#import <AGCommon/UIView+Common.h>
#import <AGCommon/UIColor+Common.h>
#import "PanelView.h"
#import "resultViewController.h"
#import "myDB.h"
#import "HomeViewController.h"
#import "GRAlertView.h"

@interface ExamViewController ()<UIAlertViewDelegate>

@end

@implementation ExamViewController
@synthesize panelsArray;



- (id)init
{
	if (self = [super init])
        {
        
        //-----初始化数据库
        loadExamDB = [[myDB alloc]initWithDBName:@"ExamQuestionBank.db"];
        dataArray = [[NSMutableArray alloc]initWithCapacity:15];//初始化cell数据数组
        
        //        [self StartTimer];//开启计时器
        //------是否第一次启动?
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        Exam_isFirstLoad = [ud boolForKey:@"ExamFirst"];
        Exam_isSave = [ud boolForKey:@"saveProgress"];
        
        
        //        NSLog(@"%d", [loadExamDB getTableItemCount:@"SubType_Fast"]);
        
        
        //------如果是保存进度状态正确 则读取进度表 否则丢弃表,重写
        if (!Exam_isSave)
            {
            [loadExamDB deleteTable:@"SubType_Fast_Temp"];
            [loadExamDB createTable:@"SubType_Fast_Temp" withArguments:@"Sub_Temp_Id int,Sub_Table text,Sub_Num int,Sub_Mark int,Sub_Choosed int,Sub_Choose_Right text"];
            }
        
        [self initDataArray];
        
        }
	return self;
}

-(void)initDataArray
{
   
    if (!Exam_isSave) //如果是 不保存状态 就刷新题目 写入数据库
        { //-------随机抽题
        NSMutableArray *randomArray =  [self randomSub:15];//随机0~14 如果有1000个数 反正就取前15个
    //------固定抽取15道
    for (int i = 0; i<15; i++)
        {
//         NSLog(@"查询数据 %@",[randomArray objectAtIndex:i]);
        NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM SubType_Fast WHERE Fast_Id='%@'",[randomArray objectAtIndex:i]];
        //查询数据
        FMResultSet *rs= [loadExamDB findinTable:sqlstring];
        while ([rs next])
            {
            thisSub = [[SubType_Fast alloc]init];
            
            thisSub.Fast_Id                 = [NSNumber numberWithInt: [rs intForColumn:@"Fast_Id"]];
            thisSub.Sub_Name            = [rs stringForColumn:@"Sub_Name"];
            thisSub.Sub_Title               = [rs stringForColumn:@"Sub_Title"];
            thisSub.Sub_A                   = [rs stringForColumn:@"Sub_A"];
            thisSub.Sub_B                   = [rs stringForColumn:@"Sub_B"];
            thisSub.Sub_C                   = [rs stringForColumn:@"Sub_C"];
            thisSub.Sub_D                   = [rs stringForColumn:@"Sub_D"];
            thisSub.Sub_Right           = [rs stringForColumn:@"Sub_Right"];
            thisSub.Sub_Analyse        = [rs stringForColumn:@"Sub_Analyse"];
            
            [dataArray addObject:thisSub];
            
           
            NSArray *temp2 = @[thisSub.Fast_Id,@"SubType_Fast",@(i+1),@(0),@(0),thisSub.Sub_Right];
            [loadExamDB insertTable:@"SubType_Fast_Temp" Where:@"Sub_Temp_Id,Sub_Table,Sub_Num,Sub_Mark,Sub_Choosed,Sub_Choose_Right" Values:temp2 Num:@"?,?,?,?,?,?"];
            }
        }
        }
    else //读取进度
        {
        for (int i = 0; i<15; i++)
            {
            //         NSLog(@"查询数据 %@",[randomArray objectAtIndex:i]);
            NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM SubType_Fast_Temp WHERE Sub_Num='%d'",i+1];
            //查询数据
            FMResultSet *rs= [loadExamDB findinTable:sqlstring];
            while ([rs next])
                {
                
                NSString *sqlstringnext = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE Fast_Id='%@'",[rs stringForColumn:@"Sub_Table"],[rs stringForColumn:@"Sub_Temp_Id"]];
                
                FMResultSet *rsnext= [loadExamDB findinTable:sqlstringnext];
                while ([rsnext next])
                    {
                thisSub = [[SubType_Fast alloc]init];
                
                thisSub.Fast_Id                 = [NSNumber numberWithInt: [rsnext intForColumn:@"Fast_Id"]];
                thisSub.Sub_Name            = [rsnext stringForColumn:@"Sub_Name"];
                thisSub.Sub_Title               = [rsnext stringForColumn:@"Sub_Title"];
                thisSub.Sub_A                   = [rsnext stringForColumn:@"Sub_A"];
                thisSub.Sub_B                   = [rsnext stringForColumn:@"Sub_B"];
                thisSub.Sub_C                   = [rsnext stringForColumn:@"Sub_C"];
                thisSub.Sub_D                   = [rsnext stringForColumn:@"Sub_D"];
                thisSub.Sub_Right           = [rsnext stringForColumn:@"Sub_Right"];
                thisSub.Sub_Analyse        = [rsnext stringForColumn:@"Sub_Analyse"];
                
                [dataArray addObject:thisSub];
                    }
                
           }
            }
        }
}

-(void)tipBtnDidClick:(UIButton *)sender
{
    //------增加数据
    
    if (sender.selected)
    {
        sender.selected = NO;
        NSArray *temp1 = @[@(1),@(PGnum+1)];
        [loadExamDB updateTable:@"SubType_Fast_Temp" SetName:@"Sub_Mark" WhereName:@"Sub_Num" UserValue:temp1];

    }
    else
        {
        sender.selected = YES;
        NSArray *temp1 = @[@(0),@(PGnum+1)];
        [loadExamDB updateTable:@"SubType_Fast_Temp" SetName:@"Sub_Mark" WhereName:@"Sub_Num" UserValue:temp1];

        }
}
//------生成不重复的随机数
-(NSMutableArray *)randomSub:(int)size
{
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 1; i<size+1; i++) {
        [temp addObject:[NSNumber numberWithInt:i]];
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:temp];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    int i;
    int count = temp.count;
  
    for (i = 0; i < count; i ++) {
        int index = arc4random() % (count - i);
        [resultArray addObject:[tempArray objectAtIndex:index]];
        [tempArray removeObjectAtIndex:index];
    }
   
    return resultArray;
}

//int mTime;
//
//- (void)StartTimer
//{
//    //repeats设为YES时每次 invalidate后重新执行，如果为NO，逻辑执行完后计时器无效
//    mTime = 0;
//    NSLog(@"StartTimer");
//    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerd:) userInfo:nil repeats:YES];
//   
//    
//}
//
//- (void)timerd:(NSTimer *)time//这个函数将会执行一个循环的逻辑
//{
//    //加一个计数器
//  
//    //    if (mTime == 0)
//    //        {
//    //        [timerA invalidate];
//    //        [self StartTimer];
//    //        }
//    mTime++;
//    self.timeLb.text = [NSString stringWithFormat:@"%d 秒",mTime];
//    
//}

-(void)loadView
{
    [super loadView];
   
//    //------创建表
//    [loadExamDB createTable:@"SubType_Fast_Temp" withArguments:@"Sub_Num int,Sub_Mark int,Sub_Choosed int,Sub_Choose_Right text"];

    if (!Exam_isFirstLoad)
    {
        NSLog(@"first");
        [self addPictrue:[UIImage imageNamed:@"zhishi3.png"]];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:true forKey:@"ExamFirst"];
    //------创建表
    [loadExamDB createTable:@"SubType_Fast_Temp" withArguments:@"Sub_Num int,Sub_Mark int,Sub_Choosed int,Sub_Choose_Right text"];
    }
}
//------首次启动显示
-(void)addPictrue:(UIImage *)image
{
    self.topImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    _topImgV.image = image;
    
    
    _topImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
    
    [_topImgV addGestureRecognizer:singleTap];
    [self.view addSubview:_topImgV];
}

- (void)UesrClicked:(UIGestureRecognizer *)gestureRecognizer {
    
    //do something....
    [self.topImgV setHidden:YES];
   
    
}

-(void)backBtnDidClick:(id)sender
{
    ////// Question
    
   GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"提醒"
                                       message:@"你还有未做完的题,需要保存吗?"
                                      delegate:self
                             cancelButtonTitle:@"取消继续"
                             otherButtonTitles:@"保存退出", nil];
    alert.style = GRAlertStyleInfo;
   
    [alert show];
    //        [alert setImage:@"help.png"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button pushed: %@, index %i", alertView.title, buttonIndex);
    if (buttonIndex == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:true forKey:@"saveProgress"];
        [defaults synchronize];
        
        HomeViewController *homeV = [[HomeViewController alloc]init];
        [self presentViewController:homeV animated:YES completion:^{
            NSLog(@"关闭练习页面------回调");//这里打个断点，点击按钮模态视图移除后会回到这里
            if (timer.isValid) {
                //关闭定时器
                [timer invalidate];
            }
        }];
    }
    
    
}
    
    

#define kTableOffset @"kTableOffset"
#define viewAppear @"viewAppear"
//------把NSUer改成数据库



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
    }];  }

//------生成cell内容
- (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
{
    
    NSInteger row = [indexPath row];
    SubType_Fast *cellData = [dataArray objectAtIndex:indexPath.page];
    NSLog(@"page == %d",indexPath.page);
    
        NSString *stringInt = [NSString stringWithFormat:@"%d",indexPath.page+1];
    static NSString  *CellIdentifier = @"CellIdentifier";
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell ;
    
    if (row == 0)
        {
        cell = (UITableViewCell*)[panelView.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
            {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //            cell.textLabel.textColor = [UIColor colorWithRGB:0x3a3a3a];
            //  自定义图片
            UILabel  *imageView=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 143, 42)];
            imageView.tag = 11;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.font = [UIFont systemFontOfSize:14.0];
            
            
            //  自定义主标题
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 5, 30, 42)];
            titleLabel.tag = 12;
            titleLabel.numberOfLines = 1;
            titleLabel.backgroundColor = [UIColor clearColor];
            //            titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
            titleLabel.font = [UIFont systemFontOfSize:18.0];
            
            
            titleLabel.textColor = UIColorFromRGB(0x2C7CFF);
            
            //  自定义副标题
            UILabel *title2Label = [[UILabel alloc]initWithFrame:CGRectMake(275, 5, 30, 42)];
            title2Label.tag = 13;
            title2Label.backgroundColor = [UIColor clearColor];
            title2Label.numberOfLines = 1;
            title2Label.font = [UIFont systemFontOfSize:14.0];
            
            UILabel *textView = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 300, 180)];
            textView.tag = 14;
            textView.backgroundColor = [UIColor clearColor];
            textView.numberOfLines = 7;
            textView.font = [UIFont fontWithName:@"Airal" size:10.0];
            
            
            //  加载到cell视图
            [cell.contentView addSubview:textView];
            [cell.contentView addSubview:imageView];
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:title2Label];
            
            }
        //  设置大标题
        UILabel *imageview = (UILabel *)[cell.contentView viewWithTag:11];
        
        imageview.text = cellData.Sub_Name;
        
        
        
        //设置数字
        UILabel *titlelabel = (UILabel *)[cell.contentView viewWithTag:12];
        titlelabel.text = stringInt;
        
        
        //设置15
        UILabel *title2label = (UILabel *)[cell.contentView viewWithTag:13];
        title2label.text = @"| 15";
        
        
        UILabel *text2View = (UILabel*)[cell.contentView viewWithTag:14];
        text2View.text = cellData.Sub_Title;
        }
    //cell.textLabel.text = [_worldArray objectAtIndex:section];
    //cell.textLabel.adjustsFontSizeToFitWidth = YES;
    else {
        
        cell = (UITableViewCell*)[panelView.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.contentView.backgroundColor = [UIColor clearColor];
            //            cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
            UIImageView  *imageViews=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 21, 21)];
            imageViews.tag = 21;
            
            UILabel  *txtView=[[UILabel alloc] initWithFrame:CGRectMake(40, 5, 240, 40)];
            txtView.numberOfLines = 2;
            txtView.font = [UIFont fontWithName:@"Airal" size:14.0];
            txtView.tag = 22;
            
            [cell.contentView addSubview:txtView];
            [cell.contentView addSubview:imageViews];
        }
        //  设置image图片
        UIImageView *imageviewss = (UIImageView *)[cell.contentView viewWithTag:21];
        
        
        //  设置选项内容
        UILabel *txt2View = (UILabel *)[cell.contentView viewWithTag:22];
        txt2View.textColor = [UIColor grayColor];
        
        
        switch (row) {
            case 1:
                imageviewss.image = [UIImage imageNamed:@"A.png"];
                txt2View.text = cellData.Sub_A;
                break;
            case 2:
                imageviewss.image = [UIImage imageNamed:@"B.png"];
                txt2View.text = cellData.Sub_B;
                break;
            case 3:
                imageviewss.image = [UIImage imageNamed:@"C.png"];
                txt2View.text = cellData.Sub_C;
                break;
            case 4:
                imageviewss.image = [UIImage imageNamed:@"D.png"];
                txt2View.text = cellData.Sub_D;
                break;
            default:
                break;
        }
        
        
    }
    return cell;
    
}

/**
 *
 * - (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath
 * similar to - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(IndexPath *)indexPath
 *
 */
#define kTableSelected @"kTableSelected"
- (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath
{
//	NSLog(@"indexPath.page = %d,indexPath.row = %d,indexPath.section = %d",indexPath.page,indexPath.row,indexPath.section);
//    
  
    PGnum = indexPath.page+1; //num  ==  1-15
    
   
    if (indexPath.row == 0)//第一行 题目那一栏
    {
        
//         self.panelsArray = [[NSUserDefaults standardUserDefaults] objectForKey:kTableOffset];
//        int y = [[self.panelsArray objectAtIndex:indexPath.page] intValue];
       
         [panelView pageWillAppear];//------防止点击选中状态丢失
        return;
    }
    if (PGnum == 15)
    {//------如果到了最后一题
        //------保存点击值
         [self saveTableviewOffset:indexPath.row];
//        //------读取全部 点击的值
//        self.panelsArray = [[NSUserDefaults standardUserDefaults] objectForKey:kTableOffset];
        resultViewController *result = [[resultViewController alloc]initWithNibName:@"resultViewController" bundle:nil];
        [self presentViewController:result animated:YES completion:^{
            NSLog(@"15 打开答题卡页面------回调 %@", self.timeLb.text);
        }];
    }
    else
        {
        //------偏移到下一个页面
        [self.scrollView setContentOffset:CGPointMake(([self panelViewSize].width+2*GAP)*PGnum,0) animated:YES];
        //------保存点击值
        [self saveTableviewOffset:indexPath.row];
        }
}

//------重写 panelview中的方法 保存选择状态
- (void)saveTableviewOffset:(int)index
{
//	self.panelsArray = [[[NSUserDefaults standardUserDefaults] objectForKey:kTableOffset] mutableCopy];
//    [self.panelsArray replaceObjectAtIndex:PGnum-1 withObject:[NSNumber numberWithInt:index]];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	[defaults setObject:self.panelsArray forKey:kTableOffset];
//    [defaults synchronize];
    
    
    //------写数据库
    //------增加数据
    NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM SubType_Fast_Temp WHERE Sub_Num='%d'",PGnum];
    //查询数据
    FMResultSet *rs= [loadExamDB findinTable:sqlstring];
    if ([rs next])
    {
        NSArray *temp1 = @[@(index),@(PGnum)];
        [loadExamDB updateTable:@"SubType_Fast_Temp" SetName:@"Sub_Choosed" WhereName:@"Sub_Num" UserValue:temp1];
    }else
        {
        SubType_Fast *cellData = [dataArray objectAtIndex:PGnum-1];
        NSArray *temp2 = @[@(PGnum),@(0),@(index),cellData.Sub_Right];
    [loadExamDB insertTable:@"SubType_Fast_Temp" Where:@"Sub_Num,Sub_Mark,Sub_Choosed,Sub_Choose_Right" Values:temp2 Num:@"?,?,?,?"];
        }
}

- (NSInteger)numberOfPanels
{
	
    return 15;
}
- (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
{
	return 5;
}
- (NSInteger)panelView:(id)panelView numberOfSectionsInPage:(NSInteger)pageNumber
{
    return 1;
}

    @end
