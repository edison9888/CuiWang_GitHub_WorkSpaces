//
//  PinLunViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-12-21.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseViewController.h"

@interface PinLunViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIWebView *myPinLunWebView;
@property (nonatomic, strong) NSString *ContentID;
@property (nonatomic, strong) NSString *CatID;
- (id)initWithCatID:(NSString *)catid ContentID:(NSString *)nid;
@end
