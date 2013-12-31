//
//  FeedBackViewController.h
//  TaiQi
//
//  Created by cui wang on 13-5-6.
//
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"

@class UIBubbleTableView;
@interface FeedBackViewController : UIViewController<UIBubbleTableViewDataSource,UITextFieldDelegate>
{

    UIBubbleTableView *bubbleTable;
    UITextField *input;
    UIButton *send;
   
    NSMutableArray *bubbleData;
}

@end
