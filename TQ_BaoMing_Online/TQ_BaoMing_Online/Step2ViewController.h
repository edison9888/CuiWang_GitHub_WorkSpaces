//
//  Step2ViewController.h
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-9-24.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComboBoxView.h"
#import "Step1ViewController.h"
#import "MBProgressHUD.h"
#import "taocanObj.h"

@protocol PassClassValueDelegate
- (void)setClasslValue:(NSDictionary *)listDictionary;
@end
@protocol PassTaocanValueDelegate
- (void)setTaocanValue:(NSArray *)listDictionary;
@end

@interface Step2ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PassListValueDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *choosedArray;
    ComboBoxView  *_comboBox;
    NSMutableArray *subIdArray;
    NSMutableArray *subNameArray;
    NSMutableDictionary *contentArray;
    NSMutableArray *classArray;
    NSArray *passContentArray;
    NSIndexPath *lastIndexPath;
    MBProgressHUD *HUD;
    NSMutableArray *listViewDataArray;
    NSMutableArray *listViewClassDataArray;
    taocanObj *taocanobj;
    int xiaindex;
    int classIndex;
    id<PassClassValueDelegate> PassClassValueDelegate;
     id<PassTaocanValueDelegate> PassTaocanValueDelegate;
}
@property(nonatomic, strong) id<PassClassValueDelegate> PassClassValueDelegate
;
@property(nonatomic, strong) id<PassTaocanValueDelegate> PassTaocanValueDelegate
;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *xuanzebanji;
@property (strong, nonatomic) IBOutlet UIButton *xuanzetaocan;

@property (strong, nonatomic) IBOutlet UITableView *xiangmuTableView;
@property (strong, nonatomic) IBOutlet UILabel *lb1;
@property (strong, nonatomic) IBOutlet UILabel *lb2;
@property (strong, nonatomic) IBOutlet UILabel *lb3;
@property (strong, nonatomic) IBOutlet UILabel *lb4;
@end
