//
//  ImageScrollView.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-20.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseScrollView.h"
#import "UIImageView+WebCache.h"


@interface ImageScrollView : BaseScrollView
{
    UIImageView *helpImage;
}
-(id)initWithFrame:(CGRect)frame setCellBannerWithImageArray:(NSArray *)imageArray andText:(NSArray *)str;
@end
