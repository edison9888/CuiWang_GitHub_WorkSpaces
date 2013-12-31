//
//  Step1ViewController.h
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-9-23.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@protocol PassListValueDelegate
- (void)setListlValue:(NSDictionary *)listDictionary;
@end
@interface Step1ViewController : UIViewController<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
MBProgressHUDDelegate
>
{
    UITextField *theTextField;
    NSString *name;
    NSString *sex;
    NSString *tel;
    NSString *phone;
    NSString *email;
    NSString *work_experience;
    NSString *education;
    NSString *school;
    NSString *admin_name;
    NSString *student_id;
    MBProgressHUD *HUD;
    id<PassListValueDelegate> PassListValueDelegate;
}
@property(nonatomic, strong) id<PassListValueDelegate> PassListValueDelegate;

@property(nonatomic,strong) IBOutlet UITableViewCell *tableCell;
@property(nonatomic,strong)NSArray* leftArray;
@property(nonatomic,strong)NSArray* fieldArray;
@property(nonatomic,strong)NSArray* subArray;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *nextPageButton;
@property (strong, nonatomic) IBOutlet UIButton *backPageButton;
@property (strong, nonatomic) IBOutlet UIButton *imageview;


@end
