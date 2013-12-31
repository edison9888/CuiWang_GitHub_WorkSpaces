//
//  BaseViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-11-6.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


-(void)regexForString:(NSString *)string Regex:(NSString *)gegex Word:(NSString *)word localtion:(int) local;
-(NSString *)getDataFromURLUseString:(NSString *)urlSS;
@end
