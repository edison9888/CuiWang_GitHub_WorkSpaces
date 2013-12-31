//
//  realselectViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-1.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "specialViewController.h"
#import "myDB.h"
#import "GRAlertView.h"

@interface realselectViewController : specialViewController
{
    myDB *loadRealSelectDB;
    GRAlertView *alert;
    NSString *fatherType;
    NSString * fatherContent;
    NSString *value_zt;
    NSMutableArray *realDataArray;
    NSMutableArray *netDataArray;
    
    BOOL Exam_isSave;
    BOOL Special_isSave;
    BOOL Real_isSave;
    BOOL stillnext;
    BOOL Real_isfirst;
}
-(id)initWithFatherType:(NSString *)type andContent:(NSString *)content;
@end
