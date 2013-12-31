//
//  specialViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-1.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "ResignsetrViewController.h"
#import "myDB.h"
#import "Special_Table.h"

@interface specialViewController : ResignsetrViewController
{
    @private
    NSMutableArray *nameArray;
    NSMutableArray *typeArray;
    NSArray *typearray;
    myDB *loadSpecialDB;
    Special_Table *spTB;
}
@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)UITableView *sptableView;
@end
