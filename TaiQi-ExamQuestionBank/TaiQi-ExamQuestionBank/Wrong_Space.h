//
//  Wrong_Space.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-14.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wrong_Space : NSObject

@property(nonatomic,strong)NSNumber *Wrong_Id; //在错题库中的位置
@property(nonatomic,strong)NSString *Wrong_Type; //错题类型
@property(nonatomic,strong)NSString *Wrong_Name; //错题类型 (快速智能,专项英语)
@property(nonatomic,strong)NSString *Wrong_Time; //错题类型 (快速智能,专项英语)
@property(nonatomic,strong)NSString *Wrong_Table; //错题在哪个表
@property(nonatomic,strong)NSNumber *Wrong_Num;//表中的位置
//@property(nonatomic,strong)NSString *Wrong_B;//B
//@property(nonatomic,strong)NSString *Wrong_C;//C
//@property(nonatomic,strong)NSString *Wrong_D;//D
//@property(nonatomic,strong)NSString *Wrong_Right;//正确答案
//@property(nonatomic,strong)NSString *Wrong_Analyse;//分析

@end
