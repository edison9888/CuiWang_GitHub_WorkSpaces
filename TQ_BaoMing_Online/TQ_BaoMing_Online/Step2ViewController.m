//
//  Step2ViewController.m
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-9-24.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "Step2ViewController.h"
#import "Step3ViewController.h"
#import "taocanObj.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Step22ViewController.h"
#import "Step2bj1ViewController.h"
#import "taocan_content_class_Obj.h"
#import "taocan_content_Obj.h"
@interface Step2ViewController ()

@end

@implementation Step2ViewController
@synthesize PassClassValueDelegate;
@synthesize PassTaocanValueDelegate;
//@synthesize buttonMid;
@synthesize xuanzebanji;
@synthesize xuanzetaocan;
@synthesize xiangmuTableView;
@synthesize lb1;
@synthesize lb2;
@synthesize lb3;
@synthesize lb4;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        choosedArray = [[NSMutableArray alloc]initWithCapacity:10];
        subIdArray = [[NSMutableArray alloc]initWithCapacity:34];
        subNameArray = [[NSMutableArray alloc]initWithCapacity:34];
        listViewDataArray =[[NSMutableArray alloc]initWithCapacity:50];
        listViewClassDataArray =[[NSMutableArray alloc]initWithCapacity:50];
        classArray = [[NSMutableArray alloc]initWithCapacity:50];
        contentArray = [[NSMutableDictionary alloc]initWithCapacity:10];
        passContentArray = [[NSArray alloc]init];
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reflashTable:) name:@"reflashTable" object:nil];
    }
    return self;
}
//--------下拉点击刷新列表
- (void)reflashTable:(NSNotification*) notification
{
    xiaindex = [[notification object] intValue];//获取到传递的对象
    NSLog(@"下拉点击的是 :%d",xiaindex);
    [choosedArray removeAllObjects];
    lastIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];//一定要这么写，要不报错
    //--------网络连接相关
    
#if NS_BLOCKS_AVAILABLE
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    __block NSDictionary *loadStatus;
	[self.view addSubview:hud];
	hud.labelText = @"刷新...";
	
	[hud showAnimated:YES whileExecutingBlock:^{
        
        if (!xuanzetaocan.selected) {//--------选择套餐
            loadStatus  =   [self getDataFromURLUseString:@"http://bm.taiqiedu.com/site/login?r=rest/preferentiallist" subID:[subIdArray objectAtIndex:xiaindex]];
            
//            [self putDataFromDic:loadStatus];
            
        } else {//--------选择班级
            loadStatus  =   [self getDataFromURLUseString:@"http://bm.taiqiedu.com/site/login?r=rest/classlist" subID:[subIdArray objectAtIndex:xiaindex]];
            
        }
        
	} completionBlock:^{
        //subIdArray 存储项目ID
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[subIdArray objectAtIndex:xiaindex] forKey:@"project_id"];
        [userDefaults synchronize];
        
        if (!xuanzetaocan.selected) {//--------选择套餐
            [self flashTableViewData:loadStatus Type:0];
        }else {//--------选择班级
            [self flashTableViewData:loadStatus Type:1];
        }
	}];
    
    
