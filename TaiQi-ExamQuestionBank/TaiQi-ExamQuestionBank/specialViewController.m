//
//  specialViewController.m
//  TaiQi-ExamQuestionBank
//  专项智能一级页面
//  Created by cui wang on 13-7-1.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "specialViewController.h"
#import "specialSecondViewController.h"
#import "Special_Table.h"

@interface specialViewController ()

@end

@implementation specialViewController
@synthesize titleLB;
@synthesize sptableView;
#pragma mark -
#pragma mark  初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        nameArray = [[NSMutableArray alloc]initWithCapacity:15];
        typeArray = [[NSMutableArray alloc]initWithCapacity:15];
        
        loadSpecialDB = [[myDB alloc]initWithDBName:@"ExamQuestionBank.db"];
        
        NSString *sqlstring = [NSString stringWithFormat:@"SELECT * FROM %@",@"Special_Table"];
        //查询数据
        FMResultSet *rs= [loadSpecialDB findinTable:sqlstring];
        while ([rs next])
            {
            spTB = [Special_Table new];
            spTB.Special_Type = [rs stringForColumn:@"Special_Type"];
            spTB.Special_Content = [rs stringForColumn:@"Special_Content"];
            spTB.Special_Type_Id = [NSNumber numberWithInt: [[rs stringForColumn:@"Special_Type_Id"] intValue]];
            spTB.Special_Type_Num =[NSNumber numberWithInt: [[rs stringForColumn:@"Special_Type_Num"] intValue]];
            [nameArray addObject:spTB];
            [typeArray addObject:[rs stringForColumn:@"Special_Type"]];
            }
        
      NSSet*  typeSet = [NSSet setWithArray:typeArray];
        typearray =  [typeSet allObjects];
        [loadSpecialDB close];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
    [self.maskBtn setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [self.maskBtn setImage:[UIImage imageNamed:@"home_1.png"] forState:UIControlStateHighlighted];
    
    titleLB = [[UILabel alloc]initWithFrame:CGRectMake(85, 15, 150, 30)];
    titleLB.textAlignment = 1;
    titleLB.text = @"专项智能练习";
    [self.view addSubview:titleLB];
    
//    self._tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 59.0, self.view.width, self.view.height-59.0)
//                                                               style:UITableViewStylePlain];
    
//    [self._tableView setValue:@"UITableViewStylePlain" forKey:@"style"];
//    self.theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 59.0, self.view.width, self.view.height-59.0) style:UITableViewStylePlain];
   
}

-(void)loadTableView:(UITableView *)thetableView TableViewStyle:(UITableViewStyle )style
{
    self.sptableView = thetableView;
    sptableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 59.0, self.view.width, self.view.height-59.0) style:UITableViewStylePlain];
    sptableView.rowHeight = 40.0;
//    thetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    sptableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    sptableView.backgroundColor = [UIColor clearColor];
    sptableView.scrollEnabled = YES;
    sptableView.backgroundView = nil;
    sptableView.dataSource = self;
    sptableView.delegate = self;
    [self.view addSubview:sptableView];
}
-(void)maskBtnDidClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"关闭专项页面------回调");//这里打个断点，点击按钮模态视图移除后会回到这里
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [typearray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
//    Special_Table *cellData = [nameArray objectAtIndex:row];
    static NSString  *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
//       cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.textLabel.textColor = [UIColor colorWithRGB:0x3a3a3a];
        UILabel *txt = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
        txt.tag = 1;
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(220, 15, 72, 21)];
        img.tag = 2;
        [cell.contentView addSubview:txt];
        [cell.contentView addSubview:img];
        }
//    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
//    backgrdView.backgroundColor = [UIColor blueColor];
//    cell.backgroundView = backgrdView;
    UILabel *thisTxt = (UILabel *)[cell.contentView viewWithTag:1];
    UIImageView *thisImg = (UIImageView *)[cell.contentView viewWithTag:2];
    thisImg.image = [UIImage imageNamed:@"dianji15dao_1.png"];
      thisTxt.text =[typearray objectAtIndex:row];
    //cell.textLabel.text = [_worldArray objectAtIndex:section];
    //cell.textLabel.adjustsFontSizeToFitWidth = YES;
  
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      //------传过去类型 如英语专项
    specialSecondViewController *english = [[specialSecondViewController alloc]initWithType:[typearray objectAtIndex:indexPath.row] andIndex:indexPath.row];
        [self presentViewController:english animated:YES completion:^{
            NSLog(@"打开英语专项------回调");
        }];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
