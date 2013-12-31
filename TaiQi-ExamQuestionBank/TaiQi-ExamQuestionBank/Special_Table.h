//
//  Special_Table.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-17.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Special_Table : NSObject

@property(nonatomic,strong)NSString *Special_Type; //在题库中的位置
@property(nonatomic,strong)NSString *Special_Content; //在题库中的位置
@property(nonatomic,strong)NSNumber *Sub_Id; //题目来自于哪个类型
@property(nonatomic,strong)NSNumber *Special_Type_Num; //在题库中的位置
@property(nonatomic,strong)NSNumber *Special_Type_Id; //题目来自于哪个类型
@end
