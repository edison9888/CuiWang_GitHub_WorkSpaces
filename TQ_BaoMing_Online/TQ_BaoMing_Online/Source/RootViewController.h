//
//  Created by tuo on 4/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <UIKit/UIKit.h>
#import "CoverFlowView.h"
@protocol PassValueDelegate

- (void)setUrlValue:(NSString *)value;

@end
@interface RootViewController : UIViewController
{
    CoverFlowView *_coverFlowView;
    id<PassValueDelegate> passDelegate;
}
@property(nonatomic, strong) id<PassValueDelegate> passDelegate;
@end