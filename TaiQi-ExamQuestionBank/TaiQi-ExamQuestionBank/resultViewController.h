//
//  resultViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-27.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "myDB.h"
#import "SubType_Fast_Temp.h"
#import "SubType_Comm.h"
#import "UserEntity.h"
#import "VCPassValueDelegate.h"
//#import "VCPassValueDelegate.h"

@interface resultViewController : UIViewController<MBProgressHUDDelegate,VCPassValueDelegate>
{
//    NSObject<VCPassValueDelegate> * delegate;
    int uNum;
    BOOL wrongSub;
    myDB *loadResultDB;
    UILabel *txtLB;
    SubType_Fast_Temp *Fast_Temp;
    MBProgressHUD *HUD;
    NSString  * fatherType;
    NSString  * thisType;
    NSArray *typeArray;
    SubType_Comm *thisSub;
    SubType_Comm *thisSub_Special;
    SubType_Comm     *thisSub_Real;
    SubType_Fast_Temp *thisTempSub;
    NSArray *buttonArray;
 
}
@property (nonatomic, strong) NSMutableArray *panelsArray;
@property (strong, nonatomic) IBOutlet UIImageView *Img_Title;
@property(strong,nonatomic)NSString  * fatherType;
//@property(nonatomic, strong) NSObject<VCPassValueDelegate> * delegate;
@property (strong, nonatomic) IBOutlet UIButton *Btn1;
@property (strong, nonatomic) IBOutlet UIButton *Btn2;
@property (strong, nonatomic) IBOutlet UIButton *Btn3;
@property (strong, nonatomic) IBOutlet UIButton *Btn4;
@property (strong, nonatomic) IBOutlet UIButton *Btn5;
@property (strong, nonatomic) IBOutlet UIButton *Btn6;
@property (strong, nonatomic) IBOutlet UIButton *Btn7;
@property (strong, nonatomic) IBOutlet UIButton *Btn8;
@property (strong, nonatomic) IBOutlet UIButton *Btn9;
@property (strong, nonatomic) IBOutlet UIButton *Btn10;
@property (strong, nonatomic) IBOutlet UIButton *Btn11;
@property (strong, nonatomic) IBOutlet UIButton *Btn12;
@property (strong, nonatomic) IBOutlet UIButton *Btn13;
@property (strong, nonatomic) IBOutlet UIButton *Btn14;
@property (strong, nonatomic) IBOutlet UIButton *Btn15;
@property (strong, nonatomic) IBOutlet UIButton *answer;
@property(strong,nonatomic)   NSMutableArray *dataArray;
@property(strong,nonatomic)   NSMutableArray *dataTempArray;

- (IBAction)Btn1Click:(UIButton *)sender;
- (IBAction)Btn2Click:(UIButton *)sender;
- (IBAction)Btn3Click:(UIButton *)sender;
- (IBAction)Btn4Click:(UIButton *)sender;
- (IBAction)Btn5Click:(UIButton *)sender;
- (IBAction)Btn6Click:(UIButton *)sender;
- (IBAction)Btn7Click:(UIButton *)sender;
- (IBAction)Btn8Click:(UIButton *)sender;
- (IBAction)Btn9Click:(UIButton *)sender;
- (IBAction)Btn10Click:(UIButton *)sender;
- (IBAction)Btn11Click:(UIButton *)sender;
- (IBAction)Btn12Click:(UIButton *)sender;
- (IBAction)Btn13Click:(UIButton *)sender;
- (IBAction)Btn14Click:(UIButton *)sender;
- (IBAction)Btn15Click:(UIButton *)sender;
- (IBAction)asClick:(UIButton *)sender;

@end
