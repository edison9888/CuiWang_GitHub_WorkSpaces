//
//  UserEntity.h
//  PassValueTest
//
//  Created by 唐韧 on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEntity : NSObject
{
    NSString *userName;
    NSString *gendar;
    int age;
}

@property(nonatomic,retain) NSString *userName;
@property(nonatomic,retain) NSString *gendar;
@property(assign) int age;

@end
