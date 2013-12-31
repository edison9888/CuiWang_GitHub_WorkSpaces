//
//  BaseExamViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-11-8.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "PanelsViewController.h"
#import "myDB.h"
#import "SubType_Comm.h"
#import "VCPassValueDelegate.h"
@interface BaseExamViewController : PanelsViewController {
    NSMutableArray *panelsArray;
    UIButton *_backBtn,*_tipBtn,*_cardBtn,*_timeBtn;
    UILabel *_timeLb;
    UIView *_TopView;
    NSTimer *timer;
    NSMutableArray *items; //测试用
    MBProgressHUD *HUD;
    BOOL initNew;
    BOOL wrongViewOpen;
    float topHeight;
    float cellHeight;
    int mTime;
    int uNum;
    myDB *loadExamDB;
    SubType_Comm *thisSub;
    SubType_Comm *thisSpecialSub;
    SubType_Comm *thisRealSub;
    SubType_Comm *cellData;
    NSMutableArray *dataArray;
    bool Exam_isFirstLoad;
    bool Exam_isSave;
    int PGnum;
    UIImageView *topImgV;
    NSString *initTempTable;
    NSString *initTableName;
    NSString *initTempIndexString;
    NSString *initIndexString;
    NSString *initSelectName;
    NSString *initWhere;
    NSArray *imgArray;
    NSString *thisString;
    NSUserDefaults *ud;
}
@property(nonatomic,strong) NSMutableArray *panelsArray;
@property(nonatomic,strong)NSArray *tableDictionary;
@property(nonatomic,strong) id <VCPassValueDelegate>delegate;
- (id)initNeednewData:(BOOL)initnew andDataFromwitchTable:(NSString *)tableName selectWith:(NSString *)detail is:(NSString *)selectName where:(NSString *)where;
-(id)initViewWithTableDictionary:(NSArray *)tableDic AndTitle:(NSString *)title;
@end
