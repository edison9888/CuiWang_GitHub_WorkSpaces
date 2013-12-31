//
//  ExamViewController.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-6-20.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PanelIndexPath : NSObject {
	int page, section, row;
}

- (id)initWithRow:(int)_row section:(int)_section page:(int)_page;
+ (id)panelIndexPathForRow:(int)_row section:(int)_section page:(int)_page;
+ (id)panelIndexPathForPage:(int)_page indexPath:(NSIndexPath*)indexPath;

@property (nonatomic, assign) int page, section, row;

@end
