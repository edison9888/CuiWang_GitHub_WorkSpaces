//
//  DragButtonViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-26.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseViewController.h"
#import "UIDragButton.h"
@interface DragButtonViewController : BaseViewController<UIDragButtonDelegate>
{
    NSMutableArray *upButtons;
    NSMutableArray *downButtons;
    NSMutableArray *titleArray;
    NSMutableSet *newtitleArray;

    NSMutableArray *dragDownTitleArray;
    UIDragButton *upbutton;
    UIDragButton *downbutton;
    UIButton *bgBtn;
    UIButton *bgBtn2;
}

- (void)addItems;
- (void)setUpButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton;
- (void)setDownButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton;

@end
