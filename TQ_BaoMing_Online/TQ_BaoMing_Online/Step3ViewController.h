//
//  Step3ViewController.h
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-9-24.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@protocol PasswebValueDelegate
- (void)setwebValue:(NSString *)urlstring;
@end
@interface Step3ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSString *jiage;
    NSString *zhekou;
    UITextField *footTF;
    UITextField *jgTF;
    UITextField *zkTF;
    NSString *regex;
    NSString *regex2;
    MBProgressHUD *HUD;
    NSArray *saveArray;
    NSString* date;
    id<PasswebValueDelegate> PasswebValueDelegate;
}
@property(nonatomic, strong) id<PasswebValueDelegate> PasswebValueDelegate;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UILabel *yuanjia;
@property (strong, nonatomic) IBOutlet UILabel *youhui;
@property (strong, nonatomic) IBOutlet UIButton *pay;

@end
