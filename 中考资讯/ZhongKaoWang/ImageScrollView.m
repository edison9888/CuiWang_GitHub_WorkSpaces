//
//  ImageScrollView.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-20.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "ImageScrollView.h"
#import "GKSlideSwitchView.h"
@implementation ImageScrollView


-(id)initWithFrame:(CGRect)frame setCellBannerWithImageArray:(NSArray *)imageArray andText:(NSArray *)str
{
    self = [super initWithFrame:frame];
    if (self)
        {
        
        NSArray *BannerArray = [NSArray arrayWithArray:imageArray];
        for (int i = 0; i < 3; i++)
            {
            helpImage = [[UIImageView alloc] initWithFrame:CGRectMake(315 * i, 0, 315, 158)];
            [
             helpImage setImageWithURL:[NSURL URLWithString:BannerArray[i]]
                       placeholderImage:[UIImage imageNamed:@"pic.png"]];
            helpImage.userInteractionEnabled = YES;
            //设置点击方法
            UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.frame = helpImage.bounds;
            maskBtn.backgroundColor = [UIColor clearColor];
            [maskBtn addTarget:self action:@selector(imageClick) forControlEvents:UIControlEventTouchUpInside];
            [helpImage addSubview:maskBtn];
            [self addSubview:helpImage];
            
            UILabel *imageLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, 157, 22)];
            imageLb.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pic_bg.png"]];
            imageLb.font = [UIFont systemFontOfSize:15.0];
            imageLb.textColor = [GKSlideSwitchView colorFromHexRGB:@"505554"];
            NSString *string = [NSString stringWithFormat:@"  %@",str[i]];
            imageLb.text = string;
            
            [helpImage addSubview:imageLb];
            
            }
        
        }
    return self;
}
//  焦点图片点击响应
-(void)imageClick
{
//    NSString *textURL = @"http://www.taiqiedu.com/";
//    NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", textURL]];
//    [[UIApplication sharedApplication] openURL:cleanURL];
}

@end
