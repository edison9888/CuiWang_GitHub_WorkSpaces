//
//  LoadViewController.h
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-9-16.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface LoadViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UIButton *jizhumima;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *password;

@end
