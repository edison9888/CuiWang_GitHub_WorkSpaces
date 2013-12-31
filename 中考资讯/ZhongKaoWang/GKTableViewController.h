//
//  GKTableViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-22.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScrollView.h"
#import "BasePageControl.h"

@interface GKTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
   UITableView *_tableViewList;
    ImageScrollView *imageScrollView;
    BasePageControl  *pageControl;
}

@property(nonatomic,retain)NSArray * bannerArray;
@property(nonatomic,retain)NSArray * bannerTextArray;
@property(nonatomic,retain)NSMutableArray *list;
@property(nonatomic,retain)UITableView *tableViewList;
- (void)viewDidCurrentView;
@end
