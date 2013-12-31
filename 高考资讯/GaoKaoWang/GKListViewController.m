//
//  GKTableViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-22.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "GKListViewController.h"
#import "GKSlideSwitchView.h"
#import "contentClass.h"
#import "ContentViewController.h"
#import "AppDelegate.h"
#import "GCDiscreetNotificationView.h"
#import "TuiJianThumbClass.h"
#import "GKListEasyCell.h"
#import "GKListCell.h"
#import <AudioToolbox/AudioToolbox.h>

#define isTuiJian [self.title isEqualToString:@"推荐"]
#define isNetOk [CW_Tools checkNetworkConnection]

@interface GKListViewController ()

@end

@implementation GKListViewController
@synthesize catid;
@synthesize timer;
@synthesize title;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
        //--------注册缓存清理通知
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(clearedCache) name:@"clearedCache" object:nil];
		_list = [[NSMutableArray alloc] initWithCapacity:1];
		readedSet = [[NSMutableSet alloc]initWithCapacity:10];
		thumbDataArray = [[NSMutableArray alloc]initWithCapacity:3];
        _bannerArray = [NSMutableArray array];
        _bannerTextArray = [NSMutableArray array];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    //--------判断是否加载过视图
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSArray *myViewDidLoadAr = [ud objectForKey:@"myViewDidLoad"];
	NSMutableArray *myViewDidLoadArr = [[NSMutableArray alloc]initWithArray:myViewDidLoadAr];
	if (![myViewDidLoadArr containsObject:self.title]) {
		[myViewDidLoadArr addObject:self.title];
		[ud setObject:myViewDidLoadArr forKey:@"myViewDidLoad"];
		[ud synchronize];
	}
    
    [self _initView];
	//--------开始定时器
	[self initTimer];
    
}
/**
 *    <#Description#>
 */
-(void)_initView
{
    //创建tableheadview
    if (isTuiJian) {
        
        EScrollerView *bannerSC = [self createTuiJianTableHeaderView];
        if (bannerSC != nil) {
            self.tableViewList.tableHeaderView = bannerSC;
        }
    }
    
    //创建tablefootview
    loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loadMoreButton.frame = CGRectMake(0, 0, ScreenWidth, 40);
    loadMoreButton.backgroundColor = [UIColor whiteColor];
    [loadMoreButton setTitle:@"上拉加载更多..." forState:UIControlStateNormal];
    [loadMoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loadMoreButton addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.frame = CGRectMake(100, 10, 20, 20);
    activity.tag = 2013;
    [loadMoreButton addSubview:activity];
    self.tableViewList.tableFooterView = loadMoreButton;
    
	//--------下拉刷新
	if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(5.0f, 0.0f - self.tableViewList.bounds.size.height, self.view.frame.size.width - 10, self.tableViewList.bounds.size.height)];
		view.delegate = self;
		[self.tableViewList addSubview:view];
		_refreshHeaderView = view;
	}
}

#pragma mark - 上拉加载
-(void)loadMore
{
    [self startLoadMore];
    
    [self performSelector:@selector(stopLoadMore) withObject:nil afterDelay:2];
}
-(void)startLoadMore
{
    [loadMoreButton setTitle:@"加载中..." forState:UIControlStateNormal];
    loadMoreButton.enabled = NO;
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[loadMoreButton viewWithTag:2013];
    [activity startAnimating];
}
-(void)stopLoadMore
{
    [loadMoreButton setTitle:@"上拉加载更多..." forState:UIControlStateNormal];
    loadMoreButton.enabled = YES;
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[loadMoreButton viewWithTag:2013];
    [activity stopAnimating];
}

-(void)pullUp
{
    
}

#pragma mark 创建 tableheaderview
-(EScrollerView *)createTuiJianTableHeaderView
{
    [self getThumbData];

    if (thumbDataArray.count == 0) {
        return nil;
    }
    
    for (int i = 0; i < thumbDataArray.count; i++) {
        [self.bannerArray addObject:((TuiJianThumbClass *)thumbDataArray[i]).thumb];
        [self.bannerTextArray addObject:((TuiJianThumbClass *)thumbDataArray[i]).title];
    }
    
    EScrollerView *scroller = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, ScreenWidth, 158)
                                                            ImageArray:self.bannerArray
                                                            TitleArray:self.bannerTextArray];
    scroller.delegate = self;
        
        return scroller;
        

}

