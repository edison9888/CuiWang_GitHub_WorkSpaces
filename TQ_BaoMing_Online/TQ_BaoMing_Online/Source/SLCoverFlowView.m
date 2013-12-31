//
//  SLCoverFlowView.m
//  SLCoverFlow
//
//  Created by jiapq on 13-6-13.
//  Copyright (c) 2013年 HNAGroup. All rights reserved.
//

#import "SLCoverFlowView.h"
#import <QuartzCore/QuartzCore.h>
#import "SLCoverViewWrapper.h"
#import "SLCoverView.h"

static const CGFloat SLCoverWidth = 100.0;
static const CGFloat SLCoverHeight = 100.0;

//-----------@interface SLCoverFlowScrollView
@interface SLCoverFlowScrollView : UIScrollView {
    UIView *_coverContainerView;
    
    CGFloat _horzMargin;
    CGFloat _vertMargin;
  
    
}
@property(nonatomic,strong)    NSMutableArray *_coverViewWrappers;

@property (nonatomic, weak) SLCoverFlowView *parentView;

@property(nonatomic)  bool canVisiable;

- (SLCoverView *)leftMostVisibleCoverView;
- (SLCoverView *)rightMostVisibleCoverView;

- (void)reloadData;
- (void)removeAllCoverViews;
- (void)repositionVisibleCoverViews;

@end

//---------@implementation SLCoverFlowScrollView
@implementation SLCoverFlowScrollView

@synthesize _coverViewWrappers;

// 初始化 scrollview
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _coverContainerView = [[UIView alloc] initWithFrame:self.bounds];
        _coverContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _coverContainerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_coverContainerView];
        
        _horzMargin = 0.0;
        _vertMargin = 0.0;
        
        _canVisiable = YES;
        _coverViewWrappers = [NSMutableArray array];
     

    }
    return self;
}
//初始化initWithFrame 或者 滚动视图等  后会调用这个
//在这个方法里面判断是否到位置了,到位置了才给出框框
- (void)layoutSubviews {
    [super layoutSubviews];
    //self.parentView 就是这个SLCoverflowview类
    if (self.parentView.numberOfCoverViews > 0) {
        // tile cover view in visible bounds
        CGRect visibleBounds = [self convertRect:[self bounds] toView:_coverContainerView];
//        NSLog(@"%f  %f   %f    %f",visibleBounds.origin.x,visibleBounds.origin.y,visibleBounds.size.width,visibleBounds.size.height);
                
        int value = fabs((int)visibleBounds.origin.x % 343);

        if(value == 0 || value == 342 || value == 1)
           {
           _canVisiable = YES;
           
           }
        else
            {
            _canVisiable = NO;
            }
        
        [self tileCoverViewsFromMinX:CGRectGetMinX(visibleBounds) toMaxX:CGRectGetMaxX(visibleBounds)];
        
        // adjust the (3D)attributes of the visible cover views
        [self adjustCoverViewsTransformWithVisibleBounds:visibleBounds];
    }
}

#pragma mark - Instance methods

- (void)reloadData {
    [self removeAllCoverViews];
    [self resetContentSize];
    self.contentOffset = CGPointMake(0.0, 0.0);
    
    [self layoutSubviews];
}

- (void)removeAllCoverViews {
    for (SLCoverViewWrapper *wrapper in _coverViewWrappers) {
        [wrapper.coverView removeFromSuperview];
    }
    [_coverViewWrappers removeAllObjects];
}
- (void)resetContentSize {
    // reset the top, left, right, bottom margin
    _horzMargin = (CGRectGetWidth(self.frame) - self.parentView.coverSize.width)/2.0;
    _vertMargin = (CGRectGetHeight(self.frame) - self.parentView.coverSize.height)/2.0;
    // 宽度 = 两边的间隙+图片的宽度* 图片的个数 + 图片的间隙
    if (self.parentView.numberOfCoverViews > 0) {
        self.contentSize = CGSizeMake(_horzMargin*2.0 + self.parentView.numberOfCoverViews*self.parentView.coverSize.width + (self.parentView.numberOfCoverViews-1)*self.parentView.coverSpace, self.frame.size.height);
    } else {
        self.contentSize = self.frame.size;
    }
    // reset frame of _coverContainerView
    NSLog(@"resetContentSize--------self.contentSize  %f    %f",self.contentSize.width,self.contentSize.height);
    _coverContainerView.frame = CGRectMake(0.0, 0.0, self.contentSize.width, self.contentSize.height);
}

