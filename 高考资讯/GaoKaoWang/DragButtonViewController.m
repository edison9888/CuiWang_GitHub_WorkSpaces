//
//  DragButtonViewController.m
//  GaoKaoWang
//
//  Created by cui wang on 13-11-26.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "DragButtonViewController.h"
#import "GKSlideSwitchView.h"
#define buttonWidth 67.5f
#define downButtonHeight 35.0f
#define buttonHeight 30.0f
#define marginLeft 10.0f
#define marginTopHead 10.0f
#define marginTop 20.0f
#define marginTop2 marginTop+marginTopHead+buttonHeight+marginTop
#define separateHeight 240.0f
@interface DragButtonViewController ()

@property (nonatomic, readonly) UIScrollView *scrollView;
@end

@implementation DragButtonViewController
@synthesize scrollView = _scrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       self.t.text = @"编辑栏目";
        newtitleArray = [[NSMutableSet alloc]initWithCapacity:10];
        dragDownTitleArray = [[NSMutableArray alloc]initWithCapacity:10];

        
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    self.scrollView.frame = CGRectMake(0, 5, 320, self.view.height-5);
//    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
}
#pragma mrak 获取栏目列表
-(void)getDataFromURL
{
    NSURL *url = [NSURL URLWithString:@"http://www.gkk12.com/index.php?m=content&c=khdindex&a=gkkhdmenu"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSData *data = [request responseData];
        NSDictionary *titlerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        [newtitleArray removeAllObjects];//清空
        for (NSDictionary *dic in titlerDic) {
            DLog(@"%@",[dic objectForKey:@"catname"]);
            
            NSDictionary *thisDic = @{@"catid": [dic objectForKey:@"catid"],@"catname":[dic objectForKey:@"catname"]};
            
            [newtitleArray addObject:thisDic];
            
        }
        
    }
}
-(void)popback
{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *title = [[NSMutableArray alloc]initWithCapacity:10];
//    NSMutableArray *titledowm = [[NSMutableArray alloc]initWithCapacity:10];
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_header.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *thisDic = @{@"catid": [NSString stringWithFormat:@"%d",bgBtn.tag],@"catname":bgBtn.titleLabel.text};
    NSDictionary *thisDic2 = @{@"catid": [NSString stringWithFormat:@"%d",bgBtn2.tag],@"catname":bgBtn2.titleLabel.text};
    
    [title addObject:thisDic];
    [title addObject:thisDic2];
    
    for (UIDragButton *button in upButtons) {
        NSDictionary *thisDic = @{@"catid": [NSString stringWithFormat:@"%d",button.tag],@"catname":button.titleLabel.text};
        [title addObject:thisDic];
    }
//    for (UIDragButton *button in downButtons) {
//        NSDictionary *thisDic = @{@"catid": [NSString stringWithFormat:@"%d",button.tag],@"catname":button.titleLabel.text};
//        [titledowm addObject:thisDic];
//    }
    
    NSArray *myViewDidLoadArr = [ud objectForKey:@"titleArray"];//取得之前的标题数组
    [ud setObject:title forKey:@"titleArray"];//设置移动后的上面按钮标题数组
//    [ud setObject:titledowm forKey:@"dragDownTitleArray"];//设置移动后的下面按钮标题数组
    //-------对比
    NSArray *titleDidLoad = title;
    NSMutableArray *reDidLoadArr = [[NSMutableArray alloc]initWithCapacity:10];
    NSString *str = @"1";
    //--------标题数组有变化  视图全部重置
    if (![myViewDidLoadArr isEqualToArray:titleDidLoad]) {
        DLog(@"标题个数或顺序变化!");
        str = @"0";
        [reDidLoadArr addObject:@"推荐"];
        [reDidLoadArr addObject:@"热点"];
        [ud setObject:reDidLoadArr forKey:@"myViewDidLoad"];
    }
    [ud synchronize];
    //--------通知刷新UI
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reflashHomeUI" object:str];
    
    [self dismissViewControllerAnimated:YES completion:^{
//        <#code#>
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [CW_Tools ToastNotification:@"正在获取最新栏目..." andView:self.view andLoading:YES andIsBottom:NO doSomething:^{
        [self getDataFromURL];
        [self addItems];
    }];
   
}

- (void)addItems
{
    //拖动排序
    UILabel *txtpxLB = [[UILabel alloc]initWithFrame:CGRectMake(10,0,150, 30)];
    txtpxLB.text = @"拖动排序";
    txtpxLB.textColor = [UIColor grayColor];
    [self.scrollView addSubview:txtpxLB];
    
    //--------上面的按钮初始化
    upButtons = [[NSMutableArray alloc] init];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    
    titleArray = [ud objectForKey:@"titleArray"];
    //--------刷新数据
    for (NSDictionary *dic in newtitleArray) {
        if ([titleArray containsObject:dic]) {
        }else {
            [dragDownTitleArray addObject:dic];
        }
    }
    
    
    bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(marginLeft, marginTop+marginTopHead, buttonWidth, buttonHeight);
    [bgBtn setBackgroundImage:[UIImage imageNamed:@"yiyoupindao_kuangkuang.png"] forState:UIControlStateNormal];
    [bgBtn setTitle:[(NSDictionary *)titleArray[0] objectForKey:@"catname"] forState:UIControlStateNormal];//推荐
    [bgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    bgBtn.tag = [[(NSDictionary *)titleArray[0] objectForKey:@"catid"] intValue];
    bgBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [bgBtn setEnabled:NO];
    [self.scrollView addSubview:bgBtn];
    
    bgBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn2.frame = CGRectMake(marginLeft+buttonWidth+marginLeft, marginTop+marginTopHead, buttonWidth, buttonHeight);
    [bgBtn2 setBackgroundImage:[UIImage imageNamed:@"yiyoupindao_kuangkuang.png"] forState:UIControlStateNormal];
    [bgBtn2 setTitle:[(NSDictionary *)titleArray[1] objectForKey:@"catname"] forState:UIControlStateNormal];//热点
    [bgBtn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    bgBtn2.tag = [[(NSDictionary *)titleArray[1] objectForKey:@"catid"] intValue];
    bgBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
    [bgBtn2 setEnabled:NO];
    [self.scrollView addSubview:bgBtn2];
    
    for (int i = 2; i < [titleArray count]; i++) {
        upbutton = [[UIDragButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andTitle:[(NSDictionary *)titleArray[i] objectForKey:@"catname"] inView:self.view];
        [upbutton setBackgroundImage:[UIImage imageNamed:@"yiyoupindao_kuangkuang.png"] forState:UIControlStateNormal];
        [upbutton setTitleColor:[CW_Tools colorFromHexRGB:@"4fb199"] forState:UIControlStateNormal];
        [upbutton setLocation:up];
        [upbutton setDelegate:self];
        [upbutton setTag:[[(NSDictionary *)titleArray[i] objectForKey:@"catid"] intValue]];
        [self.scrollView addSubview:upbutton];
        [upButtons addObject:upbutton];
    }
    
    //--------设置上面按钮的位置
    [self setUpButtonsFrameWithAnimate:NO withoutShakingButton:nil];
    
    //--------分割线
    UILabel *txtLB = [[UILabel alloc]initWithFrame:CGRectMake(10, separateHeight-30,150, 30)];
    txtLB.text = @"更多频道";
    txtLB.textColor = [UIColor grayColor];
    [self.scrollView addSubview:txtLB];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, separateHeight, 320, 6)];
    [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gengduopindao.png"]]];
    [self.scrollView addSubview:label];
    
    //--------下面的按钮初始化
    downButtons = [[NSMutableArray alloc] init];
    for (int i = 0; i < [dragDownTitleArray count]; i++) {
        downbutton = [[UIDragButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andTitle:[(NSDictionary *)dragDownTitleArray[i] objectForKey:@"catname"] inView:self.view];
        [downbutton setBackgroundImage:[UIImage imageNamed:@"gengduopindao_kuangkuang.png"] forState:UIControlStateNormal];
        [downbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [downbutton setLocation:down];
        [downbutton setDelegate:self];
        [downbutton setTag:[[(NSDictionary *)dragDownTitleArray[i] objectForKey:@"catid"] intValue]];
        [self.scrollView addSubview:downbutton];
        [downButtons addObject:downbutton];
    }
    
    if ([downButtons count] <= 0) return;
    //设置下面的按钮位置
    [self setDownButtonsFrameWithAnimate:NO withoutShakingButton:nil];
}
-(void)click:(UIDragButton *)button
{
    if ([upButtons count] >= 14) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"最多16个栏目!";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    } else {
        [downButtons removeObject:button];
        
        if (![upButtons containsObject:button]) {
            [upButtons addObject:button];
            [button setLastCenter:CGPointMake(0, 0)];
            [button setLocation:up];
        }
        [self setUpButtonsFrameWithAnimate:YES withoutShakingButton:nil];
        [self setDownButtonsFrameWithAnimate:YES withoutShakingButton:nil];
    }
    
    
}
#pragma mark - 设置按钮的frame

- (void)checkLocationOfOthersWithButton:(UIDragButton *)shakingButton
{
    switch (shakingButton.location) {
        case up:
        {
        int indexOfShakingButton = 0;
        for ( int i = 0; i < [upButtons count]; i++) {
            if (((UIDragButton *)[upButtons objectAtIndex:i]).tag == shakingButton.tag) {
                indexOfShakingButton = i;
                break;
            }
        }
        for (int i = 0; i < [upButtons count]; i++) {
            UIDragButton *button = (UIDragButton *)[upButtons objectAtIndex:i];
            if (button.tag != shakingButton.tag){
                if (CGRectIntersectsRect(shakingButton.frame, button.frame)) {
                    [upButtons exchangeObjectAtIndex:i withObjectAtIndex:indexOfShakingButton];
                    [self setUpButtonsFrameWithAnimate:YES withoutShakingButton:shakingButton];
                    break;
                }
            }
        }
        
        break;
        }
        case down:
        {
        int indexOfShakingButton = 0;
        for ( int i = 0; i < [downButtons count]; i++) {
            if (((UIDragButton *)[downButtons objectAtIndex:i]).tag == shakingButton.tag) {
                indexOfShakingButton = i;
                break;
            }
        }
        for (int i = 0; i < [downButtons count]; i++) {
            UIDragButton *button = (UIDragButton *)[downButtons objectAtIndex:i];
            if (button.tag != shakingButton.tag){
                if (CGRectIntersectsRect(shakingButton.frame, button.frame)) {
                    [downButtons exchangeObjectAtIndex:i withObjectAtIndex:indexOfShakingButton];
                    [self setDownButtonsFrameWithAnimate:YES withoutShakingButton:shakingButton];
                    break;
                }
            }
        }
        
        break;
        }
        default:
            break;
    }
}



-(void)UpButtonsFrameSet:(UIDragButton *)shakingButton
{
    int count = [upButtons count];
    DLog(@"upButtons count == %d",count);
    int newcount = count;
    if (count > 2) {
        newcount -= 2;
    }
    
    if (shakingButton != nil) {
        for (int i = 0; i < 2; i++) {
            if (i < count) {
                
                UIDragButton *button = (UIDragButton *)[upButtons objectAtIndex:i];
                [button setBackgroundImage:[UIImage imageNamed:@"yiyoupindao_kuangkuang.png"] forState:UIControlStateNormal];
                [button setTitleColor:[CW_Tools colorFromHexRGB:@"4fb199"] forState:UIControlStateNormal];
                
                if (button.tag != shakingButton.tag) {
                    [button setFrame:CGRectMake(marginLeft + (i+2) * (buttonWidth+marginLeft), marginTop+marginTopHead, buttonWidth, buttonHeight)];
                }
                [button setLastCenter:CGPointMake(marginLeft + (i+2) * (buttonWidth+marginLeft) + buttonWidth/2, marginTop +marginTopHead+ buttonHeight/2)];
            }
            
        }
        //------count = 5 newcount = 3
        if (count > 2) {
            for (int y = 0; y <= newcount / 4; y++) {
                for (int x = 0; x < 4; x++) {
                    int i = 4 * y + x+2;
                    if (i < count) {
                        UIDragButton *button = (UIDragButton *)[upButtons objectAtIndex:i];
                        [button setBackgroundImage:[UIImage imageNamed:@"yiyoupindao_kuangkuang.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[CW_Tools colorFromHexRGB:@"4fb199"] forState:UIControlStateNormal];
                        
                        if (button.tag != shakingButton.tag) {
                            [button setFrame:CGRectMake(marginLeft + x * (buttonWidth+marginLeft), marginTop2 + y * (buttonHeight+marginTop), buttonWidth, buttonHeight)];
                        }
                        [button setLastCenter:CGPointMake(marginLeft + x * (buttonWidth+marginLeft) + buttonWidth/2, marginTop2 + y * (buttonHeight+marginTop) + buttonHeight/2)];
                    }
                }
            }
        }
    }
    else {
        for (int i = 0; i < 2; i++) {
            if (i < count) {
                UIDragButton *button = (UIDragButton *)[upButtons objectAtIndex:i];
                [button setBackgroundImage:[UIImage imageNamed:@"yiyoupindao_kuangkuang.png"] forState:UIControlStateNormal];
                [button setTitleColor:[CW_Tools colorFromHexRGB:@"4fb199"] forState:UIControlStateNormal];
                
                [button setFrame:CGRectMake(marginLeft + (i+2) * (buttonWidth+marginLeft), marginTop+marginTopHead, buttonWidth, buttonHeight)];
                [button setLastCenter:CGPointMake(marginLeft + (i+2) * (buttonWidth+marginLeft) + buttonWidth/2, marginTop +marginTopHead+ buttonHeight/2)];
            }
        }
        if (count > 2) {
            for (int y = 0; y <= newcount / 4; y++) {
                for (int x = 0; x < 4; x++) {
                    int i = 4 * y + x+2;
                    if (i < count) {
                        UIDragButton *button = (UIDragButton *)[upButtons objectAtIndex:i];
                        [button setBackgroundImage:[UIImage imageNamed:@"yiyoupindao_kuangkuang.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[CW_Tools colorFromHexRGB:@"4fb199"] forState:UIControlStateNormal];
                        
                        [button setFrame:CGRectMake(marginLeft + x * (buttonWidth+marginLeft), marginTop2 + y * (buttonHeight+marginTop), buttonWidth, buttonHeight)];
                        [button setLastCenter:CGPointMake(marginLeft + x * (buttonWidth+marginLeft) + buttonWidth/2, marginTop2 + y * (buttonHeight+marginTop) + buttonHeight/2)];
                    }
                }
            }
        }
    }
}
-(void)DownButtonsFrameSet:(UIDragButton *)shakingButton
{
    int count = [downButtons count];
    if (shakingButton != nil) {
        for (int y = 0; y <= count / 4; y++) {
            for (int x = 0; x < 4; x++) {
                int i = 4 * y + x;
                if (i < count) {
                    float downbuttonHeight = separateHeight +marginTop+ y * (downButtonHeight+marginTop);
                    
                    UIDragButton *button = (UIDragButton *)[downButtons objectAtIndex:i];
                    [button setBackgroundImage:[UIImage imageNamed:@"gengduopindao_kuangkuang.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (shakingButton.tag != button.tag) {
                        [button setFrame:CGRectMake(marginLeft + x * (buttonWidth+marginLeft), downbuttonHeight, buttonWidth, downButtonHeight)];
                    }
                    [button setLastCenter:CGPointMake(marginLeft + x * (buttonWidth+marginLeft) + buttonWidth/2, downbuttonHeight+ downButtonHeight/2)];
                   
                    if (count / 12 > 0) {
                        int num = count - 12;
                         self.scrollView.contentSize = CGSizeMake(320, downbuttonHeight+(marginTop*3+downButtonHeight)*((num / 4+1) ));
                    } else {
                        self.scrollView.contentSize = CGSizeMake(320, 370);
                    }
                    
                }
            }
        }
    }
    else {
        
        for (int y = 0; y <= count / 4; y++) {
            for (int x = 0; x < 4; x++) {
                int i = 4 * y + x;
                if (i < count) {
                    float downbuttonHeight = separateHeight +marginTop+ y * (downButtonHeight+marginTop);
                    
                    UIDragButton *button = (UIDragButton *)[downButtons objectAtIndex:i];
                    [button setBackgroundImage:[UIImage imageNamed:@"gengduopindao_kuangkuang.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [button setFrame:CGRectMake(marginLeft + x * (buttonWidth+marginLeft),downbuttonHeight, buttonWidth, downButtonHeight)];
                    [button setLastCenter:CGPointMake(marginLeft + x * (buttonWidth+marginLeft) + buttonWidth/2, downbuttonHeight+ downButtonHeight/2)];
                    
                    if (count / 12 > 0) {
                        int num = count - 12;
                        self.scrollView.contentSize = CGSizeMake(320, downbuttonHeight+(marginTop*3+downButtonHeight)*((num / 4+1) ));
                    } else {
                        self.scrollView.contentSize = CGSizeMake(320, 370);
                    }
                }
            }
        }
    }
    
}
- (void)setUpButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton
{
    if (shakingButton != nil) {
        if (_bool) {
            [UIView animateWithDuration:0.4 animations:^{
                [self UpButtonsFrameSet:shakingButton];
            }];
        }else{
            [self UpButtonsFrameSet:shakingButton];
        }
        
    }else{
        if (_bool) {
            [UIView animateWithDuration:0.4 animations:^{
                [self UpButtonsFrameSet:shakingButton];
            }];
        }else{
            [self UpButtonsFrameSet:shakingButton];
        }
    }
}

- (void)setDownButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton
{
    
    if (shakingButton != nil) {
        if (_bool) {
            [UIView animateWithDuration:0.4 animations:^{
                [self DownButtonsFrameSet:shakingButton];
            }];
            
        }else{
            [self DownButtonsFrameSet:shakingButton];
        }
    }else{
        if (_bool) {
            
            [UIView animateWithDuration:0.4 animations:^{
                [self DownButtonsFrameSet:shakingButton];
            }];
            
        }else{
            [self DownButtonsFrameSet:shakingButton];
        }
        
    }
}


#pragma mark - UIDragButton Delegate

- (void)removeShakingButton:(UIDragButton *)button fromUpButtons:(BOOL)_bool
{
    if (_bool) {
        if ([upButtons containsObject:button]) {
            [upButtons removeObject:button];
        }
    }else{
        if ([downButtons containsObject:button]) {
            [downButtons removeObject:button];
        }
    }
}

- (void)arrangeUpButtonsWithButton:(UIDragButton *)button andAdd:(BOOL)_bool
{
    if (_bool) {
        
        if (![upButtons containsObject:button]) {
            [upButtons addObject:button];
        }
    }else{
        [upButtons removeObject:button];
        int insertIndex = [downButtons count];
        
        if (insertIndex == 0) {
            [downButtons addObject:button];
        } else {
            
            for (int i = 0; i <= [downButtons count]; i++) {
                if (i == 0) {
                    if (button.center.x <= ((UIDragButton *)[downButtons objectAtIndex:i]).center.x) {
                        insertIndex = i;
                        break;
                    }
                }else if (i == downButtons.count){
                    break;
                }else if (0 < i && i < downButtons.count){
                    UIDragButton *button1 = (UIDragButton *)[downButtons objectAtIndex:i - 1];
                    UIDragButton *button2 = (UIDragButton *)[downButtons objectAtIndex:i];
                    if ((button.center.x > button1.center.x) && (button.center.x <= button2.center.x)) {
                        insertIndex = i;
                        break;
                    }
                }
            }
            [downButtons insertObject:button atIndex:insertIndex];
            
        }
    }
    
    if (upButtons.count <= 0) return;
    [self setUpButtonsFrameWithAnimate:YES withoutShakingButton:nil];
}

//--------上面按钮个数
-(int)numofupbutton
{
    return [upButtons count];
}
//--------上面按钮个数
-(int)numofdownbutton
{
    return [downButtons count];
}

- (void)arrangeDownButtonsWithButton:(UIDragButton *)button andAdd:(BOOL)_bool
{
    if (_bool) {
        if (![downButtons containsObject:button]) {
            [downButtons addObject:button];
        }
    }else{
        if ([upButtons count] > 15) {
            [button setLocation:down];
        } else {
            [downButtons removeObject:button];
            [upButtons addObject:button];
        }
    }
    if (downButtons.count <= 0) return;
    [self setDownButtonsFrameWithAnimate:YES withoutShakingButton:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}
- (UIScrollView *)scrollView
{
    if (!_scrollView)
        {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        }
    return _scrollView;
}
- (void)scrollToBottomWithScrollView:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.height -370 > 0)
        {
        [scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height - 370) animated:YES];
        }
}
@end
