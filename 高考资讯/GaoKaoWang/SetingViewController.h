//
//  SetingViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-12-2.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseViewController.h"

@interface SetingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *tabArray;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
