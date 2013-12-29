//
//  RegisterViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-27.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RegisterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,VCPassValueDelegate>
{
    NSArray *nameArray;
    NSArray *inlineArray;
    NSArray *shareArray;
    NSString *zhanghao;
    NSString *nicheng;
    NSString *password;
    NSString *passwd;
    NSString * userID;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UIButton *danxuanButton;
@property (strong, nonatomic) IBOutlet UIButton *close;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UITableView *myRegisterTableView;
@property (strong, nonatomic) IBOutlet UIButton *readButton;

@end
