//
//  HomeViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-22.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKSlideSwitchView.h"
#import "GKListViewController.h"
#import "subMMDrawerController.h"

@interface HomeViewController : UIViewController <GKSlideSwitchViewDelegate, contentVCPassValue>
{
	GKSlideSwitchView *slideSwitchView;
	NSMutableArray *VCArray;
	NSMutableArray *titleArray;
    //    NSMutableArray *dragDownTitleArray;
}
@property (nonatomic, strong) NSMutableArray *VCArray;
@end
