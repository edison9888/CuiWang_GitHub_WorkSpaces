//
//  assessViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-2.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "assessViewController.h"
#import "UIExpandableTableView.h"
#import "History_Space.h"
#import "GHCollapsingAndSpinningTableViewCell.h"
#import <AGCommon/UIView+Common.h>
#define kUITableExpandableSection       1
@interface assessViewController ()

@end

@implementation assessViewController
@synthesize mDate;
@synthesize assTV;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        loadAssessDB = [[myDB alloc]initWithDBName:@"ExamQuestionBank.db"];
        [self initassessData];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    self.titleLB.text = @"能力评估报告";
    
//    self.theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, 320, 200) style:UITableViewStylePlain];
    }
-(void)initassessData
{
    dataMutableArray = [NSMutableArray new];
  
    NSString *sqlstring = [NSString stringWithFormat:@"SELECT History_Type,SUM(History_Total) FROM History_Space GROUP BY History_Type"];
    NSString *sqlstring2 = [NSString stringWithFormat:@"SELECT History_Type,SUM(History_RightNum) FROM History_Space GROUP BY History_Type"];
    NSLog(@"%@",sqlstring);
    //查询数据
    //        NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    FMResultSet *rs= [loadAssessDB findinTable:sqlstring];
    totalDic = [[NSMutableDictionary alloc]init];
    rightDic = [[NSMutableDictionary alloc]init];
    while ([rs next])
        {
        NSString * tempInt = [rs.resultDictionary objectForKey:@"SUM(History_Total)"];
        NSString *tempString = [rs.resultDictionary objectForKey:@"History_Type"];
     
        [totalDic setValue:tempInt forKey:tempString];
        }
    FMResultSet *rs2= [loadAssessDB findinTable:sqlstring2];
    while ([rs2 next])
        {
        NSString * tempInt = [rs2.resultDictionary objectForKey:@"SUM(History_RightNum)"];
        NSString *tempString = [rs2.resultDictionary objectForKey:@"History_Type"];
     
        [rightDic setValue:tempInt forKey:tempString];
        }
    
    
    //--------------------------
    NSString *sqlstring3 = [NSString stringWithFormat:@"SELECT History_Type,History_Name,SUM(History_Total) FROM History_Space GROUP BY History_Name"];
    NSLog(@"%@",sqlstring3);
    NSString *sqlstring4 = [NSString stringWithFormat:@"SELECT History_Type,History_Name,SUM(History_RightNum) FROM History_Space GROUP BY History_Name"];
    NSLog(@"%@",sqlstring4);
    //查询数据
    FMResultSet *rs3= [loadAssessDB findinTable:sqlstring3];
    mainArray = [[NSMutableArray alloc]initWithCapacity:15];
    while ([rs3 next])
        {
        NSDictionary *sonDic = [[NSMutableDictionary alloc]init];
        NSDictionary *fatherDic = [[NSMutableDictionary alloc]init];
        [sonDic setValue:[rs3.resultDictionary objectForKey:@"SUM(History_Total)"] forKey:[rs3.resultDictionary objectForKey:@"History_Name"]];
        [fatherDic setValue:sonDic forKey:[rs3.resultDictionary objectForKey:@"History_Type"]];
        [mainArray addObject:fatherDic];
        }
    
    NSArray *thisArray = [totalDic allKeys];
    thisDiction = [NSMutableDictionary new];
    for (NSString *ss in thisArray)
        {
        NSMutableArray *temArr = [NSMutableArray new];
        for(NSDictionary *d in mainArray)
            {
            
            if([d objectForKey:ss])
                {
                [temArr addObject:[d objectForKey:ss]];
                }
            }
        [thisDiction setValue:temArr forKey:ss];
        }
    //-------------------
    //查询数据
    FMResultSet *rs4= [loadAssessDB findinTable:sqlstring4];
    mainValueArray = [[NSMutableArray alloc]initWithCapacity:15];
    while ([rs4 next])
        {
        NSDictionary *sonDic = [[NSMutableDictionary alloc]init];
        NSDictionary *fatherDic = [[NSMutableDictionary alloc]init];
        [sonDic setValue:[rs4.resultDictionary objectForKey:@"SUM(History_RightNum)"] forKey:[rs4.resultDictionary objectForKey:@"History_Name"]];
        [fatherDic setValue:sonDic forKey:[rs4.resultDictionary objectForKey:@"History_Type"]];
        [mainValueArray addObject:fatherDic];
        }
    NSArray *thisArray2 = [totalDic allKeys];
    thisValueDiction = [NSMutableDictionary new];
    for (NSString *ss in thisArray2)
        {
        NSMutableArray *temArr = [NSMutableArray new];
        for(NSDictionary *d in mainValueArray)
            {
            
            if([d objectForKey:ss])
                {
                [temArr addObject:[d objectForKey:ss]];
                }
            }
        [thisValueDiction setValue:temArr forKey:ss];
        }
    //-------------------
}
-(void)loadTableView:(UITableView *)thetableView TableViewStyle:(UITableViewStyle )style
{
    self.assTV = thetableView;
    self.assTV = [[UIExpandableTableView alloc] initWithFrame:CGRectMake(0.0f, 59.0, self.view.width, self.view.height-59.0) style:UITableViewStylePlain];
    assTV.rowHeight = 40.0;
    //    thetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    assTV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    assTV.backgroundColor = [UIColor clearColor];
    assTV.scrollEnabled = YES;
    assTV.backgroundView = nil;
    assTV.dataSource = self;
    assTV.delegate = self;
    [self.view addSubview:assTV];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY年MM月dd日 hh:mm:ss"];
    self.mDate = [formatter stringFromDate:[NSDate date]];
	// Do any additional setup after loading the view.
}
- (BOOL)tableView:(UIExpandableTableView *)tableView canExpandSection:(NSInteger)section {
    // return YES, if the section should be expandable
    return section != 0;
}

