//
//  Step22ViewController.h
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-10-11.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Step2ViewController.h"
@interface Step22ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PassClassValueDelegate>
{
    NSIndexPath *lastIndexPath;
    NSMutableArray *classArray;
    NSMutableArray *classContentArray;
    int oldMoney;
}
@property (strong, nonatomic) IBOutlet UIView *LView;
@property (strong, nonatomic) IBOutlet UITableView *Table;
@property (strong, nonatomic) IBOutlet UILabel *lbnone;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UILabel *finalLb;

@end
