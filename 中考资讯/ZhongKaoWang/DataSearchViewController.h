//
//  DataSearchViewController.h
//  GaoKaoWang
//
//  Created by cui wang on 13-11-29.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    DataSearchStateBank = 0,
} DataSearchState;

@class DataSearchViewController;
@protocol DataSearchDelegate <NSObject>

- (void)dataSearchdidSelectWithCaiID:(NSString *)catid withContentID:(NSString *)nid withContentTitle:(NSString *)title withContentImage:(NSString *)image;
@end

@interface DataSearchViewController : BaseViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_list;
}

@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (strong, nonatomic) IBOutlet UITableView *contentView;
@property (nonatomic,weak)id<DataSearchDelegate> delegate;
@property (nonatomic,strong)NSString *dataStr;

- (id)initWithData:(NSString *)dataStr
          delegate:(id<DataSearchDelegate>)delegate;
@end