#pragma mark - 左右最大可见区域
- (SLCoverView *)leftMostVisibleCoverView {
    if (_coverViewWrappers.count) {
        return [[_coverViewWrappers objectAtIndex:0] coverView];
    } else {
        return nil;
    }
}

- (SLCoverView *)rightMostVisibleCoverView {
    return [[_coverViewWrappers lastObject] coverView];
}

#pragma mark - repositionVisibleCoverViews
- (void)repositionVisibleCoverViews {
    // reset the top, left, right, bottom margin
    CGFloat oldHorzMargin = _horzMargin;
    CGFloat oldVertMargin = _vertMargin;
    [self resetContentSize];
    
    // adjust the position 
    for (int i = 0; i < _coverViewWrappers.count; ++i) {
        SLCoverView *view = [[_coverViewWrappers objectAtIndex:i] coverView];
        view.center = CGPointMake(view.center.x + _horzMargin - oldHorzMargin,
                                  view.center.y + _vertMargin - oldVertMargin);
    }
}

#pragma mark - Private methods

- (SLCoverView *)insertCoverViewAtIndex:(NSInteger)index frame:(CGRect)frame {
    SLCoverView *coverView = [self.parentView.delegate coverFlowView:self.parentView coverViewAtIndex:index];
    coverView.frame = frame;
    [_coverContainerView addSubview:coverView];
    return coverView;
}

- (SLCoverViewWrapper *)addNewCoverViewOnRight:(CGFloat)rightEdge index:(NSInteger)index isFirst:(BOOL) isFirst {
    SLCoverViewWrapper *wrapper = nil;
//    
//    NSLog(@"index == %d",index);
//    NSLog(@"self.parentView.numberOfCoverViews == %d",self.parentView.numberOfCoverViews);
//    NSLog(@"rightEdge == %f",rightEdge);
    if (index >= 0 && index < self.parentView.numberOfCoverViews) {
        CGRect frame = CGRectMake(rightEdge, _vertMargin, 0.0, 0.0);
        frame.size = self.parentView.coverSize;
        
        //------
        SLCoverView *coverView;
//        //------加载第一张图
//        if(isFirst)
//            {
//            coverView = [[SLCoverView alloc] initWithFrame:CGRectMake(0.0, 0.0, 128.0, 128.0)];
//            coverView.imageView.image = [_coverImageView objectAtIndex:index];
//            coverView.imageView.tag = index;
//            coverView.frame = frame;
//            [_coverContainerView addSubview:coverView];
//            }
//        else
//            {
             coverView = [self insertCoverViewAtIndex:index frame:frame];
//            }
      
        wrapper = [[SLCoverViewWrapper alloc] init];
        wrapper.index = index;
        wrapper.coverView = coverView;
        [_coverViewWrappers addObject:wrapper];
        
//        NSLog(@"_coverViewWrappers.count == %d",_coverViewWrappers.count);
    }
    return wrapper;
}

- (SLCoverViewWrapper *)addNewCoverViewOnLeft:(CGFloat)leftEdge index:(NSInteger)index {
    SLCoverViewWrapper *wrapper = nil;
    if (index >= 0 && index < self.parentView.numberOfCoverViews) {
        CGRect frame = CGRectMake(leftEdge - self.parentView.coverSize.width, _vertMargin, 0.0, 0.0);
        frame.size = self.parentView.coverSize;
        SLCoverView *coverView = [self insertCoverViewAtIndex:index frame:frame];

        wrapper = [[SLCoverViewWrapper alloc] init];
        wrapper.index = index;
        wrapper.coverView = coverView;
        [_coverViewWrappers insertObject:wrapper atIndex:0];
    }
    return wrapper;
}
//--------左边距
- (CGFloat)leftEdgeOfCoverViewAtIndex:(NSInteger)index {
    // left edge of the cover view at index, space between cover views must be considered
    return (_horzMargin + (self.parentView.coverSize.width + self.parentView.coverSpace)*(index -1));
}

