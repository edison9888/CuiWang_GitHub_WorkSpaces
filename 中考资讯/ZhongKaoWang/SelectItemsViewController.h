//
//  SelectItemsViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-27.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "subMMDrawerController.h"
#import "titleClass.h"
@interface SelectItemsViewController : UIViewController
{
    NSArray *titleArray;
    NSMutableArray *buttons;
    NSMutableArray *upArray;
    NSMutableArray *downArray;
    NSMutableArray *tmpArray;
    titleClass *titleObj;
    subMMDrawerController * DrawerController;
}
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIButton *beginReadButton;

@end
