//
//  AGCustomShareViewController.h
//  AGShareSDKDemo
//
//  Created by 冯 鸿杰 on 13-3-5.
//  Copyright (c) 2013年 vimfung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AGCommon/CMImageView.h>
#import <ShareSDK/ShareSDK.h>
#import "AGCustomShareViewToolbar.h"

@class AppDelegate;

/**
 *	@brief	自定义分享视图控制器
 */
@interface AGCustomShareViewController : UIViewController <UITextViewDelegate>
{
@private
    UITextView *_textView;
    UIImageView *_picImageView;
    AGCustomShareViewToolbar *_toolbar;
    UIButton *_atButton;
    UIImageView *_contentBG;
    UIImageView *_toolbarBG;
    UIImageView *_picBG;
    UIImageView *_pinImageView;
    UILabel *_atTipsLabel;
    UILabel *_wordCountLabel;
    
    NSString *_image;
    NSString *_content;
    NSString *_mytitle;
    NSString *_myurl;
    NSString *_catid;
    NSString *_nid;
    CGFloat _keyboardHeight;
    AppDelegate *_appDelegate;
}

/**
 *	@brief	初始化视图控制器
 *
 *	@param 	image 	图片
 *	@param 	content 	内容
 *
 *	@return	视图控制器
 */
- (id)initWithImage:(NSString *)image
            content:(NSString *)content title:(NSString *)title url:(NSString *)url CatID:(NSString *)catid ContentID:(NSString *)nid;


@end
