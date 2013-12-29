//
//  RFToolbarButton.h
//
//  Created by Rex Finn on 12/3/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFKeyboardToolbar.h"

@interface RFToolbarButton : UIButton

@property(nonatomic,strong)NSString *imageName;
@property(nonatomic,strong)NSString *hightlightImageName;

-(id)initWithImage:(NSString *)imageName hightlightImage:(NSString *)hightlightImageName;

+ (void)setTextViewForButton:(UITextView*)textViewPassed;
+ (UITextView*)textView;

+ (void)setTextFieldForButton:(UITextField*)textFieldPassed;
+ (UITextField*)textField;

@end