//--------右边距
- (CGFloat)rightEdgeOfCoverViewAtIndex:(NSInteger)index {
    // right edge of the cover view at index, space between cover views must be considered
    return (_horzMargin + (self.parentView.coverSize.width + self.parentView.coverSpace)*(index + 1));
}
//-----------添加左右中视图
- (void)tileCoverViewsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX {
    
    
    
    // 添加第一个视图
    if (0 == _coverViewWrappers.count) {
        // calculate the nearby middle cover view index in the visible bounds
        NSInteger index = ceilf((minimumVisibleX - _horzMargin) / (self.parentView.coverSize.width + self.parentView.coverSpace));
        index = MIN(MAX(0, index), self.parentView.numberOfCoverViews-1);
        // 在中间位置添加视图
        CGFloat rightEdge = _horzMargin + (self.parentView.coverSize.width + self.parentView.coverSpace)*index;
        
        [self addNewCoverViewOnRight:rightEdge index:index isFirst:YES];
    }
    
    // 添加右视图
    SLCoverViewWrapper *lastCoverViewWrapper = (SLCoverViewWrapper *)[_coverViewWrappers lastObject];
    
    CGFloat rightEdge = [self rightEdgeOfCoverViewAtIndex:lastCoverViewWrapper.index];
    
//    NSLog(@"lastCoverViewWrapper.index == %d",lastCoverViewWrapper.index);
//    NSLog(@"rightEdge == %f",rightEdge);
//    NSLog(@"maximumVisibleX == %f",maximumVisibleX);

    while (rightEdge < maximumVisibleX) {
        lastCoverViewWrapper = [self addNewCoverViewOnRight:rightEdge index:(lastCoverViewWrapper.index+1) isFirst:NO];
        if (lastCoverViewWrapper) {
            rightEdge = [self rightEdgeOfCoverViewAtIndex:lastCoverViewWrapper.index];
        } else {
            break;
        }
    }
    
    // 添加左视图
    SLCoverViewWrapper *firstCoverViewWrapper = (SLCoverViewWrapper *)[_coverViewWrappers objectAtIndex:0];
    CGFloat leftEdge = [self leftEdgeOfCoverViewAtIndex:firstCoverViewWrapper.index];
    
//    NSLog(@"firstCoverViewWrapper.index == %d",firstCoverViewWrapper.index);
//    NSLog(@"leftEdge == %f",leftEdge);
//    NSLog(@"minimumVisibleX == %f",minimumVisibleX);
    
    
    while (leftEdge > minimumVisibleX) {
        firstCoverViewWrapper = [self addNewCoverViewOnLeft:leftEdge index:(firstCoverViewWrapper.index - 1)];
        if (firstCoverViewWrapper) {
            leftEdge = [self leftEdgeOfCoverViewAtIndex:firstCoverViewWrapper.index];
        } else {
            break;
        }
    }
    
    //--------移除视图  优化作用.
    /*
    // remove cover views out of left bounds
    firstCoverViewWrapper = (SLCoverViewWrapper *)[_coverViewWrappers objectAtIndex:0];
    while (firstCoverViewWrapper &&
           CGRectGetMaxX(firstCoverViewWrapper.coverView.frame) < minimumVisibleX) {
        [firstCoverViewWrapper.coverView removeFromSuperview];
        [_coverViewWrappers removeObjectAtIndex:0];
        firstCoverViewWrapper = [_coverViewWrappers objectAtIndex:0];
    }
    
    // remove cover views out of right bounds
    lastCoverViewWrapper = (SLCoverViewWrapper *)[_coverViewWrappers lastObject];
    while (lastCoverViewWrapper &&
           CGRectGetMinX(lastCoverViewWrapper.coverView.frame) > maximumVisibleX) {
        [lastCoverViewWrapper.coverView removeFromSuperview];
        [_coverViewWrappers removeLastObject];
        lastCoverViewWrapper = [_coverViewWrappers lastObject];
    }
     */
//    NSLog(@"添加左右中视图 _coverViewWrappers.count == %d",_coverViewWrappers.count);
}