#endif
}
//--------套餐字典解析
-(void)putDataFromDic:(NSDictionary *)loadStatus
{
    //--------清空
    [listViewDataArray removeAllObjects];
    for (NSDictionary *dic in loadStatus)
        {
        taocanObj *taocan = [taocanObj new];
        taocan.sID = [dic objectForKey:@"id"];
        taocan.name = [dic objectForKey:@"name"];
        taocan.original_price = [dic objectForKey:@"original_price"];
        taocan.price = [dic objectForKey:@"price"];
        taocan.taocan_content_Obj = [[NSMutableArray alloc]initWithCapacity:10];
        //--------content里面的内容
        for (NSDictionary *content in [dic objectForKey:@"content"])
            {
            taocan_content_Obj *content_obj = [taocan_content_Obj new];
            content_obj.tid = [content objectForKey:@"id"];
            content_obj.tname = [content objectForKey:@"name"];
            content_obj.taocan_content_class_Obj = [[NSMutableArray alloc]initWithCapacity:10];
            //--------class里面的内容
            for (NSDictionary *class in [content objectForKey:@"class"])
                {
                taocan_content_class_Obj *content_class = [taocan_content_class_Obj new];
                content_class.cid = [class objectForKey:@"id"];
                content_class.cname = [class objectForKey:@"name"];
                [content_obj.taocan_content_class_Obj addObject:content_class];
                }
            
            [taocan.taocan_content_Obj addObject: content_obj];
            }
        
        [listViewDataArray addObject:taocan];
        }
}
//--------刷新table数据
-(void)flashTableViewData:(NSDictionary *)loadStatus Type:(int) tpye
{
    if (tpye == 0) {
        if (!loadStatus) {
            NSLog(@"tpye == 0");
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.delegate = self;
            [HUD show:YES];
            [HUD hide:YES afterDelay:3];
            
        } else
            {
            [self putDataFromDic:loadStatus];
            }
    }
    //--------
    else
        {
        [listViewClassDataArray removeAllObjects];
        if (!loadStatus) {
            NSLog(@"tpye == 1");
            
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.delegate = self;
            [HUD show:YES];
            [HUD hide:YES afterDelay:3];
            
        } else
            {
            
            for (NSDictionary * key in loadStatus)
                {
                
                NSArray *content = @[[key objectForKey:@"id"],[key objectForKey:@"name"],[key objectForKey:@"total_class"],[key objectForKey:@"all_course_cost"],[key objectForKey:@"start_time"],[key objectForKey:@"end_time"]];
                
                [listViewClassDataArray addObject:content];
                }
            
            }
        }
    [xiangmuTableView reloadData];
}


//------登录
-(NSDictionary *)getDataFromURLUseString:(NSString *)urlSS subID:(NSString *)subID
{
    
    //           NSURL *url = [NSURL URLWithString:@"http://bm.taiqiedu.com/site/login?r=rest/list"];
    
    ASIFormDataRequest* formRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlSS]];
    [formRequest setPostValue:subID forKey:@"id"];
    [formRequest startSynchronous];
    NSError *error = [formRequest error];
    if (!error) {
        NSData *data = [formRequest responseData];
//        NSString *tmp=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"tmp == %@",tmp);
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//                NSLog(@"weatherDic == %@",weatherDic);
        ////
        //        for (NSDictionary * key in weatherDic)
        //            {
        //            for (NSDictionary *key2 in [key objectForKey:@"content"]) {
        //
        //                [contentArray addObject:key2];
        ////
        ////                NSLog(@"%@  ",[key2 objectForKey:@"name"]);
        ////                for (NSDictionary *key3 in [key2 objectForKey:@"class"])
        ////                    {
        ////                    NSLog(@"%@  ",[key3 objectForKey:@"name"]);
        ////                    }
        //            }
        //            //            NSLog(@"%@  ",[key objectForKey:@"content"]);
        //            }
        
        //        NSLog(@"%@",[weatherDic objectForKey:@"cou"]);
        //
        //        return [weatherDic objectForKey:@"cou"];
        return weatherDic;
    }
    return nil;
}

