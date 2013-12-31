//
//  WebOpenViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-12-27.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseViewController.h"

@interface WebOpenViewController : BaseViewController
{
    NSString *_url;
}
-(id)initWithUrl:(NSString *)url NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@property (strong, nonatomic) IBOutlet UIWebView *myWebOpenWebView;

@end
