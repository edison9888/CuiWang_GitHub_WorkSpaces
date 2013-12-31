//
//  realViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-1.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "specialViewController.h"
#import "myDB.h"
#import "GRAlertView.h"
@interface realViewController : specialViewController
{
    myDB *loadRealDB;
    GRAlertView *alert;
    NSString *valueString;
    NSString *valueCityString;
    NSMutableArray *realnameArray;
    NSMutableArray *realtypeArray;
    NSArray *realtypearray;
    
    BOOL stillnext;
    BOOL Exam_isSave;
    BOOL Special_isSave;
    BOOL Real_isSave;
    BOOL Real_isfirst;
    NSMutableArray *TJrealnameArray;
    NSMutableArray *TJrealtypeArray;
    NSArray *TJrealtypearray;
//    NSMutableArray *dataArray;
    NSMutableArray *netDataArray;
}
@property(nonatomic,strong) UIButton *leftBtn;
@property(nonatomic,strong) UIButton *rightBtn;
@property(nonatomic,strong) NSMutableArray *listOfMovies;
@property(nonatomic,strong) UITableView *retableView;

@end
