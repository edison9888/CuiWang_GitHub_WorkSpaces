//
//  surveyViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-3.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface surveyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *surveyTV;
@property(nonatomic,strong)NSIndexPath * lastIndexPath;
@end
