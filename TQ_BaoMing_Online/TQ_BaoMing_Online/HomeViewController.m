//
//  HomeViewController.m
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-9-13.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize button1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
          }
    return self;
}
- (IBAction)btn1touchdown:(UIButton *)sender {
    
    
    
    UIButton *thisbtn1 = (UIButton *)sender;
    [thisbtn1 setBounds:CGRectMake(thisbtn1.frame.origin.x, thisbtn1.frame.origin.y, 150, 150)];
//    thisbtn1.frame.size.width = 150;
    
 
//    [button1 setFrame: CGRectMake(thisbtn1.frame.origin.x, thisbtn1.frame.origin.y, 150, 150)];

}

- (IBAction)btn2touchdown:(UIButton *)sender {
    UIButton *thisbtn1 = (UIButton *)sender;
    [thisbtn1 setBounds:CGRectMake(thisbtn1.frame.origin.x, thisbtn1.frame.origin.y, 150, 150)];
}
- (IBAction)btn3touchdown:(UIButton *)sender {
    UIButton *thisbtn1 = (UIButton *)sender;
    [thisbtn1 setBounds:CGRectMake(thisbtn1.frame.origin.x, thisbtn1.frame.origin.y, 150, 150)];
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

- (void)viewDidUnload {
    [self setButton1:nil];
    [super viewDidUnload];
}
@end
