//
//  FeedBackViewController.m
//  TaiQi
//
//  Created by cui wang on 13-5-6.
//
//

#import "FeedBackViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import <QuartzCore/QuartzCore.h>
@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       UILabel* t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        t.font = [UIFont systemFontOfSize:20];
        t.textColor = [UIColor whiteColor];
        t.backgroundColor = [UIColor clearColor];
        t.textAlignment = 1;
        t.text = @"意见反馈";
        self.navigationItem.titleView = t;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"comm_header.png"] forBarMetrics:UIBarMetricsDefault];
    //  设置自定义返回按钮风格
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"toleft.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button addTarget:self action:@selector(popback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    bubbleTable.bubbleDataSource = self;
    
    bubbleData = [[NSMutableArray alloc] initWithObjects:
                  [NSBubbleData dataWithText:@"您好!欢迎您给我们提出产品的使用感受和建议!" andDate:[NSDate dateWithTimeIntervalSinceNow:0] andType:BubbleTypeSomeoneElse],
                  //                  [NSBubbleData dataWithText:@"Well, I haven't said no to you yet, have I?" andDate:[NSDate dateWithTimeIntervalSinceNow:-280] andType:BubbleTypeSomeoneElse],
                  //                  [NSBubbleData dataWithText:@"Marge... Oh, damn it." andDate:[NSDate dateWithTimeIntervalSinceNow:0] andType:BubbleTypeMine],
                  //                  [NSBubbleData dataWithText:@"What's wrong?" andDate:[NSDate dateWithTimeIntervalSinceNow:300]  andType:BubbleTypeSomeoneElse],
                  //                  [NSBubbleData dataWithText:@"Ohn I wrote down what I wanted to say on a card.." andDate:[NSDate dateWithTimeIntervalSinceNow:395]  andType:BubbleTypeMine],
                  //                  [NSBubbleData dataWithText:@"The stupid thing must have fallen out of my pocket." andDate:[NSDate dateWithTimeIntervalSinceNow:400]  andType:BubbleTypeMine],
                  nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
}
-(void)popback
{
    [self dismissViewControllerAnimated:YES completion:^{
        //        <#code#>
    }];
}
-(void)loadView
{
    [super loadView];
    bubbleTable = [[UIBubbleTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height-60)];
    //------
    input = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, 250, 40)];
    [input setBorderStyle:UITextBorderStyleBezel]; //外框类型
    input.backgroundColor = [UIColor whiteColor];
    input.placeholder = @"请输入..."; //默认显示的字
    input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; 
    input.autocorrectionType = UITextAutocorrectionTypeNo;
    input.autocapitalizationType = UITextAutocapitalizationTypeNone;
    input.returnKeyType = UIReturnKeyDone;
    input.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    input.delegate = self;
    
    send = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [send setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send setFrame:CGRectMake(260, 10, 55, 40)];
    [send addTarget:self action:@selector(Send:) forControlEvents:UIControlEventTouchUpInside];
    //------------
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-60, 320, 60)];
    [myView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"yijianfankui-1.png"]]];
    myView.userInteractionEnabled = YES;
    [myView addSubview:input];
    [myView addSubview:send];
    //  设置自定义返回按钮风格
    UIButton *Back_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [Back_button setBackgroundImage:[UIImage imageNamed:@"toleft"] forState:UIControlStateNormal];
    [Back_button setFrame:CGRectMake(0, 0, 30, 30)];
    [Back_button addTarget:self action:@selector(popback) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:Back_button];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.view addSubview:bubbleTable];
    [self.view addSubview:myView];
    
    //[self.view addSubview:input];
}

- (void)viewDidUnload
{
    send = nil;
    [super viewDidUnload];
}

//bool isReturn;
- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    [sender resignFirstResponder];
        CGRect listFrame = CGRectMake(0, 0, self.view.width,self.view.height);
        [UIView beginAnimations:@"anim" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        //处理移动事件，将各视图设置最终要达到的状态
        
        self.view.frame=listFrame;
        
        [UIView commitAnimations];
        
//    isReturn = TRUE;
    return YES;
}
-(void)keyboardWillShow:(NSNotification *)notification
{
//    isReturn = FALSE;
//        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
//        CGRect keyboardBounds;
//        [keyboardBoundsValue getValue:&keyboardBounds];
        CGRect listFrame = CGRectMake(0, -WXHLkDefaultPortraitKeyboardHeight-30, self.view.frame.size.width,self.view.frame.size.height);
        [UIView beginAnimations:@"anim" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        //处理移动事件，将各视图设置最终要达到的状态
        
        self.view.frame=listFrame;
        
        [UIView commitAnimations];
        
}
- (void)Send:(UIButton *)sender
{
//    if (isReturn) {
    
        if (input.text.length)
            {
            
            
            
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.gkk12.com/index.php?m=content&c=khdindex&a=userfankui&ufklianxi=%@&ufkcontent=%@",@"123",input.text]];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request startSynchronous];
            NSError *error = [request error];
            if (!error) {
                NSString *response = [request responseString];
                DLog(@"%@",response);
                if ([response isEqualToString:@"1"]) {
                    [bubbleData addObject:[NSBubbleData dataWithText:input.text andDate:[NSDate dateWithTimeIntervalSinceNow:0] andType:BubbleTypeMine]];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[bubbleData count]-1];
                    
                    [bubbleTable reloadData];
                    [bubbleTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    [NSTimer scheduledTimerWithTimeInterval: 3
                                                     target: self
                                                   selector: @selector(handleTimer)
                                                   userInfo: nil
                                                    repeats: NO];
                } else {
                    [bubbleData addObject:[NSBubbleData dataWithText:@"意见反馈,失败了!" andDate:[NSDate dateWithTimeIntervalSinceNow:0] andType:BubbleTypeSomeoneElse]];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[bubbleData count]-1];
                    
                    [bubbleTable reloadData];
                    [bubbleTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    [NSTimer scheduledTimerWithTimeInterval: 1
                                                     target: self
                                                   selector: @selector(handleTimer)
                                                   userInfo: nil
                                                    repeats: NO];
                }
            }
            
            }
//    }
    
}

-(void)handleTimer
{
   
     [bubbleData addObject:[NSBubbleData dataWithText:@"感谢您对我们的产品提出宝贵的建议!" andDate:[NSDate dateWithTimeIntervalSinceNow:0] andType:BubbleTypeSomeoneElse]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[bubbleData count]-1];
    
    [bubbleTable reloadData];
    [bubbleTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return bubbleData[row];
}


@end
