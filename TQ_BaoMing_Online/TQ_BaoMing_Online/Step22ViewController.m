//
//  Step22ViewController.m
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-10-11.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "Step22ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Step3ViewController.h"

@interface Step22ViewController ()

@end

@implementation Step22ViewController

@synthesize LView;
@synthesize Table;
@synthesize lbnone;
@synthesize finalLb;
@synthesize nextBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        classArray = [[NSMutableArray alloc]initWithCapacity:10];
        classContentArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return self;
}
- (IBAction)backStep:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}
- (IBAction)nextStep:(id)sender {
    
    NSString *classIDstr = [NSString new];
    NSString *jieduanstr =[NSString new];

    if (classContentArray.count > 0) {
        for (int i = 0; i < classContentArray.count; i++) {
            NSArray *tmpArray  =   [classArray objectAtIndex:[[classContentArray objectAtIndex:i] intValue]];
            
            classIDstr  =   [classIDstr stringByAppendingFormat:@"%@,",[tmpArray objectAtIndex:0]];
            jieduanstr =   [jieduanstr stringByAppendingFormat:@"%@,",[tmpArray objectAtIndex:1]];
            
        }
         classIDstr =  [classIDstr substringToIndex:([classIDstr length]-1)];//字符串删除最后一个字符
         jieduanstr =  [jieduanstr substringToIndex:([jieduanstr length]-1)];//字符串删除最后一个字符
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:classIDstr forKey:@"class_id"];
        [userDefaults setObject:[NSNumber numberWithInt:0] forKey:@"type"];
        [userDefaults setObject:@"null" forKey:@"phase"];
        [userDefaults setObject:jieduanstr forKey:@"detail"];
        [userDefaults setObject:[NSString stringWithFormat:@"%d",oldMoney] forKey:@"should_pay"];
        [userDefaults synchronize];
        
        Step3ViewController *step3VC = [Step3ViewController new];
        [self presentViewController:step3VC animated:YES completion:^{
//            <#code#>
        }];
    }
    else {
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
//--------step2 代理方法
- (void)setClasslValue:(NSDictionary *)listDictionary
{
    //
//    NSLog(@"setClasslValue %@",listDictionary);
        [classArray removeAllObjects];
    for (NSDictionary * key in listDictionary)
        {
        NSLog(@"%@  %@  %@  %@",[key objectForKey:@"id"],[key objectForKey:@"name"],[key objectForKey:@"time"],[key objectForKey:@"price"]);
        NSArray *tmpArray = @[[key objectForKey:@"id"],[key objectForKey:@"name"],[key objectForKey:@"time"],[key objectForKey:@"price"]];
        [classArray addObject:tmpArray];
        }
    
    [Table reloadData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([classArray count] == 0) {
        NSLog(@"没有数据!");
        [lbnone setHidden:NO];
        [nextBtn setHidden:YES];
        [finalLb setHidden:YES];
    }
//    LView.layer.cornerRadius = 3;
//    LView.layer.borderWidth = 10;//设置边框的宽度，当然可以不要
//    LView.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
//    LView.layer.masksToBounds = YES;//设为NO去试试
}
#pragma mark - Table相关
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}// custom view for header. will be adjusted to default or specified header height
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}// custom view for footer. will be adjusted to default or specified footer height
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    int newRow = [indexPath row];
    NSLog(@"[indexPath row] == %d",newRow);
    NSArray *tmp = [classArray objectAtIndex:newRow];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
                                
                                indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [classContentArray removeObject:[NSNumber numberWithInt:newRow]];
        newCell.accessoryType = UITableViewCellAccessoryNone;
        [self changeMoney:-[[tmp objectAtIndex:3] intValue]];
        
    } else {
        [classContentArray addObject:[NSNumber numberWithInt:newRow]];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self changeMoney:[[tmp objectAtIndex:3] intValue]];
    }
    
    
    
}

-(void)changeMoney:( int )money
{
    oldMoney += money;
    NSString *moneyPrice = [NSString stringWithFormat:@"总价:  %d  元",oldMoney];
    finalLb.text = moneyPrice;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"[classArray count]  %d",[classArray count]);
    return [classArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

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
        //-------课程
        UILabel *txt1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 300, 20)];
        txt1.backgroundColor = [UIColor clearColor];
        txt1.textAlignment = 1;
        txt1.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1];
        txt1.lineBreakMode = UILineBreakModeWordWrap;
        txt1.numberOfLines = 0;
        txt1.font = [UIFont systemFontOfSize:23.0];
        txt1.tag = 1;
        
        //--------课时
        UILabel *txt2 = [[UILabel alloc]initWithFrame:CGRectMake(350, 15, 300, 20)];
        txt2.backgroundColor = [UIColor clearColor];
        txt2.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1];
        txt2.textAlignment = 1;
        txt2.font = [UIFont systemFontOfSize:23.0];
        txt2.tag = 2;
        
        //--------价格
        UILabel *txt3 = [[UILabel alloc]initWithFrame:CGRectMake(700, 15, 300, 20)];
        txt3.backgroundColor = [UIColor clearColor];
        txt3.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1];
        txt3.textAlignment = 1;
        txt3.font = [UIFont systemFontOfSize:23.0];
        txt3.tag = 3;
        [cell.contentView addSubview:txt1];
        [cell.contentView addSubview:txt2];
        [cell.contentView addSubview:txt3];
        }
    UILabel *thisTxt1 = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *thisTxt2 = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *thisTxt3 = (UILabel *)[cell.contentView viewWithTag:3];
    //    UIImageView *thisImg = (UIImageView *)[cell.contentView viewWithTag:2];
    //    thisImg.image = [UIImage imageNamed:@"dianji15dao_1.png"];
    NSArray *tmp = [classArray objectAtIndex:row];
    NSLog(@"%@",[tmp objectAtIndex:1]);
    thisTxt1.text = [tmp objectAtIndex:1];
    thisTxt2.text = [NSString stringWithFormat:@"%@课时",[tmp objectAtIndex:2]];
    thisTxt3.text = [NSString stringWithFormat:@"%@元",[tmp objectAtIndex:3]];
    
    return cell;
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
