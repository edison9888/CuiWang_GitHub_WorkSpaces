//
//  BaseScrollView.m
//  FlickTabControlDemo
//
//  Created by cui wang on 13-4-25.
//
//

#import "BaseScrollView.h"

@implementation BaseScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentSize=CGSizeMake(self.frame.size.width*3, self.frame.size.height); //可以滚动的大小
        self.scrollsToTop = NO;
//
        self.bounces=    NO;
        self.directionalLockEnabled = YES;
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
