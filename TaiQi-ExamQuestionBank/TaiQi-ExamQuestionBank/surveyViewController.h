//
//  surveyViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-3.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "specialViewController.h"

@interface surveyViewController : specialViewController
@property(nonatomic,strong)UITableView *surveyTV;
@property(nonatomic,strong)NSIndexPath * lastIndexPath;
@end
