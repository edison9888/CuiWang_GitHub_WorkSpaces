//
//  LoadingViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-13.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCPassValueDelegate.h"
@interface LoadingViewController :BaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    NSString *loadStat;
    TPKeyboardAvoidingTableView *_tableView;
    UITextField *theTextField;
    id<VCPassValueDelegate> PassValueDelegate;
}
@property(nonatomic, strong) id<VCPassValueDelegate> PassValueDelegate;

@property(nonatomic,strong)NSArray *worldArray;
@property(nonatomic,strong)NSArray *nameArray;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong) NSString *regex;
@property(nonatomic,strong) NSString *regex2;
@property(nonatomic,strong)TPKeyboardAvoidingTableView *tableView;
@end
