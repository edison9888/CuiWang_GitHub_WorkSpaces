//
//  userInfo.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-9.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "userInfo.h"

@implementation userInfo
@synthesize TK_UserName;
@synthesize TK_UserPasswd;
@synthesize TK_UID;

-(void)toString
{
    NSLog(@"TK_UserName = %@,TK_UserPasswd = %@,TK_UID = %@",TK_UserName,TK_UserPasswd,TK_UID);
}
@end
