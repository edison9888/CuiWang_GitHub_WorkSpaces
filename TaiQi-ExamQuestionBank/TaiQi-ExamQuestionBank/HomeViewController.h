//
//  HomeViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-20.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myDB.h"
@interface HomeViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    Boolean Home_isFirstLoad;
    BOOL Fast_isSave;
    BOOL Special_isSave;
    BOOL Real_isSave;
    BOOL Fast_isFirst;
//    BOOL Special_isFirst;
//    BOOL Real_isFirst;
    BOOL stillnext;
    NSUserDefaults *ud;
    NSMutableArray *Fast_QArray;
    myDB *loadDB;
    GRAlertView *alert;
}

@property (strong, nonatomic) IBOutlet UIButton *KSLS;
@property (strong, nonatomic) IBOutlet UIButton *ZXLS;
@property (strong, nonatomic) IBOutlet UIButton *ZTMK;
@property (strong, nonatomic) IBOutlet UIButton *NLPG;
@property (strong, nonatomic) IBOutlet UIButton *JXLX;
@property (strong, nonatomic) IBOutlet UIButton *KQCC;
@property (strong, nonatomic) IBOutlet UIButton *LSJL;
@property (strong, nonatomic) IBOutlet UIButton *YHZX;

@property(nonatomic,strong)UIImageView *topImgV;
@property(nonatomic,strong)UIImageView *BotImgV;


- (IBAction)ksls_click:(id)sender;
- (IBAction)zxzl_click:(id)sender;
- (IBAction)ztmk_click:(id)sender;
- (IBAction)nlpg_click:(id)sender;
- (IBAction)jxlx_click:(id)sender;
- (IBAction)kqcc_click:(id)sender;
- (IBAction)lsjl_click:(id)sender;
- (IBAction)yhzx_click:(id)sender;

@end
