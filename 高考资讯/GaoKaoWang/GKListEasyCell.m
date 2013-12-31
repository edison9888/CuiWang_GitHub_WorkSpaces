//
//  GKListEasyCell.m
//  GaoKaoWang
//
//  Created by cui wang on 13-12-31.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "GKListEasyCell.h"
#import "contentClass.h"
@implementation GKListEasyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    titleLabel = (UILabel *)[self viewWithTag:201];
    timeLabel = (UILabel *)[self viewWithTag:202];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    titleLabel.text = self.content.cTitle;
    timeLabel.text = self.content.cCommntTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
