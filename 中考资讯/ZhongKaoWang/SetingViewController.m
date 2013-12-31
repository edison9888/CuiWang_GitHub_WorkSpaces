//
//  SetingViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-12-2.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "SetingViewController.h"
#import "AppDelegate.h"
#import "FeedBackViewController.h"
#import "surveyViewController.h"
@interface SetingViewController ()

@end

@implementation SetingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.t.text = @"设置";
        tabArray = @[@"清除缓存",@"意见反馈",@"检查更新",@"给我评分",];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.myTableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellide = @"myCell";
    int row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellide];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellide];
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(260, 5, 50, 20)];
        [switchButton setOn:YES];
        switchButton.tag = 100+row;
        switchButton.hidden = YES;
//        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchButton];
    }
//    if (row < 4) {
//        UISwitch *switchButton = (UISwitch *)[cell.contentView viewWithTag:100+row];
//        switchButton.hidden = NO;
//    }
    
    if (row == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.3f M",[UIUtils fileSizeForDir:@"MyCache"] / 1024 / 2014];
    }
    
    if (row > 0 && row < 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (row == 2) {
            cell.detailTextLabel.text = @"当前版本1.1";
        }
    }
    cell.textLabel.text = [tabArray objectAtIndex:row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
        [CW_Tools ToastNotification:@"清理中..." andView:self.myTableView andLoading:YES andIsBottom:NO doSomething:^{
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate.asiCache clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [CW_Tools ToastViewInView:self.myTableView withText:@"清除完毕!"];
            [self.myTableView reloadData];
            [[NSNotificationCenter defaultCenter]
             
             postNotificationName:@"clearedCache" object:nil];
        }];
        }
            break;
        case 1:
        {
        FeedBackViewController *feedBack = [FeedBackViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:feedBack];
        [self presentViewController:nav animated:YES completion:^{
            //        <#code#>
        }];
        }
            break;
        case 2:
        {
        [CW_Tools ToastViewInView:self.view withText:@"  已经是最新版本!  "];
        }
            break;
            /*
        case 3:
        {
       //
        surveyViewController *surveyVC = [surveyViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:surveyVC];
        [self presentViewController:nav animated:YES completion:^{
            //
        }];
        }
            break;
            */
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
