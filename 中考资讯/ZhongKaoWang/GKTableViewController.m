//
//  GKTableViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-22.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "GKTableViewController.h"
#import "GKSlideSwitchView.h"
@interface GKTableViewController ()

@end

@implementation GKTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _list = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}
-(void)loadView
{
    [super loadView];
    self.tableViewList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableViewList.delegate = self;
    self.tableViewList.dataSource = self;
    self.tableViewList.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.tableViewList];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int i = 0; i<15; i++) {
        [_list addObject: [NSString stringWithFormat:@"%@  微博%d",self.title,i]];
    }
    NSLog(@"viewDidLoad title = %@",self.title);
}

- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    //可以在这里加载数据等操作
}


#pragma mark - 表格视图数据源代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 188;
    }
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";//由于用了两种界面模式所以两个tag
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell;
    
    if (indexPath.row == 0)
        {
        cell  =  (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        if (cell == nil)
            {
            cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            self.bannerArray=@[@"",@"",@""];
            self.bannerTextArray = @[@"嘿嘿,美女哇,哇咔咔",@"呵呵,又一个美女哦",@"哇,还有啊,不错哦"];
            imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 30, cell.bounds.size.width, cell.bounds.size.height) setCellBannerWithImageArray:_bannerArray andText:_bannerTextArray];
            imageScrollView.delegate = self;
            
            pageControl = [[BasePageControl alloc]initWithFrame:CGRectMake(260, 170, 70, 10)];
            
            UILabel *topTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
            topTimeLB.backgroundColor = [UIColor clearColor];
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"   YYYY年 MM月 dd日"];
            topTimeLB.text = [formatter stringFromDate:[NSDate date]];
            topTimeLB.font = [UIFont systemFontOfSize:14.0];
            topTimeLB.textColor = [GKSlideSwitchView colorFromHexRGB:@"868686"];
            topTimeLB.backgroundColor = [GKSlideSwitchView colorFromHexRGB:@"f3f9f2"];
            //setTitleColor:[Globle colorFromHexRGB:@"868686"]
            //开启定时器线程
            //            [NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(handleTimer)  userInfo:nil  repeats: YES];
            [cell.contentView addSubview:topTimeLB];
            [cell.contentView addSubview:imageScrollView];
            [cell.contentView addSubview:pageControl];
            }
        } else {
            cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier: cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.textLabel.text = [_list objectAtIndex:indexPath.row-1];
        }
    
	return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   pageControl.currentPage = (int)scrollView.contentOffset.x / 320;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