- (BOOL)tableView:(UIExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section {
    // return YES, if you need to download data to expand this section. tableView will call tableView:downloadDataForExpandableSection: for this section
    return !_didDownloadData;
}
#pragma mark - UIExpandableTableViewDelegate

- (void)tableView:(UIExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section {
    // download your data here
    
    double delayInSeconds = .5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        // save your state, that you did download the data
        _didDownloadData = YES;
        
        
//        NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM History_Space WHERE History_Type = '%@'",[realtypearray objectAtIndex:section-1]];
        
        
            
       
        //        NSArray *testarr = [[fatherDic objectForKey:@"语文专项"] allKeys];
//        NSLog(@"%d",[testarr count]);
//        
//        NSLog(@"%@",[[testarr objectAtIndex:0] stringValue]);
//        NSString *tmpSS = @"0";
//        
//        NSDictionary *thisDic = [[NSDictionary alloc]init];
//        
//        for (int i = 0; i < [typeArray count]; i++)
//        {
//            NSString *typeSS = typeArray[i];
//            NSLog(@"typeSS == %@",typeSS);
//            if (![tmpSS isEqualToString:typeSS])//如果连续两条记录不相等
//            {
//            [thisDic setValue:[totalArray objectAtIndex:i] forKey:[nameArray objectAtIndex:i]];
//            [FatherDic setValue:thisDic forKey:typeSS];
//            tmpSS = typeSS;
//            }
//            
//        }
       
        
        // call [tableView cancelDownloadInSection:section]; if your download failed
        // and expand this section after download completed
        [tableView expandSection:section animated:YES];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [totalDic count]+1;
}
- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(UIExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
{
    NSString *CellIdientifier = @"GHCollapsingAndSpinningTableViewCell";
    
    GHCollapsingAndSpinningTableViewCell *cell = (GHCollapsingAndSpinningTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdientifier];
    
    if (cell == nil)
        {
        cell = [[GHCollapsingAndSpinningTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdientifier];
        UILabel *upLB = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 200, 20)];
        upLB.tag = 1;
        UILabel *downLB = [[UILabel alloc]initWithFrame:CGRectMake(40, 30, 260, 20)];
        downLB.tag = 2;
        
        [cell.contentView addSubview:upLB];
        [cell.contentView addSubview:downLB];
        
        }
    
    UILabel *thisUpLB = (UILabel *)[cell.contentView viewWithTag:1];
    thisUpLB.font = [UIFont systemFontOfSize:16];
    
    UILabel *thisDownLB = (UILabel *)[cell.contentView viewWithTag:2];
    thisDownLB.font = [UIFont systemFontOfSize:12];
  
    
    thisUpLB.text = [[totalDic allKeys] objectAtIndex:section -1];
    int totalnum = [[[totalDic allValues] objectAtIndex:section -1] intValue];
    float rightnum = [[[rightDic allValues] objectAtIndex:section -1] intValue];
    float per = rightnum/totalnum;
    NSString *detail1 = [NSString stringWithFormat:@"题目数量:  %d  |  正确率:  %.2f%%",totalnum,per*100];
    thisDownLB.text = detail1;
 
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 0;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 0) {
//        return 40;
//    }
//    return 50;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section ==[totalDic count]) {
        return 1;
    }
    return 0.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
        {
        NSArray *tee = [thisDiction objectForKey:[[totalDic allKeys] objectAtIndex:section-1]];
        return [tee count]+1;
        }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    //    NSInteger section = [indexPath section];
    
//    NSInteger row = [indexPath row];
   
    static NSString  *CellIdentifier = @"CellIdentifier";
    static NSString  *cellIdentifier = @"cellIdentifier";
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    UITableViewCell *cell;
   
    // Configure the cell...
    if (indexPath.section == 0) {
         if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.textLabel.textColor = [UIColor colorWithRGB:0x3a3a3a];
        UILabel *lfLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        lfLB.font = [UIFont systemFontOfSize:14.0];
        lfLB.text = @"报告生成时间:";
        lfLB.tag = 1;
        
        UILabel *rtLB = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 190, 20)];
        rtLB.textAlignment = NSTextAlignmentLeft;
        rtLB.font = [UIFont systemFontOfSize:14.0];
        rtLB.text = self.mDate;
        rtLB.tag = 2;
        
        [cell.contentView addSubview:lfLB];
        [cell.contentView addSubview:rtLB];
         }
    }
    else
        {
        NSArray *tee = [thisDiction objectForKey:[[totalDic allKeys] objectAtIndex:indexPath.section-1]];
        NSArray *teeValue = [thisValueDiction objectForKey:[[totalDic allKeys] objectAtIndex:indexPath.section-1]];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cell.backgroundView = backgroundView;
            cell.textLabel.backgroundColor = [UIColor clearColor];
        }
   
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //----辅助按钮 ">"
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        
        NSDictionary *testdic = [tee objectAtIndex:indexPath.row-1];
        NSDictionary *testdicValue = [teeValue objectAtIndex:indexPath.row-1];
        NSString *ttt = [[testdic allKeys]objectAtIndex:0];//-----小 主标题
        float valueint2 = [[[testdicValue allValues]objectAtIndex:0] intValue];//答对数
        int valueint = [[[testdic allValues]objectAtIndex:0] intValue];//总数
         float per = valueint2/valueint;
        cell.textLabel.text = ttt;     // use -1 here, because the expanding cell is always at row 0
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        NSString *detail = [NSString stringWithFormat:@"题目数量:  %d  |  正确率:  %.2f%%",valueint,per*100];
        cell.detailTextLabel.text = detail;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    
        }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    ExamViewController *exam = [[ExamViewController alloc]init];
    //    [self presentViewController:exam animated:YES completion:^{
    //        NSLog(@"打开习题页面------回调");
    //    }];
       
}


@end
