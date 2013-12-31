//
//  assessViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-2.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "specialViewController.h"
#import "myDB.h"
#import "History_Space.h"

@interface assessViewController : specialViewController
{
@private
    BOOL _didDownloadData;
    
    NSArray *_dataArray;
    myDB *loadAssessDB;
    
    NSMutableDictionary *thisDiction;
    NSMutableDictionary *thisValueDiction;
    NSMutableDictionary *totalDic;
    NSMutableDictionary *rightDic;
    NSMutableArray *mainArray;
    NSMutableArray *mainValueArray;
    
    
    NSMutableArray *dataMutableArray;
    myDB *loadWrongDB;
    History_Space *thisHistory;
    
//     int  mTime;
    NSString* mDate;
}
@property (nonatomic,strong)UIView *TopView;
@property (nonatomic,strong)UILabel *timeLb;
@property (nonatomic,strong)NSString* mDate;
@property (nonatomic,strong)UITableView* assTV;



@end
