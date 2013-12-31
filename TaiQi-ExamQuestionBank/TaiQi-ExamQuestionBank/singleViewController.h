//
//  singleViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-14.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "specialViewController.h"
#import "History_Space.h"
#import "SubType_Comm.h"
#import "myDB.h"

@interface singleViewController : specialViewController
{
    History_Space *thisHistory;
    SubType_Comm *thisFast;
    SubType_Comm *thisSpecial;
    SubType_Comm      *thisReal;
    myDB *loadSingleDB;
    UILabel *botLB;
    int choosed;
    NSString *righted;
    UIImageView *right;
}

@property(nonatomic)int thisindex;
@property(nonatomic,strong)UITableView *singleTBView;
-(id)initWithIndex:(int)index Data:(NSArray *)dataArray;
@end
