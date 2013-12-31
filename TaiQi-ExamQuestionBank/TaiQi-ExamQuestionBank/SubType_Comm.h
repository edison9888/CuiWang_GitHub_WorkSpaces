//
//  SubType_Fast.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-11.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SubType_Comm : NSObject

@property(nonatomic,strong)NSNumber *Sub_Id; //在题库中的位置
@property(nonatomic,strong)NSString *Sub_Type; //题目来自于哪个主类型
@property(nonatomic,strong)NSString *Sub_Name; //题目来自于哪个类型
@property(nonatomic,strong)NSString *Sub_Title; //题目标题
@property(nonatomic,strong)NSString *Sub_A;//A
@property(nonatomic,strong)NSString *Sub_B;//B
@property(nonatomic,strong)NSString *Sub_C;//C
@property(nonatomic,strong)NSString *Sub_D;//D
@property(nonatomic,strong)NSString *Sub_Right;//正确答案
@property(nonatomic,strong)NSString *Sub_Analyse;//分析

@end
