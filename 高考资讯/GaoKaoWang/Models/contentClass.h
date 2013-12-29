//
//  contentClass.h
//  GaoKaoWang
//
//  Created by cui wang on 13-12-11.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface contentClass : NSObject
@property(nonatomic,strong) NSString *cID;
@property(nonatomic,strong) NSString *cTitle;
@property(nonatomic,strong) NSString *cnID;
@property(nonatomic,strong) NSString *cImage;
-(NSString *) toString;
@end
