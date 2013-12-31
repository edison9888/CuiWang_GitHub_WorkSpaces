//
//  englishViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-1.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "specialViewController.h"
#import "myDB.h"
#import "Special_Table.h"
#import "GRAlertView.h"
@interface specialSecondViewController : specialViewController
{
    BOOL Fast_isSave;
    BOOL Special_isSave;
    BOOL Real_isSave;
    BOOL stillnext;
    BOOL Special_isfirst;
    GRAlertView *alert;
    Special_Table *SpTB;
    myDB *loadEnglishDB;
//    NSArray *resultDict;
    NSString *detailString;
    NSMutableArray *dataArray;
    NSMutableArray *netDataArray;
    NSString *fatherType;
    int             fatherIndex;
    int userClickIndex;

}
- (id)initWithType:(NSString *)type andIndex:(int)index;
@end
