//
//  GKListEasyCell.h
//  GaoKaoWang
//
//  Created by cui wang on 13-12-31.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class contentClass;
@interface GKListEasyCell : UITableViewCell
{
    UILabel *titleLabel;
    UILabel *timeLabel;
}
@property(nonatomic,strong) contentClass *content;
@end
