//
//  SLCoverView.m
//  SLCoverFlow
//
//  Created by jiapq on 13-6-19.
//  Copyright (c) 2013年 HNAGroup. All rights reserved.
//

#import "SLCoverView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SLCoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]]];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
        [_imageView addGestureRecognizer:singleTap];
        [self addSubview:_imageView];
//        
//        imageView2 = [[UIImageView alloc] initWithFrame:self.bounds];
//        imageView2.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        imageView2.userInteractionEnabled = YES;
//        UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
//        [imageView2 addGestureRecognizer:singleTap2];
        
        
    }
    return self;
}

-(void)UesrClicked:(id)sender
{
//    webViewController *webView = [[webViewController alloc]init];
//    webView.urlString = @"http://www.baidu.com";
    
    NSLog(@"clcik   %d",_imageView.tag);
     [[NSNotificationCenter defaultCenter] postNotificationName:@"openWeb" object:@"http://www.taiqiedu.com"];
//    [delegate OpenWebViewWithID:_imageView.tag];
    
    
}
@end
