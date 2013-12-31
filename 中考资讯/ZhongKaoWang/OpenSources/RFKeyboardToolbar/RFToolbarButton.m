//
//  RFToolbarButton.m
//
//  Created by Rex Finn on 12/3/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import "RFToolbarButton.h"

@implementation RFToolbarButton

static UITextView *textView = NULL;
static UITextField *textField = NULL;

-(id)initWithImage:(NSString *)imageName hightlightImage:(NSString *)hightlightImageName
{
    self = [super init];
    if (self) {
        self.imageName = imageName;
        self.hightlightImageName = hightlightImageName;
        [self loadImage];
    }
    return self;
}
-(void)loadImage
{
    UIImage *image = [UIImage imageNamed:self.imageName];
    UIImage *hightImage = [UIImage imageNamed:self.hightlightImageName];
    
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:hightImage forState:UIControlStateHighlighted];
    
}

+ (void)setTextViewForButton:(UITextView*)textViewPassed {
    textView = textViewPassed;
}

+ (UITextView*)textView {
    return textView;
}

+ (void)setTextFieldForButton:(UITextField*)textFieldPassed {
    textField = textFieldPassed;
}

+ (UITextField*)textField {
    return textField;
}

@end
