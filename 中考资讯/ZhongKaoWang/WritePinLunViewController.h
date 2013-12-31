//
//  WritePinLunViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-12-24.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseViewController.h"

@interface WritePinLunViewController : UIViewController<UITextViewDelegate>
{
    NSString *inlineStr;
}
@property (strong, nonatomic) IBOutlet UITextView *myWriteTV;
@property (strong, nonatomic) IBOutlet UIImageView *topView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UILabel *inlineLB;

@end
