//
//  GKListCell.h
//  GaoKaoWang
//
//  Created by cui wang on 13-12-30.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "contentClass.h"
@interface GKListCell : UITableViewCell
{
    UIImageView *thumbImageView;
    UILabel *titleLabel;
    UILabel *contentTime;
}
@property(nonatomic,strong)contentClass * contentOBJ;
@end
