//
//  GKListViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-22.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EScrollerView.h"
#import "EGORefreshTableHeaderView.h"

@protocol contentVCPassValue <NSObject>

@required

-(void)OpenCVCByCID:(NSString *)catid NID:(NSString *)nid Title:(NSString *)title Image:(NSString *)image;
-(void)OpenWebViewByUrl:(NSString *)url;

@end

@interface GKListViewController : UIViewController <EGORefreshTableHeaderDelegate, EScrollerViewDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>
{
	EGORefreshTableHeaderView *_refreshHeaderView;
	UITableView *_tableViewList;
	BOOL _reloading;
	BOOL failed;
	UILabel *topTimeLB;
	NSString *_catid;
	int timerValue;
	MBProgressHUD *HUD;
	NSMutableSet *readedSet;
	BOOL _loadingMore;
	BOOL _loadingFull;
    NSMutableArray *thumbDataArray;
}
@property (nonatomic, unsafe_unretained) id <contentVCPassValue> delegate;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSString *catid;
@property (strong, nonatomic) IBOutlet UITableView *tableViewList;
@property (nonatomic, strong) UIImageView *barView;
@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSArray *bannerTextArray;
@property (nonatomic, strong) NSMutableArray *list;
- (void)viewWillCurrentView;
- (void)viewDidCurrentView;
@end
