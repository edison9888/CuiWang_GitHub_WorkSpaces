//
//  GKListCell.m
//  GaoKaoWang
//
//  Created by cui wang on 13-12-30.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "GKListCell.h"
@implementation GKListCell

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
       thumbImageView = (UIImageView *) [self viewWithTag:100];
        titleLabel = (UILabel *) [self viewWithTag:101];
        contentTime = (UILabel *) [self viewWithTag:102];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSString *thumbImageUrlStr = _contentOBJ.cImage;
    if (thumbImageUrlStr.length > 0) {
        [thumbImageView setImageWithURL:[NSURL URLWithString:thumbImageUrlStr] placeholderImage:[UIImage imageNamed:@"gengduopindao_kuangkuang.png"]];
    }
    titleLabel.text = _contentOBJ.cTitle;
    contentTime.text = _contentOBJ.cCommntTime;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
