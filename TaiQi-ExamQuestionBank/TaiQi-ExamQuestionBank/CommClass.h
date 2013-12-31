//
//  CommClass.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-12-5.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommClass : NSObject
//--------单例
+ (id) sharedInstance;
//--------随机0~size-1
-(NSMutableArray *)randomSub:(int)size;
//--------随机1~size
-(NSMutableArray *)randomSub2:(int)size;
//--------显示只有文字的对话框 类似toast
-(void)showMBdailog:(NSString *)str inView:(UIView *)view;
//--------取消html标签
-(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;
@end
