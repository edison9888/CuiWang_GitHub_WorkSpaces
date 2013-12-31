#import "PanelsViewController.h"
#import "resultViewController.h"
#import "HomeViewController.h"

@implementation UIScrollViewExt
@synthesize isEditing;
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if (isEditing) return self;
	else return [super hitTest:point withEvent:event];
}
@end


@interface PanelsViewController()
- (void)tilePages;
- (void)configurePage:(PanelView*)page forIndex:(int)index;
- (BOOL)isDisplayingPageForIndex:(int)index;
- (PanelView *)panelForPage:(NSInteger)page;
@end

@implementation PanelsViewController
@synthesize scrollView;
@synthesize recycledPages, visiblePages;
@synthesize offsetArray;
@synthesize tableV;
@synthesize panelV;


- (void)loadView
{
   
	[super loadView];
    
	[self.view setBackgroundColor:[UIColor whiteColor]];
    [self StartTimer];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(mytest:) name:@"clickData" object:nil];
     [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(mytest2:) name:@"clickData2" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(clickover:) name:@"overData" object:nil];
    //-------
    self.TopView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lianxijieguo__03.png"]];
    
    _TopView.userInteractionEnabled = YES;
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10, 11,24, 37);
    [_backBtn setImage:[UIImage imageNamed:@"zhuce_1.png"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"zhuce_2.png"] forState:UIControlStateHighlighted];
    [_backBtn addTarget:self action:@selector(backBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tipBtn.frame = CGRectMake(92, 11,24, 37);
    [_tipBtn setImage:[UIImage imageNamed:@"biaoji_2.png"] forState:UIControlStateNormal];
    [_tipBtn setImage:[UIImage imageNamed:@"biaoji_1.png"] forState:UIControlStateHighlighted];
    [_tipBtn setImage:[UIImage imageNamed:@"biaoji_1.png"] forState:UIControlStateSelected];
    [_tipBtn setSelected:YES];
    [_tipBtn addTarget:self action:@selector(tipBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cardBtn.frame = CGRectMake(184, 11,24, 37);
    [_cardBtn setImage:[UIImage imageNamed:@"card_1.png"] forState:UIControlStateNormal];
    [_cardBtn setImage:[UIImage imageNamed:@"card.png"] forState:UIControlStateHighlighted];
    [_cardBtn addTarget:self action:@selector(cardBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeBtn.frame = CGRectMake(286, 5,24, 37);
    [_timeBtn setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal];
    [_timeBtn setTitle:@"aaa" forState:UIControlStateNormal];
    //    [timeBtn setImage:[UIImage imageNamed:@"biaoji.png"] forState:UIControlStateHighlighted];
    [_timeBtn addTarget:self action:@selector(timeBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeLb = [[UILabel alloc]initWithFrame:CGRectMake(280, 35, 40, 14)];
    _timeLb.textAlignment = 1;
    _timeLb.font = [UIFont systemFontOfSize:10.0];
    _timeLb.text = [NSString stringWithFormat:@"%d 秒",mTime];
    
    [_TopView addSubview:_timeBtn];
    [_TopView addSubview:_tipBtn];
    [_TopView addSubview:_cardBtn];
    [_TopView addSubview:_backBtn];
     [_TopView addSubview:_timeLb];
    
    [self.view addSubview:_TopView];
	
    //--------
	CGRect frame = [self scrollViewFrame];
	self.scrollView = [[UIScrollViewExt alloc] initWithFrame:CGRectMake(-1*GAP,57.0,frame.size.width+2*GAP,frame.size.height)];
	[self.scrollView setDelegate:self];
	[self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
  
	[self.scrollView setPagingEnabled:YES];
	[self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[self.view addSubview:self.scrollView];
	[self.scrollView release];
	[self.scrollView setContentSize:CGSizeMake(([self panelViewSize].width+2*GAP)*[self numberOfPanels],self.scrollView.frame.size.height)];
	
	self.recycledPages = [NSMutableSet new];
	self.visiblePages = [NSMutableSet new];
	
	[self tilePages];
}

- (void)StartTimer
{
    //repeats设为YES时每次 invalidate后重新执行，如果为NO，逻辑执行完后计时器无效
    mTime = 0;

    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAdvanced:) userInfo:nil repeats:YES];
}

- (void)timerAdvanced:(NSTimer *)time//这个函数将会执行一个循环的逻辑
{
    //加一个计数器
    
    if (mTime == 0)
        {
        [time invalidate];
        [self StartTimer];
        }
    mTime++;
     _timeLb.text = [NSString stringWithFormat:@"%d 秒",mTime];
   
}
-(void)backBtnDidClick:(id)sender
{
    
    HomeViewController *homeV = [[HomeViewController alloc]init];
    [self presentViewController:homeV animated:YES completion:^{
        NSLog(@"关闭练习页面------回调");//这里打个断点，点击按钮模态视图移除后会回到这里
        
        
        if(timer != nil)
            {
            [timer invalidate];
            timer = nil;
            }
    }];
   
}

-(void)tipBtnDidClick:(UIButton *)sender
{
    
    if (sender.selected) {
        sender.selected = NO;
    }
    else
        {
        sender.selected = YES;
        }
}

-(void)cardBtnDidClick:(id)sender
{
    resultViewController *result = [[resultViewController alloc]initWithNibName:@"resultViewController" bundle:nil];
    [self presentViewController:result animated:YES completion:^{
        NSLog(@"打开答题卡页面------回调");
    }];
}
-(void)timeBtnDidClick:(id)sender
{
    
}

- (void)dealloc 
{
    //移除observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickData" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickData2" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"overData" object:nil];
	[self.scrollView release];
	[self.recycledPages release];
	[self.visiblePages release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
   
	panelV = [self panelViewAtPage:currentPage];
	[panelV pageDidAppear];
}
#define viewAppear @"viewAppear"
- (void)viewWillAppear:(BOOL)animated
{
	panelV = [self panelViewAtPage:currentPage];
	[panelV pageWillAppear];
}
- (void) mytest:(NSNotification*) notification
{
    int obj = [[notification object] intValue]-1;//获取到传递的对象
     [self.scrollView setContentOffset:CGPointMake(([self panelViewSize].width+2*GAP)*obj,0) animated:NO];
}
- (void) mytest2:(NSNotification*) notification
{
    if(timer != nil)
        {
        [timer invalidate];
        timer = nil;
        }
    int obj = [[notification object] intValue]-1;//获取到传递的对象
    int obj2 = [[[notification userInfo] objectForKey:@"obj"] intValue];
    
     _timeLb.text = [NSString stringWithFormat:@"%d 秒",obj2];
    [self.scrollView setContentOffset:CGPointMake(([self panelViewSize].width+2*GAP)*obj,0) animated:NO];
    
    
}
- (void) clickover:(NSNotification*) notification
{
    if(timer != nil)
        {
        [timer invalidate];
        timer = nil;
        }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"timeData" object:[NSNumber numberWithInt:mTime]];
        
}
- (void)viewWillDisappear:(BOOL)animated
{
	panelV = [self panelViewAtPage:currentPage];
	[panelV pageWillDisappear];
}

#pragma mark editing

- (void)shouldWiggle:(BOOL)wiggle
{
	for (int i=0; i<[self numberOfPanels]; i++)
	{
		panelV = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+i];
		[panelV shouldWiggle:wiggle];
		
	}
}

- (void)setEditing:(BOOL)isEditing
{
	_isEditing = isEditing;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.2];
	[self.scrollView setIsEditing:isEditing];
	[self shouldWiggle:isEditing];
	if (isEditing)
	{
		[self.scrollView setTransform:CGAffineTransformMakeScale(0.5, 0.5)];
		[self.scrollView setClipsToBounds:NO];
	}
	else 
	{
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(onEditingAnimationStopped)];
		[self.scrollView setTransform:CGAffineTransformMakeScale(1, 1)];
		
	}

	[UIView commitAnimations];
}

- (void)onEditingAnimationStopped
{
	[self.scrollView setClipsToBounds:YES];
}

#pragma mark frame and sizes

/*
 Overwrite this to change size of scroll view.
 Default implementation fills the screen
 */
- (CGRect)scrollViewFrame
{
	return CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height);
}

- (CGSize)panelViewSize
{
	float width = [self scrollViewFrame].size.width;
	if ([self numberOfVisiblePanels]>1)
	{
		width = ([self scrollViewFrame].size.width-2*GAP*([self numberOfVisiblePanels]-1))/[self numberOfVisiblePanels];
	}
	
	return CGSizeMake(width,[self scrollViewFrame].size.height);
}

/*
 Overwrite this to change number of visible panel views
 */
- (int)numberOfVisiblePanels
{
	return 1;
}

#pragma mark adding and removing panels

- (void)addPage
{
	//numberOfPages += 1;
	[self.scrollView setContentSize:CGSizeMake(([self panelViewSize].width+2*GAP)*[self numberOfPanels],self.scrollView.frame.size.width)];
}

- (void)removeCurrentPage
{	
	if (currentPage==[self numberOfPanels] && currentPage!=0)
	{
		// this is the last page
		//numberOfPages -= 1;
		
		panelV= (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
		[panelV showPanel:NO animated:YES];
		[self removeContentOfPage:currentPage];
		
		[panelV performSelector:@selector(showPreviousPanel) withObject:nil afterDelay:0.4];
		[self performSelector:@selector(jumpToPreviousPage) withObject:nil afterDelay:0.6];
	}
	else if ([self numberOfPanels]==0)
	{
		panelV= (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
		[panelV showPanel:NO animated:YES];
		[self removeContentOfPage:currentPage];
	}
	else 
	{
		panelV = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
		[panelV showPanel:NO animated:YES];
		[self removeContentOfPage:currentPage];
		[self performSelector:@selector(pushNextPage) withObject:nil afterDelay:0.4];
	}
}

- (void)jumpToPreviousPage
{
	[self.scrollView setContentSize:CGSizeMake(([self panelViewSize].width+2*GAP)*[self numberOfPanels],self.scrollView.frame.size.width)];
}

- (void)pushNextPage
{
    NSLog(@"pushNextPage");
	[self.scrollView setContentSize:CGSizeMake(([self panelViewSize].width+2*GAP)*[self numberOfPanels],self.scrollView.frame.size.width)];
	
	for (int i=currentPage; i<[self numberOfVisiblePanels]; i++)
	{
		if (currentPage < [self numberOfPanels])
		{
			panelV = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+i];
			[panelV showNextPanel];
			[panelV pageWillAppear];
		}
		
	}
}

- (void)removeContentOfPage:(int)page
{
	
}

#pragma mark scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView_
{
 
	panelV = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
	[panelV pageWillDisappear];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView_
{

	[self tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
	
	if (currentPage!=lastDisplayedPage)
	{
		panelV= (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
		[panelV pageDidAppear];
	}
	
	lastDisplayedPage = currentPage;
}

#pragma mark reuse table views

- (void)tilePages
{
    	CGRect visibleBounds = [self.scrollView bounds];
	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds)) * [self numberOfVisiblePanels];
	int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds)) * [self numberOfVisiblePanels];

	firstNeededPageIndex = MAX(firstNeededPageIndex,0);
	lastNeededPageIndex = MIN(lastNeededPageIndex, [self numberOfPanels]-1) + [self numberOfVisiblePanels];
	
	if (_isEditing) firstNeededPageIndex -= 1;
	
	if (firstNeededPageIndex<0) firstNeededPageIndex = 0;
	if (lastNeededPageIndex>=[self numberOfPanels]) lastNeededPageIndex = [self numberOfPanels]-1;
	
	currentPage = firstNeededPageIndex;
	
	for (PanelView *panel in self.visiblePages)
	{
		if (panel.pageNumber < firstNeededPageIndex || panel.pageNumber > lastNeededPageIndex)
		{
			[self.recycledPages addObject:panel];
			[panel removeFromSuperview];
			[panel shouldWiggle:NO];
		}
	}
	[self.visiblePages minusSet:self.recycledPages];
	
	for (int index=firstNeededPageIndex; index<=lastNeededPageIndex; index++)
	{
		if (![self isDisplayingPageForIndex:index])
		{
			PanelView *panel = [self panelForPage:index];
			int x = ([self panelViewSize].width+2*GAP)*index + GAP;
			CGRect panelFrame = CGRectMake(x,0,[self panelViewSize].width,[self scrollViewFrame].size.height);
			
			[panel setFrame:panelFrame];
			[panel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
			[panel setDelegate:self];
			[panel setTag:TAG_PAGE+index];
			[panel setPageNumber:index];
			[panel pageWillAppear];

			[self.scrollView addSubview:panel];
			[self.visiblePages addObject:panel];
			[panel shouldWiggle:_isEditing];
		}
	}
}

- (BOOL)isDisplayingPageForIndex:(int)index
{
	for (PanelView *page in self.visiblePages)
	{
		if (page.pageNumber==index) return YES;
	}
	return NO;
}

- (void)configurePage:(PanelView*)page forIndex:(int)index
{
	int x = ([self.view bounds].size.width+2*GAP)*index + GAP;
	CGRect pageFrame = CGRectMake(x,0,[self.view bounds].size.width,[self.view bounds].size.height);
	[page setFrame:pageFrame];
	[page setPageNumber:index];
	[page pageWillAppear];
}

- (PanelView*)dequeueReusablePageWithIdentifier:(NSString*)identifier
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.identifier == %@", identifier];
	NSSet *filteredSet =[self.recycledPages filteredSetUsingPredicate:predicate];
	PanelView *page = [filteredSet anyObject];
	if (page)
	{
		[[page retain] autorelease];
		[self.recycledPages removeObject:page];
	}
	return page;
}

#pragma mark panel views

- (PanelView *)panelViewAtPage:(NSInteger)page
{
	panelV = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+page];
	return panelV;
}

- (PanelView *)panelForPage:(NSInteger)page
{
	static NSString *identifier = @"PanelTableView";
	panelV = (PanelView*)[self dequeueReusablePageWithIdentifier:identifier];
	if (panelV == nil)
	{
		panelV = [[[PanelView alloc] initWithIdentifier:identifier] autorelease];
	}
	return panelV;
}

- (NSInteger)numberOfPanels
{
	return 0;
}

- (CGFloat)panelView:(PanelView *)panelView heightForRowAtIndexPath:(PanelIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200;
    }
	return 50;
}

- (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
{
	static NSString *identity = @"UITableViewCell";
	UITableViewCell *cell = (UITableViewCell*)[panelView.tableView dequeueReusableCellWithIdentifier:identity];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity] autorelease];
	}
	return cell;
}

- (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
{
	return 0;
}

- (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath
{
	
}

- (NSInteger)panelView:(id)panelView numberOfSectionsInPage:(NSInteger)pageNumber
{
	return 1;
}
//- (CGFloat)panelView:(UITableView *)panelView heightForHeaderInSection:(NSInteger)section
//{
//    return 100;
//}
//- (UIView *)panelView:(UITableView *)panelView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 100)];
//    lab.text = @"aaaa";
//    return lab;
//}
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    
}
- (void)saveTableviewOffset:(int)index
{
    
}
- (void)restoreTableviewOffset:(int)index
{
    
}
- (BOOL)respondsToSelector:(SEL)aSelector
{
	return [super respondsToSelector:aSelector];
}


@end
