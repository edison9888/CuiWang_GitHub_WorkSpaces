//
//  answerViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-27.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myDB.h"
#import "numView.h"
#import "History_Space.h"
//#import "VCPassValueDelegate.h"

@interface answerViewController : UIViewController
{
        myDB *loadAnswerDB;
        NSString *History_Time;
    History_Space *thisHistory;
    int local;// 判断从打开的
    int uNum;
    BOOL isWrong;
}

-(id)initWithIndex:(int)index Data:(NSString *)dataString Wrong:(BOOL)wrong;

@property (nonatomic,strong)UIImageView *TopView;
@property (nonatomic,strong)UIView *MidView;

@property(nonatomic,strong)UILabel *titleLbs;
@property(nonatomic,strong)UILabel *Lb2;
@property(nonatomic,strong)UILabel *Lb4;
@property(nonatomic,strong)UILabel *imgLb;
@property(nonatomic) int obj;
@property(nonatomic)int  mTime;
@property(nonatomic,strong)numView *num;
@property(nonatomic,strong)NSString * mTitle;
@end
