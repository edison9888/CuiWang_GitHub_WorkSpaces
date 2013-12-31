//
//  BasePageControl.m
//  FlickTabControlDemo
//
//  Created by cui wang on 13-4-25.
//
//

#import "BasePageControl.h"

@implementation BasePageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.hidesForSinglePage = YES;
        self.userInteractionEnabled = NO;
        self.numberOfPages = 3; //总页码
        self.currentPage = 0;    //当前页码
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
