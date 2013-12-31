//
//  LoadViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-27.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "subMMDrawerController.h"
@interface LoadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *titleArray;
    NSArray *nameArray;
    NSArray *inlineArray;
    NSArray *thirdTypeArray;
    NSString *name;
    NSString *password;
    
    NSDictionary *titleDictionary;
    id<VCPassValueDelegate> PassValueDelegate;
    MBProgressHUD *HUD;
    NSUserDefaults *ud;
    subMMDrawerController * DrawerController;
    
    BOOL isThirdLoading;
    
    NSString *third_UID;
    NSString *third_UTYPE;
    NSString *third_UserTYPE;

}
@property(nonatomic, strong) id<VCPassValueDelegate> PassValueDelegate;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIButton *LoadButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *justLoadButton;
@property (strong, nonatomic) IBOutlet UIButton *sinaButton;
@property (strong, nonatomic) IBOutlet UIButton *qqButton;
@property (strong, nonatomic) IBOutlet UIButton *qqwbButton;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

@end
