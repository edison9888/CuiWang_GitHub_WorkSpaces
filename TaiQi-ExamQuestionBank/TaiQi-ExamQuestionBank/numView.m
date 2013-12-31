//
//  numView.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-28.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "numView.h"

@implementation numView
@synthesize bt1;
@synthesize bt2;
@synthesize bt3;
@synthesize bt4;
@synthesize bt5;
@synthesize bt6;
@synthesize bt7;
@synthesize bt8;
@synthesize bt9;
@synthesize bt10;
@synthesize bt11;
@synthesize bt12;
@synthesize bt13;
@synthesize bt14;
@synthesize bt15;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt1.frame = CGRectMake(20, 0, 28, 28);
        [bt1 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt1 setTitle:@"1" forState:UIControlStateNormal];
        bt1.hidden = YES;
        
        bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt2.frame = CGRectMake(56, 0, 28, 28);
        [bt2 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt2 setTitle:@"2" forState:UIControlStateNormal];
        bt2.hidden = YES;

        bt3 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt3.frame = CGRectMake(92, 0, 28, 28);
        [bt3 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt3 setTitle:@"3" forState:UIControlStateNormal];
        bt3.hidden = YES;

        bt4 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt4.frame = CGRectMake(128, 0, 28, 28);
        [bt4 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt4 setTitle:@"4" forState:UIControlStateNormal];
        bt4.hidden = YES;

        
        bt5 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt5.frame = CGRectMake(164, 0, 28, 28);
        [bt5 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt5 setTitle:@"5" forState:UIControlStateNormal];
        bt5.hidden = YES;

        bt6 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt6.frame = CGRectMake(200, 0, 28, 28);
        [bt6 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt6 setTitle:@"6" forState:UIControlStateNormal];
        bt6.hidden = YES;

        bt7 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt7.frame = CGRectMake(236, 0, 28, 28);
        [bt7 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt7 setTitle:@"7" forState:UIControlStateNormal];
        bt7.hidden = YES;

        
        bt8 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt8.frame = CGRectMake(272, 0, 28, 28);
        [bt8 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt8 setTitle:@"8" forState:UIControlStateNormal];
        bt8.hidden = YES;

        bt9 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt9.frame = CGRectMake(20, 54, 28, 28);
        [bt9 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt9 setTitle:@"9" forState:UIControlStateNormal];
        bt9.hidden = YES;

        bt10 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt10.frame = CGRectMake(56, 54, 28, 28);
        [bt10 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt10 setTitle:@"10" forState:UIControlStateNormal];
        bt10.hidden = YES;

        
        bt11 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt11.frame = CGRectMake(92, 54, 28, 28);
        [bt11 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt11 setTitle:@"11" forState:UIControlStateNormal];
        bt11.hidden = YES;

        bt12 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt12.frame = CGRectMake(128, 54, 28, 28);
        [bt12 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt12 setTitle:@"12" forState:UIControlStateNormal];
        bt12.hidden = YES;

        bt13 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt13.frame = CGRectMake(164, 54, 28, 28);
        [bt13 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt13 setTitle:@"13" forState:UIControlStateNormal];
        bt13.hidden = YES;

        
        bt14 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt14.frame = CGRectMake(200, 54, 28, 28);
        [bt14 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt14 setTitle:@"14" forState:UIControlStateNormal];
        bt14.hidden = YES;

        bt15 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt15.frame = CGRectMake(236, 54, 28, 28);
        [bt15 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [bt15 setTitle:@"15" forState:UIControlStateNormal];
        bt15.hidden = YES;

        
        [self addSubview:bt1];
        [self addSubview:bt2];
        [self addSubview:bt3];
        [self addSubview:bt4];
        [self addSubview:bt5];
        [self addSubview:bt6];
        [self addSubview:bt7];
        [self addSubview:bt8];
        [self addSubview:bt9];
        [self addSubview:bt10];
        [self addSubview:bt11];
        [self addSubview:bt12];
        [self addSubview:bt13];
        [self addSubview:bt14];
        [self addSubview:bt15];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