#pragma mark 通知代理 清除了缓存
- (void)clearedCache {
	//--------清除点击记录
	[readedSet removeAllObjects];
	[self.tableViewList reloadData];
}

#pragma mark 定时器
- (void)initTimer {
	//时间间隔
	NSTimeInterval timeInterval = 1.0;
	//定时器
	timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
	                                         target:self
	                                       selector:@selector(addValueTimer)
	                                       userInfo:nil
	                                        repeats:YES];
}

- (void)addValueTimer {
	timerValue++;
}

#pragma mark 更新数据
- (void)viewWillCurrentView {
//	DLog(@"将要加载的视图 = %@  视图ID = %@", self.title, self.catid);
	[self showMB];
}

- (void)viewDidCurrentView {
//	DLog(@"当前视图 = %@  视图ID = %@", self.title, self.catid);
	if (timerValue > 120) {
//		DLog(@"获取新内容 = %@  视图ID = %@", self.title, self.catid);
		timerValue = 0;
		[self showMB];
	}
}

#pragma mark 弹出非模态加载视图
- (void)showMB {
	UIView *thisView = self.view;
        [CW_Tools ToastNotification:@"正在努力加载中..." andView:thisView andLoading:YES andIsBottom:NO doSomething: ^{
            [self addDataToViewISPullUp:NO];
        }];
}

- (void)getThumbData {
	NSURL *url = [NSURL URLWithString:@"http://www.gkk12.com/index.php?m=content&c=khdindex&a=positionimg"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    //获取全局变量
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	//设置缓存方式
	[request setDownloadCache:appDelegate.asiCache];
	//设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {
		NSData *data = [request responseData];
		NSDictionary *titlerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
		[thumbDataArray removeAllObjects]; //清空
		for (NSDictionary *dic in titlerDic) {
			TuiJianThumbClass *tuijian = [TuiJianThumbClass new];
			tuijian.thumb = [dic objectForKey:@"thumb"];
			tuijian.title = [dic objectForKey:@"title"];
			tuijian.url = [dic objectForKey:@"url"];
			[thumbDataArray addObject:tuijian];
		}
	}
}

#pragma mark 更新数据
- (void)addDataToViewISPullUp:(BOOL)up {
	NSString *urlstr = [NSString stringWithFormat:@"http://www.gkk12.com/index.php?m=content&c=khdindex&a=getcatid&catid=%@", self.catid];
	NSURL *url = [NSURL URLWithString:urlstr];
//	__unsafe_unretained __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	
    
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    //获取全局变量
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	//设置缓存方式
	[request setDownloadCache:appDelegate.asiCache];
	//设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        if (!up) {
	        [_list removeAllObjects];
	        [readedSet removeAllObjects];
		}
	    NSData *data = [request responseData];
	    NSDictionary *titlerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	    for (NSDictionary * dic in titlerDic) {
	        contentClass *content = [contentClass new];
	        content.cID = [dic objectForKey:@"id"];
	        content.cTitle = [dic objectForKey:@"title"];
	        content.cnID = [dic objectForKey:@"catid"];
	        content.cImage = [dic objectForKey:@"image"];
            content.cCommntTime = [dic objectForKey:@"inputtime"];
	        [_list addObject:content];
		}
	    //--------重置
	    timerValue = 0;
	    _loadingFull = NO;
        
	    if (up) {
	        if (_list.count >= 40) {
	            _loadingFull = YES;
			}
            //            [self loadDataEnd];
		}
        
	    [self.tableViewList reloadData];
    } else {
        [CW_Tools ToastViewInView:self.view withText:@"连接服务器失败! "];
    }
    
    
    /**
     *    这里应该要抽出两个不同的方法 下拉刷新 和 进入时的获取数据
     */
 //   [self doneLoadingTableViewData];
    /*
	[request setCompletionBlock: ^{
        
	    if (!up) {
	        [_list removeAllObjects];
	        [readedSet removeAllObjects];
		}
	    NSData *data = [request responseData];
	    NSDictionary *titlerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	    for (NSDictionary * dic in titlerDic) {
	        contentClass *content = [contentClass new];
	        content.cID = [dic objectForKey:@"id"];
	        content.cTitle = [dic objectForKey:@"title"];
	        content.cnID = [dic objectForKey:@"catid"];
	        content.cImage = [dic objectForKey:@"image"];
	        [_list addObject:content];
		}
	    //--------重置
	    timerValue = 0;
	    _loadingFull = NO;
        
	    if (up) {
	        if (_list.count >= 40) {
	            _loadingFull = YES;
			}
            //            [self loadDataEnd];
		}
        
	    [self.tableViewList reloadData];
	}];
	[request setFailedBlock: ^{
	    [CW_Tools ToastViewInView:self.view withText:@"连接服务器失败! "];
	}];
	[request startAsynchronous];
     */
}

