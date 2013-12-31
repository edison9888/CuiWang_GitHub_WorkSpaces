//
//  CloudView.h
//  CloudLabel
//
//  Created by PowerAuras on 13-9-2.
//  qq120971999  http://www.cnblogs.com/powerauras/
//  Copyright (c) 2013年 PowerAuras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreFoundation/CoreFoundation.h>

@protocol CloudButtonClickDelegate <NSObject>


-(void)touchUpInsideDelegate:(UILabel *)lb;

@end

@interface CloudView : UIView
{
     NSMutableArray *butAry;
}

@property(nonatomic,assign)    id cloudDelegate;

-(void)reloadData:(NSArray *)ary;
-(void)removeAllView;
@end

@interface NSArray (Modulo)
- (id)objectAtModuloIndex:(NSUInteger)index;
@end

@interface BubbleV : UILabel
{
    id delegate;
}
@property(nonatomic,assign)    id delegate;
@end