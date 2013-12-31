//
//  RegisterContentViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-12-21.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "RegisterContentViewController.h"

@interface RegisterContentViewController ()

@end

@implementation RegisterContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.t.text = @"注册须知";
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.myScrollView.contentSize=CGSizeMake(320, 1650);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
