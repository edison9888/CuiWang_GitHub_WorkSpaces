//
//  SelectItemsViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-27.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "SelectItemsViewController.h"
#import "AppDelegate.h"

#define buttonWidth 67.5f
#define buttonHeight 30.0f
#define marginLeft 10.0f
#define marginTop 10.0f
@interface SelectItemsViewController ()

@end

@implementation SelectItemsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
        upArray = [[NSMutableArray alloc]initWithCapacity:10];
        downArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
//    [CW_Tools ToastNotification:@"正在努力加载最新数据..." andView:self.view andLoading:YES andIsBottom:NO doSomething: ^{
        titleArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"titleArray"];
        tmpArray = [[NSMutableArray alloc]initWithCapacity:10];
        
        for (NSDictionary *dic in titleArray) {
            titleClass *tmpClass = [titleClass new];
            tmpClass.catid = [dic objectForKey:@"catid"];
            tmpClass.catname = [dic objectForKey:@"catname"];
            [tmpArray addObject:tmpClass];
        }
    
    
        [self flashUIbyGetData:tmpArray];
//	}];
    
}

-(void)flashUIbyGetData:(NSMutableArray *)titlearray
{
    int count = [titlearray count] - 2;
    
    for (int y = 0; y <= count / 4; y++) {
        for (int x = 0; x < 4; x++) {
            int i = 4 * y + x + 2;
            if (i < [titlearray count]) {
                NSString *titleLb = ((titleClass *)titlearray[i]).catname;
                DLog(@" %@",titleLb);
                int titleTag = [((titleClass *)titlearray[i]).catid intValue];
                UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
                itemButton.titleLabel.textColor = [UIColor blackColor];
                [itemButton setFrame:CGRectMake(marginLeft + x * (buttonWidth+marginLeft), marginTop + y * (buttonHeight+marginTop), buttonWidth, buttonHeight)];
                itemButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"kuangkuang.png"]];
                itemButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
                [itemButton setTitle:titleLb forState:UIControlStateNormal];
                [itemButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [itemButton setTag:titleTag];
//                if (i < 2) {
//                    [itemButton setEnabled:NO];
//                    itemButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gengduopindao_kuangkuang.png"]];
//                }
                [itemButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
                [self.myScrollView addSubview:itemButton];
            }
        }
    }
}

-(void)Click:(UIButton *)button
{
    if (button.selected) {
        [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"kuangkuang.png"]]];
        button.selected = NO;
    }else {
        [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"kuangkuang_1.png"]]];
        button.selected = YES;
    }
}


- (IBAction)beginReadClick:(id)sender {
    
    NSString *titleLb = ((titleClass *)tmpArray[0]).catname;
    NSString *titleTag = ((titleClass *)tmpArray[0]).catid;
    
    NSString *titleLb2 = ((titleClass *)tmpArray[1]).catname;
    NSString *titleTag2 = ((titleClass *)tmpArray[1]).catid;
    
    NSDictionary *thisDic = @{@"catid": titleTag,@"catname":titleLb};
    NSDictionary *thisDic2 = @{@"catid": titleTag2,@"catname":titleLb2};
    
    [upArray addObject:thisDic];
    [upArray addObject:thisDic2];
    
    
    for (UIView *btnView in [self.myScrollView subviews]) {
        if ([btnView isMemberOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)btnView;
            if (btn.selected) {
                NSDictionary *thisDic = @{@"catid": [NSString stringWithFormat:@"%d",btn.tag],@"catname":btn.titleLabel.text};
                [upArray addObject:thisDic];
            }else {
                NSDictionary *thisDic = @{@"catid": [NSString stringWithFormat:@"%d",btn.tag],@"catname":btn.titleLabel.text};
                [downArray addObject:thisDic];
            }
        }
        
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:upArray forKey:@"titleArray"];
    [ud setBool:YES forKey:@"UserIsLoaded"];
    [ud synchronize];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    DrawerController = [app loadMainVC];
    [self.navigationController pushViewController:DrawerController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
