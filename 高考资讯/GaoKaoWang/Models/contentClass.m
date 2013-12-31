//
//  contentClass.m
//  GaoKaoWang
//
//  Created by cui wang on 13-12-11.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "contentClass.h"

@implementation contentClass
@synthesize cID;
@synthesize cTitle;
@synthesize cnID;
@synthesize cImage;
@synthesize cCommntTime;
@synthesize cTagID;

-(NSString *) toString
{
    if(cID == nil || cTitle == nil || cnID == nil || cImage == nil )
        {
            return @"内容不存在";
        } else {
            return [NSString stringWithFormat:@"cID == %@  cTitle == %@  cnID == %@  cImage == %@",cID,cTitle,cnID,cImage];
        }
}
@end

