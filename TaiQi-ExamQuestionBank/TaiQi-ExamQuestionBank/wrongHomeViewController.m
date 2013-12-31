//
//  wrongHomeViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-3.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "wrongHomeViewController.h"
#import "answerViewController.h"
#import "BaseExamViewController.h"
#import "WrongDataClass.h"
@interface wrongHomeViewController ()

@end

@implementation wrongHomeViewController
@synthesize wrongTV;
@synthesize topLB;
@synthesize botLB;
@synthesize topV;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        Exam_isSave = [ud boolForKey:@"SubType_Fast"];
        Special_isSave = [ud boolForKey:@"SubType_Special"];
        Real_isSave = [ud boolForKey:@"SubType_Real"];
        history_Space =[History_Space new];
    }
    return self;
}

#pragma mark -
#pragma 初始化错题空间数据
-(void)initWrongHomeData
{
    total = 0;
    rightcount = 0;
    dataArray = [NSMutableArray new];//存放的是从历史记录中读出的数据
    reversedArray = [NSArray new];//数据按先后顺序排序
    NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM History_Space"];//从历史记录的表中 查找数据
    //查询数据
    FMResultSet *rs= [loadWrongDB findinTable:sqlstring];
    while ([rs next])
        {
        thisHistory = [History_Space new];
        thisHistory.History_Type = [rs stringForColumn:@"History_Type"];
        thisHistory.History_Name = [rs stringForColumn:@"History_Name"];
        thisHistory.History_Table = [rs stringForColumn:@"History_Table"];
        thisHistory.History_Serial = [rs stringForColumn:@"History_Serial"];
        thisHistory.History_Choosed = [rs stringForColumn:@"History_Choosed"];
        thisHistory.History_Right = [rs stringForColumn:@"History_Right"];
        thisHistory.History_Mark = [rs stringForColumn:@"History_Mark"];
        thisHistory.History_Time = [rs stringForColumn:@"History_Time"];
        thisHistory.History_Total =   [rs intForColumn:@"History_Total"];
        total += thisHistory.History_Total;
        thisHistory.History_RightNum =  [rs intForColumn:@"History_RightNum"];
        rightcount += thisHistory.History_RightNum;
        thisHistory.History_UseTime =  [NSNumber numberWithInt:[[rs stringForColumn:@"History_UseTime"] intValue]];
        [dataArray addObject:thisHistory];
        }
    
    reversedArray = [[dataArray reverseObjectEnumerator] allObjects]; //从后向前排序
    HistoryArray = [[NSMutableArray alloc]initWithArray:reversedArray];
    //--------刷新数据
    topLB.text = [NSString stringWithFormat:@"%d",total];
    botLB.text = [NSString stringWithFormat:@"%d",(total - rightcount)];
    [self.wrongTV reloadData];
}
#pragma mark -
#pragma mark 加载左右两个按钮视图
-(void)loadView
{
    [super loadView];
    //------练习历史按钮
    self.leftBtn.frame = CGRectMake(150, 13, 77, 37);
    [ self.leftBtn setImage:[UIImage imageNamed:@"lianxilishi(1).png"] forState:UIControlStateNormal];
    [ self.leftBtn setImage:[UIImage imageNamed:@"lianxilishi(2).png"] forState:UIControlStateHighlighted];
    [ self.leftBtn setImage:[UIImage imageNamed:@"lianxilishi(2).png"] forState:UIControlStateSelected];
    [ self.leftBtn addTarget:self action:@selector(leftBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    //-------错题中心按钮
    self.rightBtn.frame = CGRectMake(232, 13, 77, 37);
    [self.rightBtn setImage:[UIImage imageNamed:@"cuotizhongxin(1).png"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"cuotizhongxin(2).png"] forState:UIControlStateHighlighted];
    [self.rightBtn setImage:[UIImage imageNamed:@"cuotizhongxin(2).png"] forState:UIControlStateSelected];
    [self.rightBtn addTarget:self action:@selector(rightBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    //--------默认选中错题中心按钮
    [self.rightBtn setSelected:YES];
    
    
}
#pragma mark 加载头部视图
-(void)loadTopView
{
    //--------你总共练习了
    self.topV = [[UIView alloc]initWithFrame:CGRectMake(0, 59, 320, 40)];
    UILabel *firstLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    firstLB.backgroundColor = [UIColor clearColor];
    firstLB.text = @"你总共练习了";
    firstLB.font = [UIFont systemFontOfSize:14];
    //--------100
    self.topLB = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 40, 20)];
    topLB.textColor = [UIColor greenColor];
    topLB.textAlignment = 1;
    topLB.backgroundColor = [UIColor clearColor];
    topLB.text = [NSString stringWithFormat:@"%d",total];
    topLB.font = [UIFont systemFontOfSize:14];
    //--------道题,其中有
    UILabel *secondLB = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 100, 20)];
    secondLB.text = @"道题,其中有";
    secondLB.font = [UIFont systemFontOfSize:14];
    //--------10
    self.botLB = [[UILabel alloc]initWithFrame:CGRectMake(195, 10, 50, 20)];
    botLB.backgroundColor = [UIColor clearColor];
    botLB.textColor = [UIColor redColor];
    botLB.textAlignment = 1;
    botLB.backgroundColor = [UIColor clearColor];
    botLB.text = [NSString stringWithFormat:@"%d",(total - rightcount)];
    botLB.font = [UIFont systemFontOfSize:14];
    //--------道错题
    UILabel *thirdLB = [[UILabel alloc]initWithFrame:CGRectMake(240, 10, 100, 20)];
    thirdLB.backgroundColor = [UIColor clearColor];
    thirdLB.text = @"道错题";
    thirdLB.font = [UIFont systemFontOfSize:14];
    
    [topV addSubview:firstLB];
    [topV addSubview:topLB];
    [topV addSubview:secondLB];
    [topV addSubview:botLB];
    [topV addSubview:thirdLB];
    
    [self.view addSubview:topV];
}
#pragma mark viewDidLoad 加载数据
- (void)viewDidLoad
{
    [super viewDidLoad];
    loadWrongDB  = [[myDB alloc]initWithDBName:@"ExamQuestionBank.db"];//加载数据库
    [self initWrongHomeData];//初始化数据
    [self loadTopView];
}
#pragma mark 自定义tableview 风格
-(void)loadTableView:(UITableView *)thetableView TableViewStyle:(UITableViewStyle )style
{
    self.wrongTV = thetableView;
    wrongTV = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 59.0, self.view.width, self.view.height-59.0) style:UITableViewStyleGrouped];
    wrongTV.rowHeight = 40.0;
    wrongTV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    wrongTV.backgroundColor = [UIColor clearColor];
    wrongTV.scrollEnabled = YES;
    wrongTV.backgroundView = nil;
    wrongTV.dataSource = self;
    wrongTV.delegate = self;
    [self.view addSubview:wrongTV];
}
#pragma mark -
#pragma mark 练习历史 和 错题中心 按钮点击
-(void)leftBtnDidClick:(UIButton *)sender
{
    
    if (sender.selected) {
    }
    else
        {
        sender.selected = YES;
        [self.rightBtn setSelected:NO];
        [self.topV setHidden:YES];
        [self   initWrongHomeData];
        }
    
    
}
-(void)rightBtnDidClick:(UIButton *)sender
{
    
    if (sender.selected)
        {
        }
    else
        {
        sender.selected = YES;
        [self.leftBtn setSelected:NO];
        [self.topV setHidden:NO];
        [self initWrongHomeData];
        }
    
}
#pragma mark -
#pragma mark tableview 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.rightBtn.selected) {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.rightBtn.isSelected) {
        
        if (section == 1) {
            return 3;
        }
        return 1;
    }
    return [HistoryArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.rightBtn.selected) {
        if (section == 0) {
            return 70;
        }
        return 30;
    }
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.rightBtn.selected) {
        if (section == 0) {
            return @"练习错题";
        }
        else
            {
            return @"浏览错题解析";
            }
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    //    NSString *value = [self.listOfMovies objectAtIndex:row];
    static NSString  *CellIdentifier = @"CellIdentifier";
    static NSString  *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell;
    if (self.rightBtn.selected) {
        
        if (cell == nil)
            {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            }
        
        if (section == 0) {
            cell.textLabel.text = @"智能练习15道错题";
        }
        else
            {
            switch (row) {
                case 0:
                {
                cell.textLabel.text = @"智能练习";
                cell.detailTextLabel.text = @"15道错题";
                }
                    break;
                case 1:
                {
                cell.textLabel.text = @"英语专项练习";
                cell.detailTextLabel.text = @"10道错题";
                }
                    break;
                case 2:
                {
                cell.textLabel.text = @"模拟考试试卷";
                cell.detailTextLabel.text = @"10道错题";
                }
                    break;
                default:
                    break;
            }
            }
    }
    else
        {
        if (cell == nil)
            {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            }
        History_Space *history =[History_Space new];
        
        history = [HistoryArray objectAtIndex:row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@-%@", history.History_Type,history.History_Name];//类型名
        
        NSString *detail = [NSString stringWithFormat:@"%@  共%d题, 做对%d道",history.History_Time,history.History_Total,history.History_RightNum];
        
        cell.detailTextLabel.text = detail;//细节名
        
        }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (HistoryArray.count > 0) {
        
        if (self.rightBtn.selected)
            {
            if (indexPath.section == 0 && indexPath.row == 0) {
                if ((total-rightcount) >= 15) {
                    mutableDictionary = [[NSMutableArray alloc] initWithCapacity:15];;
                    NSString *sqlstring = @"SELECT * FROM Wrong_Space ORDER BY RANDOM() limit 15";
                    FMResultSet *rs= [loadWrongDB findinTable:sqlstring];
                    while ([rs next])
                        {
                        WrongDataClass *wrongClass = [[WrongDataClass alloc]init];
                        
                        wrongClass.tableStr                 = [rs stringForColumn:@"Wrong_Table"];
                        wrongClass.tableIndex             =[rs intForColumn:@"Wrong_Num"];
                        
                        [mutableDictionary addObject:wrongClass];
                        }
                    [self showAlertView];
                }
                else {
                    //-------提示小余15道题
                    [[CommClass sharedInstance] showMBdailog:@"错题不够15道呢..." inView:self.view];
                }
            }
            }
        else
            {
            history_Space = [HistoryArray objectAtIndex:row];
            answerViewController *answerVC = [[answerViewController alloc]initWithIndex:1 Data:history_Space.History_Time Wrong:NO];
            [answerVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:answerVC animated:YES completion:^{
                NSLog(@"中心打开结果------回调");
            }];
            }
    } else {
        //-------提示没有记录
        [[CommClass sharedInstance] showMBdailog:@"没有找到记录..." inView:self.view];
    }
    
    
}

#pragma mark 滑动删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.leftBtn.selected) {
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        History_Space *athisHistory = [History_Space new];
        athisHistory = [HistoryArray objectAtIndex:indexPath.row];
        [loadWrongDB deleteTableValue:@"History_Space" Where:@"History_Time" IS:[NSString stringWithFormat:@"\'%@\'",athisHistory.History_Time] And:NO Where2:nil IS2:nil];
        [loadWrongDB deleteTableValue:@"Wrong_Space" Where:@"Wrong_Time" IS:[NSString stringWithFormat:@"\'%@\'",athisHistory.History_Time] And:NO Where2:nil IS2:nil];
        
        [HistoryArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [self.wrongTV deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"移除";
}
#pragma mark -
#pragma mark 弹出对话框
-(void)showAlertView
{
    alert = [[GRAlertView alloc] initWithTitle:@"您准备好了吗?"
                                       message:@"请选择您的操作"
                                      delegate:self
                             cancelButtonTitle:@"我再看看"
                             otherButtonTitles:@"马上开始",
             nil];
    
    alert.style = GRAlertStyleInfo2;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //------准备好了
    if (buttonIndex == 1)
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
        //如果没有保存进度 就直接进去
        else
            {
            BaseExamViewController *cuotiView = [[BaseExamViewController alloc]
                                                 initViewWithTableDictionary:mutableDictionary
                                                 AndTitle:@"错题智能练习"];
            [self presentViewController:cuotiView animated:YES completion:^{
            }];
            }
        
        }
    //------我点错了
    else
        {
        stillnext = NO;
        return;
        }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
