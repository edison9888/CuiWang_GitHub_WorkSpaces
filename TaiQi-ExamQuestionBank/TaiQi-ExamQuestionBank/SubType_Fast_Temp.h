//
//  SubType_Fast_Temp.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-12.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubType_Fast_Temp : NSObject

@property(nonatomic,strong)NSNumber *Sub_Temp_Id;//在table中的位置 通subtype_fast里面一样
@property(nonatomic,strong)NSString *Sub_Table;//哪个table 来源于subtype_fast这个表中的题 用于继续练习
@property(nonatomic,strong)NSString *Sub_Num;// 在temp表中的物理位置
@property(nonatomic,strong)NSString *Sub_Mark;//是否标记了
@property(nonatomic,strong)NSString *Sub_Choosed;//用户选中的那项
@property(nonatomic,strong)NSString *Sub_Choose_Right;//正确答案是
@property(nonatomic,strong)NSNumber *Sub_Time;//时间

@end
