//
//  History_Space.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-13.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "History_Space.h"

@implementation History_Space

@synthesize History_Type;//习题类型
@synthesize History_Name;
@synthesize History_Table;//哪个table 来源于subtype_fast这个表中的题 用于继续练习
@synthesize History_Serial;// 题目序列
@synthesize History_Choosed;//用户选择序列
@synthesize History_Right;//正确答案序列
@synthesize History_Mark;//正确答案序列
@synthesize History_Time;//交卷时间
@synthesize History_Total;//总共多少题
@synthesize History_RightNum;//正确多少
@synthesize History_UseTime;//做题耗时时间

@end
