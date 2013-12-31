//
//  ShoucanViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-12-2.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseViewController.h"
#import "myDB.h"
@interface ShoucanViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    myDB *LoadShoucangDB;
    NSMutableArray *ShoucangArray;
    UIImageView *nothing;
    UILabel *lb;
    BOOL userIsLoaded;
    UIButton *button;
}
@property (strong, nonatomic) IBOutlet UITableView *myShouCangTableView;

@end
