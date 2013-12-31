//
//  ContentViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-12-13.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseViewController.h"
#import "myDB.h"

@interface ContentViewController : BaseViewController <UIWebViewDelegate>
{
	myDB *LoadContentDB;
	BOOL ShouCangFalg;
    BOOL UserIsLoaded;
	UILabel *lb;
	NSString *numberOfPinLunCountStr;
    NSString *Cimage;
}


@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) IBOutlet UIImageView *botView;
@property (strong, nonatomic) IBOutlet UIButton *shoucangButton;
@property (strong, nonatomic) IBOutlet UIButton *fenxiangButton;
@property (strong, nonatomic) IBOutlet UIButton *pinlunButton;

@property (nonatomic, strong) NSString *ContentID;
@property (nonatomic, strong) NSString *CatTitle;
@property (nonatomic, strong) NSString *CatID;
@property (nonatomic, strong) NSString *Content;

- (id)initWithCatID:(NSString *)catid ContentID:(NSString *)nid ContentTitle:(NSString *)title Content:(NSString *)content Cimage:(NSString *)image NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ;
@end
