//
//  OffLineDownViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-12-2.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "OffLineDownViewController.h"

@interface OffLineDownViewController ()

@end

@implementation OffLineDownViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.t.text = @"离线下载";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
