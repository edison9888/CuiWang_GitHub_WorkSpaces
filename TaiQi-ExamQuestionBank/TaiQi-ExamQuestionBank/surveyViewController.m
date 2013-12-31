//
//  surveyViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-3.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "surveyViewController.h"
#import "GRAlertView.h"
#import <AGCommon/UIView+Common.h>
@interface surveyViewController ()

@end

@implementation surveyViewController
@synthesize surveyTV;
@synthesize lastIndexPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    [self.maskBtn setImage:[UIImage imageNamed:@"zhuce_1.png"] forState:UIControlStateNormal];
    [self.maskBtn setImage:[UIImage imageNamed:@"zhuce_2.png"] forState:UIControlStateHighlighted];
    self.titleLB.text = @"满意度调查";
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(286, 11, 24, 37);
    [commitBtn setImage:[UIImage imageNamed:@"manyidudiaocha_2.png"] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    
    
}

-(void)commit
{
    NSString *message =  @"真诚的感谢您的配合.";
    GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"不客气", nil];
    
    [alert setTopColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.5]
           middleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.5]
           bottomColor:[UIColor colorWithRed:0.4 green:0 blue:0 alpha:.1]
             lineColor:[UIColor colorWithRed:0.3 green:0.5 blue:0.7 alpha:1]];
    
    [alert setFontName:@"Airal"
             fontColor:[UIColor blackColor]
       fontShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"关闭调查页面------回调");//这里打个断点，点击按钮模态视图移除后会回到这里
    }];
}
-(void)maskBtnDidClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"关闭调查页面------回调");//这里打个断点，点击按钮模态视图移除后会回到这里
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)loadTableView:(UITableView *)thetableView TableViewStyle:(UITableViewStyle )style
{
    self.surveyTV = thetableView;
    surveyTV = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 59.0, self.view.width, self.view.height-59.0) style:UITableViewStyleGrouped];
    surveyTV.rowHeight = 40.0;
    //    thetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    surveyTV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    surveyTV.backgroundColor = [UIColor clearColor];
    surveyTV.scrollEnabled = NO;
    surveyTV.backgroundView = nil;
    surveyTV.dataSource = self;
    surveyTV.delegate = self;
    [self.view addSubview:surveyTV];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *aLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 50)];
    aLB.numberOfLines = 2;
    aLB.font = [UIFont systemFontOfSize:13];
    aLB.textAlignment = 1;
    aLB.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    aLB.text = @"  你会向你的朋友推荐太奇题库吗?请用0-10分表示你的推荐意愿吧.其中0 = 非常不愿意,10 = 非常愿意";
    return aLB;
}// custom view for footer. will be adjusted to default or specified footer height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    //    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    static NSString  *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        //       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.textLabel.textColor = [UIColor colorWithRGB:0x3a3a3a];
        UILabel *txt = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
        txt.backgroundColor = [UIColor clearColor];
        txt.tag = 1;
//        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(220, 15, 72, 21)];
//        img.tag = 2;
        [cell.contentView addSubview:txt];
//        [cell.contentView addSubview:img];
        }
    //    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    //    backgrdView.backgroundColor = [UIColor blueColor];
    //    cell.backgroundView = backgrdView;
    UILabel *thisTxt = (UILabel *)[cell.contentView viewWithTag:1];
//    UIImageView *thisImg = (UIImageView *)[cell.contentView viewWithTag:2];
//    thisImg.image = [UIImage imageNamed:@"dianji15dao_1.png"];
    switch (row)
    {
        case 0:thisTxt.text = @"10(非常愿意)";break;
        case 1:thisTxt.text = @"9";break;
        case 2:thisTxt.text = @"8";break;
        case 3:thisTxt.text = @"7";break;
        case 4:thisTxt.text = @"6";break;
        case 5:thisTxt.text = @"5";break;
        case 6:thisTxt.text = @"4";break;
        case 7:thisTxt.text = @"3";break;
        case 8:thisTxt.text = @"2";break;
        case 9:thisTxt.text = @"1";break;
        case 10:thisTxt.text = @"0(非常不愿意)";break;
        default:break;
    }
    
    //cell.textLabel.text = [_worldArray objectAtIndex:section];
    //cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int newRow = [indexPath row];
    
    int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
    
    
    
    if (newRow != oldRow)
        
        {
        
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
                                    
                                    indexPath];
        
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
                                    
                                    lastIndexPath];
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        lastIndexPath = [indexPath copy];//一定要这么写，要不报错
        
        }
    
    
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
