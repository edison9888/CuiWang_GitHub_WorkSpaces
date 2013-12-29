//
//  LeftViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-19.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UINavigationController *_searchVC;                //搜索
    UINavigationController *_messageVC;              //消息
    UINavigationController *_shoucanVC;                //搜索
    UINavigationController *_offLineVC;              //消息
    UINavigationController *_setVC;                //搜索
    UINavigationController *_fankuiVC;              //消息
    NSArray *imageNameArray;
}
@property (strong, nonatomic) IBOutlet UIImageView *LoadImageView;
@property (strong, nonatomic) IBOutlet UITableView *myLeftableView;

@property (strong, nonatomic) IBOutlet UILabel *userlabel;

@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;
@property (strong, nonatomic) IBOutlet UIButton *shoucanButton;
@property (strong, nonatomic) IBOutlet UIButton *offLineButton;
@property (strong, nonatomic) IBOutlet UIButton *setButton;
@property (strong, nonatomic) IBOutlet UIButton *fankuiButton;

@property(strong,nonatomic) UINavigationController *searchVC;
@property(strong,nonatomic) UINavigationController *messageVC;
@property(strong,nonatomic) UINavigationController *shoucanVC;
@property(strong,nonatomic) UINavigationController *offLineVC;
@property(strong,nonatomic) UINavigationController *setVC;
@property(strong,nonatomic) UINavigationController *fankuiVC;
@end