#pragma mark - step1代理方法
- (void)setListlValue:(NSDictionary *)listDictionary
{
    //
    for (NSDictionary * key in listDictionary)
        {
        [subIdArray addObject:[key objectForKey:@"id"]];
        [subNameArray addObject:[key objectForKey:@"name"]];
        }
    //    [subNameArray addObject:@"欢迎使用太奇报名系统"];
    
    
#if NS_BLOCKS_AVAILABLE
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    __block NSDictionary *loadStatus;
	[self.view addSubview:hud];
	hud.labelText = @"获取套餐列表...";
	
	[hud showAnimated:YES whileExecutingBlock:^{
        loadStatus  =   [self getDataFromURLUseString:@"http://bm.taiqiedu.com/site/login?r=rest/preferentiallist" subID:@"4"];
        //        loadClassStatus =   [self getDataFromURLUseString:@"http://bm.taiqiedu.com/site/login?r=rest/classlist" subID:@"4"];
	} completionBlock:^{
		[self flashTableViewData:loadStatus Type:0];
        //        [self flashTableViewData:loadClassStatus Type:1];
    }];
#endif
    
}
#pragma mark -viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
	_comboBox = [[ComboBoxView alloc] initWithFrame:CGRectMake(330, 194, 330, 305)];
	_comboBox.comboBoxDatasource = subNameArray;
	_comboBox.backgroundColor = [UIColor clearColor];
	[_comboBox setContent:[subNameArray objectAtIndex:0]];
	[self.view addSubview:_comboBox];
}
- (IBAction)taocanClick:(UIButton*)sender {
    NSLog(@"taocanclick");
    

    if (!sender.selected) {
        //                sender.selected = NO;
    }
    else
        {
        [_comboBox setContent:[subNameArray objectAtIndex:0]];//--------下拉归位
        [choosedArray removeAllObjects];
        lastIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];//一定要这么写，要不报错
        sender.selected = NO;
        [self.xuanzebanji setSelected:NO];
        [self.xiangmuTableView reloadData];
        
        lb1.text = @"套餐名称";
        lb2.text = @"套餐内容";
        lb3.text = @"课程原价";
        lb4.text = @"套餐价格";
        
        
        }
    
}
- (IBAction)banjiClick:(UIButton*)sender {
    NSLog(@"banjiclick");
    

    if (sender.selected) {
        //                sender.selected = NO;
    }
    else
        {
        [_comboBox setContent:[subNameArray objectAtIndex:0]];//--------下拉归位
        [choosedArray removeAllObjects];
        lastIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];//一定要这么写，要不报错
        sender.selected = YES;
        [self.xuanzetaocan setSelected:YES];
        
#if NS_BLOCKS_AVAILABLE
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        __block NSDictionary *loadStatus;
        [self.view addSubview:hud];
        hud.labelText = @"获取班级列表...";
        
        [hud showAnimated:YES whileExecutingBlock:^{
            loadStatus  =   [self getDataFromURLUseString:@"http://bm.taiqiedu.com/site/login?r=rest/classlist" subID:@"4"];
        } completionBlock:^{
            [self flashTableViewData:loadStatus Type:1];
        }];
#endif
        
        
        [self.xiangmuTableView reloadData];
        
        lb1.text = @"班级";
        lb2.text = @"总课时";
        lb3.text = @"日期";
        lb4.text = @"课程价格";
        }
}

- (IBAction)nextClick:(id)sender {
    Step3ViewController *step3View = [Step3ViewController new];
    step3View.modalTransitionStyle = 2;
    NSLog(@"choosedArray %@",choosedArray);
    if ([choosedArray count] > 0) {
        
        //-------- 选择班级
        if (xuanzetaocan.selected) {
            // xiaindex  //subidarray  //classsonlist
#if NS_BLOCKS_AVAILABLE
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            __block NSDictionary *loadStatus;
            [self.view addSubview:hud];
            hud.labelText = @"刷新...";
            [hud showAnimated:YES whileExecutingBlock:^{
                NSArray *dataArr = [listViewClassDataArray objectAtIndex:classIndex];
                loadStatus  =   [self getDataFromURLUseString:@"http://bm.taiqiedu.com/site/login?r=rest/classsonlist" subID:[dataArr objectAtIndex:0]];
            } completionBlock:^{
                Step22ViewController *step22 = [Step22ViewController new];
                self.PassClassValueDelegate = step22;
                [self.PassClassValueDelegate setClasslValue:loadStatus];
                
                [self presentViewController:step22 animated:YES completion:^{
                    //        <#code#>  班级默认pp_id为0
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:[NSNumber numberWithInt:0] forKey:@"pp_id"];
                    [userDefaults synchronize];
                    [hud removeFromSuperview];
                }];
                
            }];
#endif
            //--------选择套餐
        }else {
            Step2bj1ViewController *taocan2 = [Step2bj1ViewController new];
            self.PassTaocanValueDelegate = taocan2;
            
            taocanObj *taocan = [taocanObj new] ;
            taocan = [listViewDataArray objectAtIndex:[[choosedArray objectAtIndex:0] intValue]];
          
            [self.PassTaocanValueDelegate setTaocanValue:taocan.taocan_content_Obj];
            
            [self presentViewController:taocan2 animated:YES completion:^{
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:taocan.sID forKey:@"pp_id"];
                [userDefaults setObject:taocan.price forKey:@"should_pay"];
                [userDefaults synchronize];
            }];
        }
        
        
    }else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您没有选择课程!";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:3];
    }
    
    
}

//------点击下拉响应

