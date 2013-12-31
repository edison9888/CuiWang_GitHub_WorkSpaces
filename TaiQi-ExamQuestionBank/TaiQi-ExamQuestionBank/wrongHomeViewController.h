//
//  wrongHomeViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-3.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "realViewController.h"
#import "myDB.h"
#import "History_Space.h"

@interface wrongHomeViewController : realViewController
{
    NSMutableArray *dataArray;
    NSMutableArray *HistoryArray;
    NSMutableArray * mutableDictionary ;
    myDB *loadWrongDB;
    History_Space *thisHistory;
    NSArray* reversedArray;
    int total;
    int rightcount;
    History_Space *history_Space;
}
@property(nonatomic,strong)UITableView *wrongTV;
@property(nonatomic,strong)UILabel *topLB;
@property(nonatomic,strong)UILabel *botLB;
@property(nonatomic,strong)UIView *topV;
@end
