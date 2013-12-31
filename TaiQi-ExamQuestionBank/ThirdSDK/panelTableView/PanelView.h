//
//  ExamViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-20.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelIndexPath.h"
#import <QuartzCore/QuartzCore.h>

@protocol PanelViewDelegate
- (NSInteger)panelView:(id)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section;
- (UITableViewCell *)panelView:(id)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath;
- (void)panelView:(id)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath;
- (CGFloat)panelView:(id)panelView Page:(NSInteger)pageNumber heightForRowAtIndexPath:(PanelIndexPath *)indexPath;
- (BOOL)respondsToSelector:(SEL)selector;
- (NSInteger)panelView:(id)panelView numberOfSectionsInPage:(NSInteger)pageNumber;
- (NSString*)panelView:(id)panelView titleForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section;
- (CGFloat)panelView:(id)panelView heightForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section;
- (CGFloat)panelView:(id)panelView heightForFooterInPage:(NSInteger)pageNumber section:(NSInteger)section;
- (UIView *)panelView:(id)panelView viewForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section;
- (UIView *)panelView:(id)panelView viewForFooterInPage:(NSInteger)pageNumber section:(NSInteger)section;
@end

@interface PanelView : UIView <UITableViewDelegate, UITableViewDataSource>{
	int pageNumber;
	UITableView *tableView;
	id<PanelViewDelegate> delegate;
//	NSString *identifier;
}

@property (nonatomic, assign) int pageNumber;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) id<PanelViewDelegate> delegate;
//@property (nonatomic, retain) NSString *identifier;

- (id)initWithIdentifier:(NSString*)_identifier;
- (void)reset;
- (void)pageWillAppear;
- (void)pageDidAppear;
- (void)pageWillDisappear;


@end