#pragma mark - 项目表格相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (xuanzebanji.selected) {
        return [listViewClassDataArray count];
    }
    return [listViewDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString  *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //---------选择套餐默认不选中
    
    //        if (cell == nil)
    //            {
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //--------图标
    UIImageView *tagIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"grey_tag.png"]];
    tagIV.tag = 10;
    
    //--------图标上的字
    UILabel  *imageLB=[[UILabel alloc] initWithFrame:CGRectMake(0,3, 25, 25)];
    imageLB.tag = 11;
    imageLB.backgroundColor = [UIColor clearColor];
    imageLB.textColor = [UIColor whiteColor];
    imageLB.textAlignment = NSTextAlignmentCenter;
    imageLB.font = [UIFont systemFontOfSize:20.0];
    [tagIV addSubview:imageLB];
    
    
    //------------套餐名称
    UILabel *upLB1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 200, 70)];
    upLB1.tag = 121;
    upLB1.textAlignment = 1;
    upLB1.lineBreakMode = UILineBreakModeWordWrap;
    upLB1.numberOfLines = 0;
    upLB1.backgroundColor = [UIColor clearColor];
    upLB1.textColor = [UIColor redColor];
    upLB1.font = [UIFont systemFontOfSize:20.0];
    
    //------------套餐内容
    UILabel *upLB2 = [[UILabel alloc]initWithFrame:CGRectMake(240, 10, 260, 70)];
    upLB2.tag = 122;
    upLB2.lineBreakMode = UILineBreakModeTailTruncation;
    upLB2.adjustsFontSizeToFitWidth = YES;
    upLB2.minimumFontSize = 1.0f;
    upLB2.numberOfLines = 0;
    upLB2.textAlignment = 1;
    upLB2.backgroundColor = [UIColor clearColor];
    upLB2.textColor = [UIColor redColor];
    upLB2.font = [UIFont systemFontOfSize:20.0];
    
    //------------课程原价
    UILabel *upLB4 = [[UILabel alloc]initWithFrame:CGRectMake(480, 10, 240, 70)];
    upLB4.tag = 124;
    upLB4.lineBreakMode = UILineBreakModeWordWrap;
    upLB4.numberOfLines = 0;
    upLB4.textAlignment = 1;
    upLB4.backgroundColor = [UIColor clearColor];
    upLB4.textColor = [UIColor redColor];
    upLB4.font = [UIFont systemFontOfSize:20.0];
    
    //------------套餐价格
    UILabel *upLB3= [[UILabel alloc]initWithFrame:CGRectMake(720, 10, 240, 70)];
    upLB3.tag = 123;
    upLB3.lineBreakMode = UILineBreakModeWordWrap;
    upLB3.numberOfLines = 0;
    upLB3.textAlignment = 1;
    upLB3.backgroundColor = [UIColor clearColor];
    upLB3.textColor = [UIColor redColor];
    upLB3.font = [UIFont systemFontOfSize:20.0];
    
    
    
    //--------最右边的图标
    UIImageView *rightImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"link.png"]];
    //            rightImg.frame = CGRectMake(900, 25, 82, 32);
    rightImg.tag = 15;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(900, 25, 82, 32);
    rightBtn.tag = 14;
    [rightBtn setImage:[UIImage imageNamed:@"link.png"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"link1.png"] forState:UIControlStateSelected];
    [rightBtn setImage:[UIImage imageNamed:@"link1.png"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:tagIV];
    [cell.contentView addSubview:upLB1];
    [cell.contentView addSubview:upLB2];
    [cell.contentView addSubview:upLB3];
    [cell.contentView addSubview:upLB4];
    
    //            [cell.contentView addSubview:rightImg];
    //             [cell.contentView addSubview:rightBtn];
    cell.accessoryView = rightImg;
    //            }
    //--------
    //---------刷新table 刷新标签状态
    if([choosedArray count] > 0)
        {
        UIImageView *iIV = (UIImageView *)[cell.contentView viewWithTag:10];
        UIImageView *cellImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"link1.png"]];
        //            UIImageView *iBtn = (UIImageView *)[cell.contentView viewWithTag:15];
        for (NSNumber* position in choosedArray) {
            if (row == position.intValue) {
                iIV.image = [UIImage imageNamed:@"red_tag.png"];
                cell.accessoryView = cellImageV;
                //                    iBtn.image = [UIImage imageNamed:@"link1.png"];
                //                    [iBtn setSelected:YES];
            }
        }
        
        }
    
    UILabel *iLB = (UILabel *)[cell.contentView viewWithTag:11];
    iLB.backgroundColor = [UIColor clearColor];
    NSString *txt = [NSString stringWithFormat:@"%d",row+1];
    iLB.text = txt;
    //--------
    UILabel *uPLB1 = (UILabel *)[cell.contentView viewWithTag:121];
    UILabel *uPLB2 = (UILabel *)[cell.contentView viewWithTag:122];
    UILabel *uPLB3 = (UILabel *)[cell.contentView viewWithTag:123];
    UILabel *uPLB4 = (UILabel *)[cell.contentView viewWithTag:124];
    
    
    if (!xuanzetaocan.selected) {
        taocanObj *taocan = [taocanObj new] ;
        taocan = [listViewDataArray objectAtIndex:row];
        
        NSString *txtuPLB1 = [NSString stringWithFormat:@"%@",taocan.name];
        uPLB1.text = txtuPLB1;
        
        NSArray *content_array =   taocan.taocan_content_Obj;
        
        NSString *taocanContentTXT = [NSMutableString new];
        for (taocan_content_Obj *content in content_array)
        {
        NSString *taocanClassTXT = [NSMutableString new];
        for (taocan_content_class_Obj *class_obj in content.taocan_content_class_Obj) {
          taocanClassTXT = [taocanClassTXT stringByAppendingFormat:@"%@,",class_obj.cname];
            }
            taocanClassTXT =   [taocanClassTXT substringToIndex:([taocanClassTXT length]-1)];//字符串删除最后一个字符
          taocanContentTXT =  [taocanContentTXT stringByAppendingFormat:@"%@(%@)\n",content.tname,taocanClassTXT];
        }
        
        NSString *txtuPLB2 = [NSString stringWithFormat:@"%@",taocanContentTXT];
        uPLB2.text = txtuPLB2;
        
        NSString *txtuPLB4 = [NSString stringWithFormat:@"%@元",taocan.original_price];
        uPLB4.text = txtuPLB4;
        
        NSString *txtuPLB3 = [NSString stringWithFormat:@"%@元",taocan.price];
        uPLB3.text = txtuPLB3;
    } else {
        NSArray *taocan;
        taocan = [listViewClassDataArray objectAtIndex:row];
        
        NSString *txtuPLB1 = [NSString stringWithFormat:@"%@",[taocan objectAtIndex:1]];
        uPLB1.text = txtuPLB1;
        
        NSString *txtuPLB2 = [NSString stringWithFormat:@"%@",[taocan objectAtIndex:2]];
        uPLB2.text = txtuPLB2;
        
        NSString *txtuPLB4 = [NSString stringWithFormat:@"%@至%@",[taocan objectAtIndex:4],[taocan objectAtIndex:5]];
        uPLB4.text = txtuPLB4;
        
        NSString *txtuPLB3 = [NSString stringWithFormat:@"%@元",[taocan objectAtIndex:3]];
        uPLB3.text = txtuPLB3;
    }
    
    return cell;
    
}
//----------


