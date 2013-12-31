//
//  ResignsetrViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-19.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCPassValueDelegate.h"
@interface ResignsetrViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate,VCPassValueDelegate>
{
    TPKeyboardAvoidingTableView *theTableView;
    UITextField *theTextField;
    UIButton *maskBtn;
    MBProgressHUD *HUD;
    NSString *userID;
}
@property(nonatomic,strong)NSArray *worldArray;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *email;
@property (nonatomic,strong)UIImageView *TopView;
@property(nonatomic,strong)UIButton *maskBtn;
@property(nonatomic,strong) NSString *regex;
@property(nonatomic,strong) NSString *regex2;
@property(nonatomic,strong)MBProgressHUD *HUD;
@property(nonatomic,strong) UITableView *theTableView;

@end
