//
//  SearchViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-28.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "SearchViewController.h"
#import "HomeViewController.h"
#import "DataSearchViewController.h"
#import "ContentViewController.h"
#import "ZYQSphereView.h"

@interface SearchViewController ()
{
    ZYQSphereView *sphereView;
    NSTimer *timer;
}
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.t.text = @"搜索";
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(reflashUI) name:@"reflashSearchUI" object:nil];
        keyWordArray = [[NSMutableArray alloc]initWithCapacity:50];
    }
    return self;
}

-(void)reflashUI
{
//    [self buildCV];
}

-(void)popback
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)SearchButtonClick:(id)sender {
    
    
    DataSearchViewController *dataVC = [[DataSearchViewController alloc]initWithData:@"高考" delegate:self];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
   
    [self.navigationController pushViewController:dataVC animated:YES];
}

#pragma mark - DATAsearch页面 点击后的代理方法
- (void)dataSearchdidSelectWithCaiID:(NSString *)catid withContentID:(NSString *)nid withContentTitle:(NSString *)title withContentImage:(NSString *)image
{
    DLog(@"DATAsearch页面 点击后的代理方法 catid == %@",catid);
    
    ContentViewController *contentVC;
    if (isIPhone5) {
        contentVC = [[ContentViewController alloc]initWithCatID:catid ContentID:nid ContentTitle:title Content:nil Cimage:image NibName:@"ContentViewController_ip5" bundle:nil];
    } else {
        
        contentVC = [[ContentViewController alloc]initWithCatID:catid ContentID:nid ContentTitle:title Content:nil Cimage:image NibName:@"ContentViewController" bundle:nil];
    }
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:contentVC];
    nav.modalTransitionStyle = 2;

    [self presentViewController:nav animated:YES completion:^{
    }];

}



- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self buildCV];
    if (isIPhone5) {
        
        sphereView = [[ZYQSphereView alloc] initWithFrame:CGRectMake(0, 160, 320, 409)];
    } else {
        sphereView = [[ZYQSphereView alloc] initWithFrame:CGRectMake(0, 160, 320, 309)];
    }
 sphereView.center=CGPointMake(self.view.center.x, self.view.center.y+80);
    [CW_Tools ToastNotification:@"加载热门关键词..." andView:self.view andLoading:YES andIsBottom:YES doSomething:^{
        [self getDataFromUrl];
        NSArray *labelARy =[NSArray arrayWithArray:keyWordArray];
        NSMutableArray *views = [[NSMutableArray alloc] init];
        for (int i = 0; i < 30; i++) {
            
            
            NSString *thstr = labelARy[i];
            
            UIFont *thfont=[UIFont systemFontOfSize:16];
            
            //        CGFloat thstrwidth=[thstr sizeWithFont:thfont constrainedToSize:CGSizeMake(1000, FONTHEIGHT)].width;
            
            CGFloat thstrwidth=[thstr boundingRectWithSize:CGSizeMake(1000, 35) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:thfont} context:nil].size.width+20;
            
            
            
            UIButton *subV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, thstrwidth, 35)];
            subV.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100. green:arc4random_uniform(100)/100. blue:arc4random_uniform(100)/100. alpha:1];
            [subV setTitle:thstr forState:UIControlStateNormal];
            subV.layer.masksToBounds=YES;
            subV.layer.cornerRadius=3;
            [subV addTarget:self action:@selector(subVClick:) forControlEvents:UIControlEventTouchUpInside];
            [views addObject:subV];
        }
        
        [sphereView setItems:views];
    }];
    
    
    sphereView.isPanTimerStart=YES;
    
    [self.view addSubview:sphereView];
    [sphereView timerStart];
    
}
/**
 *    http://www.gkk12.com/index.php?m=content&c=khdindex&a=remenkeywords
 */
-(void)getDataFromUrl
{
    NSURL *url = [NSURL URLWithString:@"http://www.gkk12.com/index.php?m=content&c=khdindex&a=remenkeywords"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSData *data = [request responseData];
        NSDictionary *titlerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        for (NSDictionary *dic in titlerDic) {
            [keyWordArray addObject:[dic objectForKey:@"keyword"]];
        }
        
    }
}

-(void)subVClick:(UIButton*)sender{
    NSLog(@"%@",sender.titleLabel.text);
    
    BOOL isStart=[sphereView isTimerStart];
    
    [sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        sender.transform=CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            sender.transform=CGAffineTransformMakeScale(1, 1);
            if (isStart) {
                [sphereView timerStart];
            }
        }];
    }];
    
    DataSearchViewController *dataVC = [[DataSearchViewController alloc]initWithData:sender.titleLabel.text delegate:self];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    [self.navigationController pushViewController:dataVC animated:YES];
    
}
/**
 *    重建CV

-(void)buildCV
{
    
    if (cv) {
        [cv removeFromSuperview];
    }
    
    if (isIPhone5) {
        
        cv=[[CloudView alloc] initWithFrame:CGRectMake(0, 160, 320, 409)];
    } else {
        cv=[[CloudView alloc] initWithFrame:CGRectMake(0, 160, 320, 309)];
    }
    cv.cloudDelegate = self;
    
    [self.view addSubview:cv];
    
    [self getDataFromUrl];
    NSArray *labelARy =[NSArray arrayWithArray:keyWordArray];
    if (labelARy.count > 0) {
        
        [cv reloadData:labelARy];
    }
}
  */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [sphereView removeFromSuperview];
    // Dispose of any resources that can be recreated.
}

@end