#pragma mark - 表格视图数据源代理方法
- (void)hasReaded:(NSIndexPath *)path {
	[readedSet addObject:path];
	[self.tableViewList reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _list.count;
}
/*
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (isTuiJian) {
		if (indexPath.row == 0) {
			return 158;
		}
	}
	return 100;
}  //  这个方法先返回一个估算的cell高度

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
	return 30.0f;
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
	topV.backgroundColor = [UIColor clearColor];
    
	UILabel *topTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 315, 30)];
	topTimeLB.backgroundColor = [UIColor clearColor];
    
    
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"   yyyy年 MM月 dd日"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
	topTimeLB.text = currentDateStr;
	topTimeLB.font = [UIFont systemFontOfSize:14.0];
	topTimeLB.textColor = [CW_Tools colorFromHexRGB:@"868686"];
	topTimeLB.backgroundColor = [CW_Tools colorFromHexRGB:@"f3f9f2"];
    
	[topV addSubview:topTimeLB];
	return topV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *easyCellIndentifier = @"easyCellIndentifier";
    static NSString *cellIndentifier = @"cellIndentifier";
    int row = indexPath.row;
    
    contentClass *content = [_list objectAtIndex:row];
    
    if (isTuiJian) {
        GKListCell *listCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (listCell == nil) {
            listCell = [[[NSBundle mainBundle]loadNibNamed:@"GKListCell" owner:self options:nil]lastObject];
        }
        listCell.contentOBJ = content;
        return listCell;
    }
    else {
        GKListEasyCell *easyCell = [tableView dequeueReusableCellWithIdentifier:easyCellIndentifier];
        if (easyCell == nil) {
            easyCell = [[[NSBundle mainBundle]loadNibNamed:@"GKListEasyCell" owner:self options:nil] lastObject];
        }
        easyCell.content = content;
        
        return easyCell;
    }
    /*
	UITableViewCell * cell  =  (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil)
                {
				cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                UIImageView *cellImageV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 100, 70)];
                cellImageV.tag = 2008;
                
                UILabel *cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 200, 70)];
                cellLabel.tag = 2009;
                cellLabel.font = [UIFont systemFontOfSize:20.0f];
                cellLabel.numberOfLines = 0;
                cellLabel.contentMode = UIViewContentModeScaleAspectFit;
                cellLabel.textColor = [UIColor blackColor];
                
                
                
                [cell.contentView addSubview:cellImageV];

                [cell.contentView addSubview:cellLabel];

			}
            
			contentClass *content = [_list objectAtIndex:row];
			if (content.cImage.length > 0) {
                
                UIImageView *cellIV = (UIImageView *)[cell.contentView viewWithTag:2008];
                [cellIV setImageWithURL:[NSURL URLWithString:content.cImage]];
                
                UILabel *cellLB = (UILabel *)[cell.contentView viewWithTag:2009];
                if ([readedSet containsObject:indexPath]) {
                   cellLB.textColor = [UIColor grayColor];
                }
               cellLB.text = content.cTitle;
			} else {
                
                if ([readedSet containsObject:indexPath]) {
                    cell.textLabel.textColor = [UIColor grayColor];
                }
                cell.textLabel.text = content.cTitle;
            }
			
    
	return cell;
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	
    if (_list.count > 0) {
        contentClass *selectContent = nil;
		selectContent = [_list objectAtIndex:indexPath.row];
        [self hasReaded:indexPath];
	
	[self.delegate OpenCVCByCID:selectContent.cnID NID:selectContent.cID Title:selectContent.cTitle Image:selectContent.cImage];
        }
}

#pragma mark - 焦点图点击响应
- (void)EScrollerViewDidClicked:(NSUInteger)index {
    if (!isNetOk) {
        [CW_Tools ToastViewInView:self.view withText:@"没有网络!"];
        return;
    }
    
    [self.delegate OpenWebViewByUrl:((TuiJianThumbClass *)thumbDataArray[index-1]).url];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods


/**
 *    显示正在加载数据 这里不需要任何操作
 */
- (void)reloadTableViewDataSource {
	_reloading = YES;
}
/**
 *    数据加载完成后,需要在这里弹回视图
 */
- (void)doneLoadingTableViewData {
	_reloading = NO;
	//--------清楚缓存
    if (isNetOk) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.asiCache clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    }
    
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableViewList];
	[self showBarView];
}
/**
 *    视图正在滚动
 *
 *    @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
/**
 *    视图滚动结束
 *
 *    @param scrollView <#scrollView description#>
 *    @param decelerate <#decelerate description#>
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    //    else {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    //    }
    //--------需要判断是否还能加载 
    float offset = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float sub = contentHeight - offset;
    if (scrollView.height - sub > 30) {
        DLog(@"上拉刷新");
        [self loadMore];
    }
}

#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
	[self reloadTableViewDataSource];
    //--------这里处理网络加载数据 加载完成后 调用 doneload 弹回视图
    [self addDataToViewISPullUp:NO];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];


}

#pragma mark 显示下拉条和声效
- (void)showBarView {
	if (_barView == nil) {
		UIImage *img = [[UIImage imageNamed:@"timeline.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
		_barView = [[UIImageView alloc] initWithImage:img];
		_barView.frame = CGRectMake(5, -30, 320 - 10, 30);
		[self.view addSubview:_barView];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.tag = 100;
		label.font = [UIFont systemFontOfSize:16.0f];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[_barView addSubview:label];
	}
	UILabel *label = (UILabel *)[_barView viewWithTag:100];
    	[label sizeToFit];
    CGRect frame = label.frame;
	frame.origin = CGPointMake((_barView.frame.size.width - frame.size.width) / 2, (_barView.frame.size.height - frame.size.height) / 2);
	label.frame = frame;
	//    label.text = [NSString stringWithFormat:@"%d条微博更新",10];
    
    if (isNetOk) {
        
        label.text = @"刷新成功!";
    } else {
         label.text = @"没有网络!";
    }

	
	//    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
	[self performSelector:@selector(updateUI) withObject:nil afterDelay:0.0];
}

- (void)updateUI {
    
	[UIView animateWithDuration:0.6 animations: ^{
	    CGRect frame = _barView.frame;
	    frame.origin.y = 1;//barview从-30 移动到 1
	    _barView.frame = frame;
	} completion: ^(BOOL finished) {
	    if (finished) {
	        [UIView beginAnimations:nil context:nil];
	        [UIView setAnimationDelay:2.0];
	        [UIView setAnimationDuration:0.6];
	        CGRect frame = _barView.frame;
	        frame.origin.y = -30; //从1 移动回 -30
	        _barView.frame = frame;
	        [UIView commitAnimations];
            
		}
	}];
    
	/**
	 *    播放声音
	 */
	NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
	NSURL *url = [NSURL fileURLWithPath:path];
	SystemSoundID soundId;
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
	AudioServicesPlaySystemSound(soundId);
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
	return _reloading; // should return if data source model is reloading
}

//取得下拉刷新的时间
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
	return [NSDate date]; // should return date data source was last changed
}



#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