//选择课程 cell内按钮单击
//-(void)click:(id)sender
//{
//    
//    UITableViewCell* buttonCell = (UITableViewCell*)[[[sender   superview] superview] superview];
//    NSUInteger row = [[xiangmuTableView indexPathForCell:buttonCell]row];
//    NSLog(@"row == %d",row);
//    UIButton * btn = (UIButton *)sender;
//    //
//    if (btn.isSelected) {
//        [choosedArray removeObject:[NSNumber numberWithInt:row]];
//        [btn setSelected:NO];
//    }else {
//        [choosedArray addObject:[NSNumber numberWithInt:row]];
//        [btn setSelected:YES];
//    }
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//    
//    
//    classIndex = row; // 保存点击索引
//    
//    int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
//    if (row != oldRow)
//        {
//        UITableViewCell *oldCell = [xiangmuTableView cellForRowAtIndexPath:
//                                    lastIndexPath];
//        lastIndexPath = [indexPath copy];//一定要这么写，要不报错
//        }
//    
//    [xiangmuTableView reloadData];
//    
//    
//    
//    
//}
//小按钮的响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath == %@",indexPath);
    int newRow = [indexPath row];
    classIndex = newRow; // 保存点击索引
    int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
    [choosedArray removeObject:[NSNumber numberWithInt:oldRow]];
    
    if (newRow != oldRow)
        {
        [choosedArray addObject:[NSNumber numberWithInt:newRow]];
        lastIndexPath = [indexPath copy];//一定要这么写，要不报错
        } else {
            lastIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
        }
    NSLog(@"choosedArray == %d",[choosedArray count]);
    [xiangmuTableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
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
