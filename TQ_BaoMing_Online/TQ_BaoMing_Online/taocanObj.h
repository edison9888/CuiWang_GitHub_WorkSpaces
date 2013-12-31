//
//  taocanObj.h
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-10-10.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface taocanObj : NSObject
@property(nonatomic,strong)NSString *sID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *original_price;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSMutableArray *taocan_content_Obj;
@end
