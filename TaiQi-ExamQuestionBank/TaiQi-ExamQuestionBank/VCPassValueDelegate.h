//
//  VCPassValueDelegate.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-13.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VCPassValueDelegate <NSObject>

// 必选方法
- (void)passValue:(NSString *)value;
// 可选方法

@optional
-(void)omethod:(NSString *)value;

@end