- (void)adjustCoverViewsTransformWithVisibleBounds:(CGRect)visibleBounds {
    // adjust scale and transform of all the visible views
    CGFloat visibleBoundsCenterX = CGRectGetMidX(visibleBounds);
    for (NSInteger i = 0; i < _coverViewWrappers.count; ++i) {
        UIView *coverView = [[_coverViewWrappers objectAtIndex:i] coverView];
        
        CGFloat distance = coverView.center.x - visibleBoundsCenterX;
        CGFloat distanceThreshold = self.parentView.coverSize.width + self.parentView.coverSpace;
        if (distance <= -distanceThreshold) {
            coverView.layer.transform = [self transform3DWithRotation:self.parentView.coverAngle scale:1.0 perspective:(-1.0/500.0)];
            coverView.layer.zPosition = -10000.0;
        } else if (distance < 0.0 && distance > -distanceThreshold) {
            CGFloat percentage = fabsf(distance)/distanceThreshold;
            CGFloat scale = 1.0 + (self.parentView.coverScale - 1.0) * (1.0 - percentage);
            coverView.layer.transform = [self transform3DWithRotation:self.parentView.coverAngle*percentage scale:scale perspective:(-1.0/500.0)];
            coverView.layer.zPosition = -10000.0;
        } else if (distance == 0.0) {
            coverView.layer.transform = [self transform3DWithRotation:0.0 scale:self.parentView.coverScale perspective:(1.0/500.0)];
            coverView.layer.zPosition = 10000.0;
        } else if (distance > 0.0 && distance < distanceThreshold) {
            CGFloat percentage = fabsf(distance)/distanceThreshold;
            CGFloat scale = 1.0 + (self.parentView.coverScale - 1.0) * (1.0 - percentage);
            coverView.layer.transform = [self transform3DWithRotation:-self.parentView.coverAngle*percentage scale:scale perspective:(-1.0/500.0)];
            coverView.layer.zPosition = -10000.0;
        } else if (distance >= distanceThreshold) {
            coverView.layer.transform = [self transform3DWithRotation:-self.parentView.coverAngle scale:1.0 perspective:(-1.0/500.0)];
            coverView.layer.zPosition = -10000.0;
        }
    }
}

- (CATransform3D)transform3DWithRotation:(CGFloat)angle
                                   scale:(CGFloat)scale
                             perspective:(CGFloat)perspective {
    CATransform3D rotateTransform = CATransform3DIdentity;
    rotateTransform.m34 = perspective;
    rotateTransform = CATransform3DRotate(rotateTransform, angle, 0.0, 1.0, 0.0);
    
    CATransform3D scaleTransform = CATransform3DIdentity;
    scaleTransform = CATransform3DScale(scaleTransform, scale, scale, 1.0);
    
    return CATransform3DConcat(rotateTransform, scaleTransform);
}

//- (CATransform3D)transform3DWithRotation:(CGFloat)angle scale:(CGFloat)scale {
//    CATransform3D rotateTransform = CATransform3DIdentity;
//    rotateTransform.m34 = -1.0 / 500.0;
//    rotateTransform = CATransform3DRotate(rotateTransform, angle, 0.0, 1.0, 0.0);
//    
//    CATransform3D scaleTransform = CATransform3DIdentity;
//    scaleTransform = CATransform3DScale(scaleTransform, scale, scale, 1.0);
//    
//    return CATransform3DConcat(rotateTransform, scaleTransform);
//}

@end

////////////////////////////////////////////////////////////
// 
@interface SLCoverFlowView () <UIScrollViewDelegate> {
    SLCoverFlowScrollView *_scrollView;
    CGPoint _endDraggingVelocity;
}

@end


@implementation SLCoverFlowView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
        if (self) {
        _scrollView = [[SLCoverFlowScrollView alloc] initWithFrame:self.bounds];
        _scrollView.parentView = self;
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.decelerationRate = 0.98;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_scrollView];
        _numberOfCoverViews = 0;
        _coverSize = CGSizeMake(SLCoverWidth, SLCoverHeight);
        _coverSpace = 0.0;
        _coverAngle = M_PI_4;
        _coverScale = 1.1;
        
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
   
    if (!CGRectEqualToRect(self.frame, frame)) {
        [super setFrame:frame];
        
        [_scrollView repositionVisibleCoverViews];
    }
}

