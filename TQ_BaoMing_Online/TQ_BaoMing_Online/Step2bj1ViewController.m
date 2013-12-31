//
//  Step2bj1ViewController.m
//  TQ_BaoMing_Online
// 套餐二级页面
//  Created by cui wang on 13-10-10.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "Step2bj1ViewController.h"
#import "taocan_content_Obj.h"
#import "taocan_content_class_Obj.h"
#import "Step3ViewController.h"
@interface Step2bj1ViewController ()

@end

@implementation Step2bj1ViewController

@synthesize TB1;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        taocanIdArray = [NSMutableArray new];
        titleArray = [NSMutableArray new];
        classArray = [NSMutableArray new];
        chooseArray = [NSMutableArray new];
    }
    return self;
}

- (void)setTaocanValue:(NSArray *)listDictionary
{
    
    for (taocan_content_Obj *content in listDictionary)
        {
        [taocanIdArray addObject:content.tid];
        [titleArray addObject:content.tname];
        [classArray addObject:content.taocan_content_class_Obj];
        }
    [TB1 reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
//        <#code#>
    }];
}
- (IBAction)nextClick:(id)sender {
    // 存储班级ID 格式为拼凑的字符串
     //--------chooseArray section 对应阶段  row对应班级
    if([chooseArray count] > 0)
        {
        
        NSString *classIDstr = [NSString new];
        NSString *jieduanstr = [NSString new];

        for (NSIndexPath* indexpath in chooseArray) {
            
            NSArray *class_array = [classArray objectAtIndex:indexpath.section];
            taocan_content_class_Obj *class_obj = [class_array objectAtIndex:indexpath.row];
//            [classIDstr appendFormat:@"%@,",class_obj.cid];
//             [jieduanstr appendFormat:@"%@," ,[titleArray objectAtIndex:indexpath.section]];
         classIDstr =   [classIDstr stringByAppendingFormat:@"%@,",class_obj.cid];
            jieduanstr =   [jieduanstr stringByAppendingFormat:@"%@,",[titleArray objectAtIndex:indexpath.section]];

        }
        
//        NSRange range = {0,1};
//        [classIDstr deleteCharactersInRange:range];
//        [jieduanstr deleteCharactersInRange:range];

        NSLog(@"classIDstr == %@",classIDstr);
        NSLog(@"jieduanstr == %@",jieduanstr);
        
      classIDstr =  [classIDstr substringToIndex:([classIDstr length]-1)];//字符串删除最后一个字符
       jieduanstr = [jieduanstr substringToIndex:([jieduanstr length]-1)];//字符串删除最后一个字符
        
        NSLog(@"classIDstr == %@",classIDstr);
        NSLog(@"jieduanstr == %@",jieduanstr);
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:classIDstr forKey:@"class_id"];
        [userDefaults setObject:[NSNumber numberWithInt:1] forKey:@"type"];
        [userDefaults setObject:jieduanstr forKey:@"phase"];
        [userDefaults setObject:@"100" forKey:@"detail"];
        [userDefaults synchronize];
        
        Step3ViewController *step3VC = [Step3ViewController new];
        [self presentViewController:step3VC animated:YES completion:^{
//            <#code#>
        }];
        
        }else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"您没有选择班级!";
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:3];
        }
    
    
    
}
#pragma mark - table delegate
//--------多少个row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return   [[classArray objectAtIndex:section] count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSArray *class_array = [classArray objectAtIndex:indexPath.section];
    taocan_content_class_Obj *class_obj = [class_array objectAtIndex:indexPath.row];
    cell.textLabel.text = class_obj.cname;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    
    //---------刷新table 刷新标签状态
    if([chooseArray count] > 0)
        {
        for (NSIndexPath* indexpath in chooseArray) {
            if ((indexPath.row == indexpath.row) &&(indexPath.section == indexpath.section)) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        
        }
    
    return cell;
}
//--------多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return titleArray.count;
}// Default is 1 if not implemented

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLb.backgroundColor = [UIColor colorWithRed:0.4 green:0.5 blue:0.6 alpha:1];
    titleLb.text = [titleArray objectAtIndex:section];
    titleLb.font = [UIFont fontWithName:@"Avenir" size:24];
    
    return titleLb;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSIndexPath * newRow = indexPath;
    NSIndexPath* oldRow = (lastIndexPath != nil) ? lastIndexPath  : [NSIndexPath indexPathForRow:-1 inSection:0];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
                                indexPath];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
                                lastIndexPath];
//    NSLog(@"%@   %@",newRow,oldRow);
    //--------chooseArray section 对应阶段  row对应班级
    if ((newRow.row != oldRow.row) || (newRow.section != oldRow.section))
        {
        if (newCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            newCell.accessoryType = UITableViewCellAccessoryNone;
            [chooseArray removeObject:indexPath];
        } else {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            lastIndexPath = [indexPath copy];//一定要这么写，要不报错
            [chooseArray addObject:indexPath];
        }
        }  else {
//            NSLog(@"点击的同一个");
             oldCell.accessoryType = UITableViewCellAccessoryNone;
            lastIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
            [chooseArray removeObject:indexPath];
        }
    
}
#pragma mark - 强制横屏
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    //return YES;
}
@end
