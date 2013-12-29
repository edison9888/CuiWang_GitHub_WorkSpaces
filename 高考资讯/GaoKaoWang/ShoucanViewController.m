//
//  ShoucanViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-12-2.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "ShoucanViewController.h"
#import "ShouCangClass.h"
#import "ContentViewController.h"

@interface ShoucanViewController ()

@end

@implementation ShoucanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.t.text = @"我的收藏";
        ShoucangArray = [[NSMutableArray alloc]initWithCapacity:10];
        //-----初始化数据库
        if (![LoadShoucangDB isTableOK:@"GaoKaoWang.sqlite"]) {
            LoadShoucangDB = [[myDB sharedInstance] initWithDBName:@"GaoKaoWang.sqlite"];
        }
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DLog(@"viewDidAppear");
    [self dataFromDB];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 加载数据
-(void)dataFromDB
{
    
    
    [ShoucangArray removeAllObjects];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM ShouCang_Table"];
    FMResultSet *rs= [LoadShoucangDB findinTable:sqlString];
    
    while ([rs next]) {
        ShouCangClass *sc_obj = [ShouCangClass new];
        sc_obj.SC_Title = [rs stringForColumn:@"SC_Title"];
        sc_obj.SC_Time = [rs stringForColumn:@"SC_Time"];
        sc_obj.SC_Content = [rs stringForColumn:@"SC_Content"];
        [ShoucangArray addObject:sc_obj];
    }
    
    
   NSArray *reversedArray = [[ShoucangArray reverseObjectEnumerator] allObjects]; //从后向前排序
    ShoucangArray = [[NSMutableArray alloc]initWithArray:reversedArray];
    
    if (ShoucangArray.count > 0) {
        if (nothing) {
            [nothing removeFromSuperview];
            [lb removeFromSuperview];
        }
        [self.myShouCangTableView reloadData];
    } else {
        if (!nothing) {
            nothing = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huiji.png"]];
            nothing.frame = CGRectMake(161, 90, 100, 82);
            lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 210, 320, 40)];
            lb.textAlignment = 1;
            lb.text = @"您还没有收藏任何内容哦!";
        }
        [self.view addSubview:lb];
        [self.view addSubview:nothing];
    }
    
//    UIWebView *myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 100, 320, 300)];
//    
//    [myWebView loadHTMLString:sc_obj.SC_Content baseURL:nil];
//    
//    [self.view addSubview:myWebView];
}
#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ShoucangArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellide = @"myCell";
    int row = indexPath.row;
    
    ShouCangClass *cell_SC_OBJ = nil;
    cell_SC_OBJ = (ShouCangClass *)[ShoucangArray objectAtIndex:row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellide];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellide];
        cell.backgroundColor = [CW_Tools colorFromHexRGB:@"f3f9f2"];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.contentMode = UIViewContentModeScaleAspectFit;
    }
    cell.textLabel.text = cell_SC_OBJ.SC_Title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"收藏时间:  %@",cell_SC_OBJ.SC_Time];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    __block UINavigationController *nav;
    
    [CW_Tools ToastNotification:@"加载中..." andView:self.myShouCangTableView andLoading:YES andIsBottom:NO doSomething:^{
        ShouCangClass *cell_SC_OBJ = nil;
        cell_SC_OBJ = (ShouCangClass *)[ShoucangArray objectAtIndex:row];
        
        ContentViewController *contentVC;
        if (isIPhone5) {
            contentVC = [[ContentViewController alloc]initWithCatID:nil ContentID:nil ContentTitle:cell_SC_OBJ.SC_Title Content:cell_SC_OBJ.SC_Content Cimage:nil NibName:@"ContentViewController_ip5" bundle:nil];
        }
        else {
            contentVC = [[ContentViewController alloc]initWithCatID:nil ContentID:nil ContentTitle:cell_SC_OBJ.SC_Title Content:cell_SC_OBJ.SC_Content Cimage:nil NibName:@"ContentViewController" bundle:nil];
        }
        
        nav = [[UINavigationController alloc]initWithRootViewController:contentVC];
        nav.modalTransitionStyle = 2;
    }];
    
    
    [self presentViewController:nav animated:YES completion:^{
        //
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShouCangClass *sc_obj = nil;
    sc_obj = (ShouCangClass *)[ShoucangArray objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [LoadShoucangDB deleteTableValue:@"ShouCang_Table" Where:@"SC_Title" IS:[NSString stringWithFormat:@"\'%@\'",sc_obj.SC_Title] And:NO Where2:nil IS2:nil];
        [ShoucangArray removeObjectAtIndex:indexPath.row];
        [self.myShouCangTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消收藏";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
