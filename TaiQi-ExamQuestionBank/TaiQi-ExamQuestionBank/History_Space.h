//
//  History_Space.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-13.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History_Space : NSObject

@property(nonatomic,strong)NSString *History_Type;//习题类型
@property(nonatomic,strong)NSString *History_Name;//习题类型
@property(nonatomic,strong)NSString *History_Table;//哪个table 来源于subtype_fast这个表中的题 用于继续练习
@property(nonatomic,strong)NSString *History_Serial;// 题目序列
@property(nonatomic,strong)NSString *History_Choosed;//用户选择序列
@property(nonatomic,strong)NSString *History_Right;//正确答案序列
@property(nonatomic,strong)NSString *History_Mark;//正确答案序列
@property(nonatomic,strong)NSString *History_Time;//交卷时间
@property(nonatomic)int History_Total;//总共多少题
@property(nonatomic)int History_RightNum;//正确多少
@property(nonatomic,strong)NSNumber *History_UseTime;//做题耗时时间

@end
