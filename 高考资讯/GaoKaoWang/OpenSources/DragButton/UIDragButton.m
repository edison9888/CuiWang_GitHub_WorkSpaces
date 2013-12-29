//
//  UIDragButton.m
//  Draging
//
//  Created by makai on 13-1-8.
//  Copyright (c) 2013年 makai. All rights reserved.
//

#import "UIDragButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIDragButton
@synthesize location;
@synthesize lastCenter;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title inView:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lastCenter = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
        superView = view;
        [self setTitle:title  forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        UIPanGestureRecognizer *longPress = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [self addGestureRecognizer:longPress];
        [longPress release];
        
    }
    return self;
}


- (void)drag:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:superView];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            [self setAlpha:0.7];
            lastPoint = point;
            [self.layer setShadowColor:[UIColor grayColor].CGColor];
            [self.layer setShadowOpacity:1.0f];
            [self.layer setShadowRadius:10.0f];
//            [self startShake];
            break;
        case UIGestureRecognizerStateChanged:
        {
            float offX = point.x - lastPoint.x;
            float offY = point.y - lastPoint.y;
        
            int btbum = [delegate numofupbutton];
//            int downbtnum = [delegate numofdownbutton];
        
            [self setCenter:CGPointMake(self.center.x + offX, self.center.y + offY)];
            if (self.center.y < 240.0f) { //如果手指移动到上面了 320表示分割线的位置 down->up
                if (self.frame.size.height != 30.0f) {
                    //down->up
//                    if (downbtnum <= 12) {
                    if (btbum < 14) { //最多16个
                        [self setLastCenter:CGPointMake(0, 0)];
                        [self setLocation:up];
                    }
                    [delegate arrangeDownButtonsWithButton:self andAdd:NO];
                    [UIView animateWithDuration:.2 animations:^{
                        [self setFrame:CGRectMake(self.center.x + offX - 33.75f, self.center.y + offY - 15.0f, 67.5f, 30.0f)];
                    }];
//                        }
                } else {
                    //上面的button拖动
                }
            }else{
                if (self.frame.size.height != 35.0f) {
                    //up->down
                    [self setLastCenter:CGPointMake(0, 0)];
                    [self setLocation:down];
                    [delegate arrangeUpButtonsWithButton:self andAdd:NO];
                    [delegate setDownButtonsFrameWithAnimate:YES withoutShakingButton:self];
                    [UIView animateWithDuration:.2 animations:^{
                        [self setFrame:CGRectMake(self.center.x + offX - 33.75f, self.center.y + offY - 17.5f, 67.5f, 35.0f)];
                    }];
                }
            }
            lastPoint = point;
            [delegate checkLocationOfOthersWithButton:self];
            break;
        }
        case UIGestureRecognizerStateEnded:
//            [self stopShake];
            [self setAlpha:1];
            
            switch ( self.location) {
                case up:
                        self.location = up;
                        [UIView animateWithDuration:.5 animations:^{
                            if (self.lastCenter.x == 0) {
                                [delegate arrangeUpButtonsWithButton:self andAdd:YES];
                            }else{
                                [delegate arrangeUpButtonsWithButton:self andAdd:YES];
                                [self setFrame:CGRectMake(lastCenter.x - 33.75f, lastCenter.y - 15.0f, 67.5f, 30.0f)];
                            }
                        } completion:^(BOOL finished) {
                            [self.layer setShadowOpacity:0];
                        }];
                    break;
                case down:
                        [self setLocation:down];
                        [UIView animateWithDuration:0.5 animations:^{
                            if (self.lastCenter.x == 0) {
                                [delegate arrangeDownButtonsWithButton:self andAdd:YES];
                            }else{
                                [self setFrame:CGRectMake(lastCenter.x - 33.75f, lastCenter.y - 17.5f, 67.5f, 35.0f)];
                            }
                        } completion:^(BOOL finished) {
                            [self.layer setShadowOpacity:0];
                        }];
                    break;
                default:
                    break;
            }

            break;
        case UIGestureRecognizerStateCancelled:
//            [self stopShake];
            [self setAlpha:1];
            break;
        case UIGestureRecognizerStateFailed:
//            [self stopShake];
            [self setAlpha:1];
            break;
        default:
            break;
    }
}


- (void)startShake
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -0.1, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, 0.1, 0, 0, 1)];
    
    [self.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)stopShake
{
    [self.layer removeAnimationForKey:@"shakeAnimation"];
}

@end
