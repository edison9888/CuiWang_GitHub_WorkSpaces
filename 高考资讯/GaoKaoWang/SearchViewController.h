//
//  SearchViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-28.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseViewController.h"
#import "DataSearchViewController.h"
//#import "CloudView.h"
@interface SearchViewController : BaseViewController<DataSearchDelegate>
{
//    CloudView *cv;
    NSMutableArray *keyWordArray;
}

@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@end
