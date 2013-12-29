//
//  BaseViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-18.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    UINavigationController *_HomeVC;                //搜索
}
@property(strong,nonatomic) UINavigationController *HomeVC;
@property (nonatomic,strong)UILabel *t;
-(void)popback;
@end