- (void)setCoverSize:(CGSize)coverSize {
    NSLog(@"coverSize %f  %f",coverSize.width,coverSize.height);
    NSLog(@"setCoverSize %f  %f",_coverSize.width,_coverSize.height);
    NSLog(@"_scrollView.contentOffset %f  %f",_scrollView.contentOffset.x,_scrollView.contentOffset.y);
    
    if (!CGSizeEqualToSize(_coverSize, coverSize)) {
        // keep the current middle cover view's position
        NSInteger centerIndex = [self nearByIndexOfScrollViewContentOffset:_scrollView.contentOffset];
        _coverSize = coverSize;
        
        [_scrollView removeAllCoverViews];
        [_scrollView resetContentSize];
        _scrollView.contentOffset = [self offsetWithCenterCoverViewIndex:centerIndex];
        [_scrollView setNeedsLayout]; // 调用layeroutsub
    }
}

- (void)setCoverSpace:(CGFloat)coverSpace {
    if (_coverSpace != coverSpace) {
        // keep the current middle cover view's position
        NSInteger centerIndex = [self nearByIndexOfScrollViewContentOffset:_scrollView.contentOffset];
        _coverSpace = coverSpace;
        
        [_scrollView removeAllCoverViews];
        [_scrollView resetContentSize];
        _scrollView.contentOffset = [self offsetWithCenterCoverViewIndex:centerIndex];
        [_scrollView setNeedsLayout];
    }
}

- (void)setCoverAngle:(CGFloat)coverAngle {
    if (_coverAngle != coverAngle) {
        _coverAngle = coverAngle;
        
        [_scrollView setNeedsLayout];
    }
}

- (void)setCoverScale:(CGFloat)coverScale {
    if (_coverScale != coverScale) {
        _coverScale = coverScale;
        
        [_scrollView setNeedsLayout];
    }
}

#pragma mark - Instance methods

- (void)reloadData {
    _numberOfCoverViews = [self.delegate numberOfCovers:self];
    [_scrollView reloadData];
}
    
- (SLCoverView *)leftMostVisibleCoverView {
    return [_scrollView leftMostVisibleCoverView];
}

- (SLCoverView *)rightMostVisibleCoverView {
    return [_scrollView rightMostVisibleCoverView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"开始拖动咯");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"move" object:self];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    _endDraggingVelocity = velocity;
    
//    NSLog(@"%f    %f    %f" ,_endDraggingVelocity.x,_scrollView.contentOffset.x,_scrollView.contentOffset.y);
    
    if (_endDraggingVelocity.x == 0) {
        // find the nearby content offset
        *targetContentOffset = [self nearByOffsetOfScrollViewContentOffset:_scrollView.contentOffset];
        
        
    } else {
        // calculate the slide distance and end scrollview content offset
        CGFloat startVelocityX = fabsf(_endDraggingVelocity.x);
        CGFloat decelerationRate = 1.0 - _scrollView.decelerationRate;

        CGFloat decelerationSeconds = startVelocityX / decelerationRate;
        CGFloat distance = startVelocityX * decelerationSeconds - 0.5 * decelerationRate * decelerationSeconds * decelerationSeconds;
        
        CGFloat endOffsetX = _endDraggingVelocity.x > 0 ? (_scrollView.contentOffset.x + distance) : (_scrollView.contentOffset.x - distance);
        
        // calculate the nearby content offset of the middle cover view
        *targetContentOffset = [self nearByOffsetOfScrollViewContentOffset:CGPointMake(endOffsetX, _scrollView.contentOffset.y)];
    }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"拖动结束咯");
    if(_scrollView.canVisiable)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stop" object:self];
        }
}
#pragma mark - Private methods
    
- (NSUInteger)nearByIndexOfScrollViewContentOffset:(CGPoint)contentOffset {
    NSInteger index = nearbyintf(contentOffset.x / (self.coverSize.width + self.coverSpace));
    return MIN(MAX(0, index), self.numberOfCoverViews-1);
    
    NSLog(@"nearByIndexOfScrollViewContentOffset -------- index == %d        %d,",index,self.numberOfCoverViews-1);
    
}

- (CGPoint)nearByOffsetOfScrollViewContentOffset:(CGPoint)contentOffset {
    NSInteger index = [self nearByIndexOfScrollViewContentOffset:contentOffset];
//    NSLog(@"index == %d",index);
    return CGPointMake(index*(self.coverSize.width + self.coverSpace), contentOffset.y);
}

- (CGPoint)offsetWithCenterCoverViewIndex:(NSInteger)index {
    return CGPointMake(index*(self.coverSize.width + self.coverSpace), _scrollView.contentOffset.y);
}

@end
