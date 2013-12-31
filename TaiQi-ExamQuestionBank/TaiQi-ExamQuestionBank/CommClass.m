//
//  CommClass.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-12-5.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "CommClass.h"

@implementation CommClass

static CommClass * _sharedInstance = nil;
//方法实现
+ (id) sharedInstance
{
    @synchronized ([CommClass class])
    {
        if (_sharedInstance == nil)
        {
            _sharedInstance = [[CommClass alloc] init];
        }
    }
    return _sharedInstance;
}

#pragma mark 生成随机数
//------生成不重复的随机数
-(NSMutableArray *)randomSub:(int)size
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 0; i<=size; i++) {
        [temp addObject:[NSNumber numberWithInt:i]];
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:temp];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    int i;
    int count = temp.count;
    for (i = 0; i < count; i ++) {
        int index = arc4random() % (count - i);
        [resultArray addObject:[tempArray objectAtIndex:index]];
        [tempArray removeObjectAtIndex:index];
    }
    return resultArray;
}
//------生成不重复的随机数2
-(NSMutableArray *)randomSub2:(int)size
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 1; i<size+1; i++) {
        [temp addObject:[NSNumber numberWithInt:i]];
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:temp];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    int i;
    int count = temp.count;
    for (i = 0; i < count; i ++) {
        int index = arc4random() % (count - i);
        [resultArray addObject:[tempArray objectAtIndex:index]];
        [tempArray removeObjectAtIndex:index];
    }
    return resultArray;
}
#pragma mark MB提示框
-(void)showMBdailog:(NSString *)str inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.yOffset = 20.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}
#pragma mark- 去掉HTML标签
-(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    while ([theScanner isAtEnd] == NO)
        {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
        }
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}
@end
