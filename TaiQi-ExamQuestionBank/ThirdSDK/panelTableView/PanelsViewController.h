//
//  ExamViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-20.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelIndexPath.h"
#import "PanelView.h"

@interface UIScrollViewExt : UIScrollView

@end


@interface PanelsViewController : UIViewController <UIScrollViewDelegate, PanelViewDelegate>{
	UIScrollViewExt *scrollView;
	NSMutableSet *recycledPages;
	NSMutableSet *visiblePages;
	int currentPage;
	int lastDisplayedPage;
	BOOL _isEditing;
}

@property (nonatomic, retain) UIScrollViewExt *scrollView;
@property (nonatomic, retain) NSMutableSet *recycledPages, *visiblePages;

#define GAP 10
#define TAG_PAGE 11000

- (PanelView*)dequeueReusablePageWithIdentifier:(NSString*)identifier;
- (PanelView *)panelViewAtPage:(NSInteger)page;


#pragma mark frame and sizes
- (CGRect)scrollViewFrame;
- (CGSize)panelViewSize;
- (int)numberOfVisiblePanels;


- (void)viewWillAppear:(BOOL)animated;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_;
- (NSInteger)numberOfPanels;

@end
