//
//  DataSearchViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-29.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "DataSearchViewController.h"
#import "contentClass.h"
#import "Bank.h"
#import "ContentViewController.h"



@interface DataSearchViewController ()

@end

@implementation DataSearchViewController


- (id)initWithData:(NSString *)dataStr
              delegate:(id<DataSearchDelegate>)delegate
{
    
    if (isIPhone5) {
        self = [super initWithNibName:@"DataSearchViewController_ip5" bundle:nil];
    }else {
        self = [super initWithNibName:@"DataSearchViewController" bundle:nil];
    }
    
    if (self) {
        self.t.text = @"开始搜索";
        _list = [[NSMutableArray alloc]initWithCapacity:10];
        self.dataStr = dataStr;
        self.delegate = delegate;
    }
    return self;
}

#pragma mark 更新数据
#pragma mark - 添加数据
-(void)addDataToViewISPullUpStr:(NSString *)str
{
    NSString *urlstr;
    
    [_list removeAllObjects];
    
        NSString *utf8ParamValue = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        urlstr = [NSString stringWithFormat:@"http://www.gkk12.com/index.php?m=content&c=khdindex&a=khdkeyword&keyword=%@",utf8ParamValue];
    
    NSURL *url = [NSURL URLWithString:urlstr];
    __unsafe_unretained __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
//        NSString *str = [request responseString];
//        DLog(@"aaa \n%@",str);
        NSData *data = [request responseData];
        NSDictionary *titlerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary *dic in titlerDic) {
            contentClass *content = [contentClass new];
            content.cID = [dic objectForKey:@"catid"];
            content.cTitle = [dic objectForKey:@"title"];
            content.cnID = [dic objectForKey:@"id"];
            content.cImage = [dic objectForKey:@"image"];
            [_list addObject:content];
        }
        //--------重置
        [self.contentView reloadData];
    }];
    [request setFailedBlock:^{
        [ALToastView toastInView:self.view withText:@"连接服务器失败! "];
    }];
    [request startAsynchronous];
    
    

    
    
}
-(void)popback
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"reflashSearchUI"
														object: nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellDentifier";
    UITableViewCell *cell ;

    contentClass *content = [_list objectAtIndex:indexPath.row];
    cell  =  (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if(cell == nil)
        {
        cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
        }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.contentMode = UIViewContentModeScaleAspectFit;
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.textLabel.text = content.cTitle;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    contentClass *content = nil;
    content = [_list objectAtIndex:indexPath.row];
    __block UINavigationController *nav;
    [CW_Tools ToastNotification:@"加载中..." andView:self.mySearchBar andLoading:YES andIsBottom:NO doSomething:^{
        ContentViewController *contentVC;
        
        if (isIPhone5) {
            contentVC = [[ContentViewController alloc]initWithCatID:content.cID ContentID:content.cnID ContentTitle:content.cTitle  Content:nil Cimage:content.cImage NibName:@"ContentViewController_ip5" bundle:nil];
        } else {
            
            contentVC = [[ContentViewController alloc]initWithCatID:content.cID ContentID:content.cnID ContentTitle:content.cTitle  Content:nil Cimage:content.cImage NibName:@"ContentViewController" bundle:nil];
        }
        nav = [[UINavigationController alloc]initWithRootViewController:contentVC];
        nav.modalTransitionStyle = 2;
    }];
   
    
    [self presentViewController:nav animated:YES completion:^{
    }];

    
    
    
//    if ([_delegate respondsToSelector:@selector(dataSearchdidSelectWithCaiID:withContentID:withContentTitle:withContentImage:)]) {
//        [_delegate dataSearchdidSelectWithCaiID:content.cID withContentID:content.cnID withContentTitle:content.cTitle withContentImage:content.cImage];
//    }
}
#pragma mark -
#pragma mark search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
    DLog(@"%@",searchBar.text);
    if ([searchBar.text isEqualToString:@""]) {
        return;
    }
    
    [CW_Tools ToastNotification:@"搜索中..." andView:self.mySearchBar andLoading:YES andIsBottom:NO doSomething:^{
        [self addDataToViewISPullUpStr:searchBar.text];
    }];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_mySearchBar resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [CW_Tools ToastNotification:@"正在搜索..." andView:self.view andLoading:YES andIsBottom:NO doSomething:^{
        [self addDataToViewISPullUpStr:self.dataStr];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
