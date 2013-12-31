//
//  WritePinLunViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-12-24.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "WritePinLunViewController.h"
#import "RFKeyboardToolbar.h"
#import "RFToolbarButton.h"

@interface WritePinLunViewController ()

@end

@implementation WritePinLunViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        t.font = [UIFont systemFontOfSize:20];
        t.textColor = [UIColor whiteColor];
        t.backgroundColor = [UIColor clearColor];
        t.textAlignment = 1;
        t.text = @"评论/转发";
        self.navigationItem.titleView = t;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 键盘高度变化通知，ios5.0新增的
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowWrite:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    RFToolbarButton *qqButton = [[RFToolbarButton alloc]initWithImage:@"qq.png" hightlightImage:@"qq_1.png"];
    qqButton.frame = CGRectMake(0, 0, 30, 30);
    
    RFToolbarButton *qqButton1 = [[RFToolbarButton alloc]initWithImage:@"qq.png" hightlightImage:@"qq_1.png"];
    qqButton1.frame = CGRectMake(0, 0, 30, 30);
    
    RFToolbarButton *qqButton2 = [[RFToolbarButton alloc]initWithImage:@"qq.png" hightlightImage:@"qq_1.png"];
    qqButton2.frame = CGRectMake(0, 0, 30, 30);
    
    RFToolbarButton *tengxunButton = [[RFToolbarButton alloc]initWithImage:@"tengxun.png" hightlightImage:@"tengxun_1.png"];
    tengxunButton.frame = CGRectMake(0, 0, 30, 30);
    
    RFToolbarButton *renrenButton = [[RFToolbarButton alloc]initWithImage:@"renren.png" hightlightImage:@"renren_1.png"];
    renrenButton.frame = CGRectMake(0, 0, 30, 30);
    
    
    self.myWriteTV.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];//设置textview里面的字体颜色
    self.myWriteTV.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小
    self.myWriteTV.layer.borderColor = [UIColor grayColor].CGColor;
    self.myWriteTV.layer.borderWidth =1.0;
    self.myWriteTV.layer.cornerRadius =5.0;
    self.myWriteTV.delegate = self;
    [self.myWriteTV becomeFirstResponder];
    [RFKeyboardToolbar addToTextView:self.myWriteTV withButtons:@[qqButton,tengxunButton,renrenButton,qqButton1,qqButton2]];
    
//    [self.myWriteTV becomeFirstResponder];
    
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShowWrite:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    DLog(@"%f  %f   %f   %f",keyboardRect.origin.x,keyboardRect.origin.y,keyboardRect.size.width,keyboardRect.size.height);
    self.myWriteTV.frame = CGRectMake(10, 10, 300, keyboardRect.origin.y - 84);
    self.inlineLB.frame = CGRectMake(10, self.myWriteTV.height - 10, 300, 20);
}

- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
//        <#code#>
    }];
}
- (IBAction)sendButtonClick:(id)sender {
    DLog(@"send");
}


/**
 *    <#Description#>
 *
 *    @param textView <#textView description#>
 */
- (void)textViewDidChange:(UITextView *)textView
{
    inlineStr =  textView.text;
    if (textView.text.length == 0) {
        self.inlineLB.text = @"  如果不想转发,请不要勾选下方图标";
    }else{
        self.inlineLB.text = @"";
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
