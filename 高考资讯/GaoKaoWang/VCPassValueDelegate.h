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
- (void)passValue:(id)value;
// 可选方法

@optional
-(void)passIntValue:(int)value;
-(void)passStringValue:(NSString *)value;

-(void)passObjValue:(id)value;

@end
