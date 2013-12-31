//
//  Step2bj1ViewController.h
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-10-10.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Step2ViewController.h"
@interface Step2bj1ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PassTaocanValueDelegate>
{
    NSMutableArray *taocanIdArray;
    NSMutableArray *titleArray;
    NSMutableArray *classArray;
    NSIndexPath *lastIndexPath;
    NSMutableArray *chooseArray;
}
@property (strong, nonatomic) IBOutlet UITableView *TB1;

@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

@end
