
#import "PanelsViewController.h"
#define OffUpHeight 59.0f

@implementation UIScrollViewExt

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

- (void)loadView
{
	[super loadView];
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	CGRect frame = [self scrollViewFrame];
//    NSLog(@"frame   %f   %f",frame.size.width,frame.size.height);
	self.scrollView = [[UIScrollViewExt alloc] initWithFrame:CGRectMake(-1*GAP,OffUpHeight,frame.size.width+2*GAP,frame.size.height)];
//    NSLog(@"frame scrollView   %f   %f",self.scrollView.frame.size.width,self.scrollView.frame.size.height);
	[self.scrollView setDelegate:self];
	[self.scrollView setShowsHorizontalScrollIndicator:NO];
	[self.scrollView setPagingEnabled:YES];
	[self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[self.view addSubview:self.scrollView];
	[self.scrollView release];
	[self.scrollView setContentSize:CGSizeMake(([self panelViewSize].width+2*GAP)*[self numberOfPanels],self.scrollView.frame.size.height)];
	
	self.recycledPages = [NSMutableSet new];
	self.visiblePages = [NSMutableSet new];
	
	[self tilePages];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
	[self.scrollView release];
	[self.recycledPages release];
	[self.visiblePages release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
	PanelView *panelView = [self panelViewAtPage:currentPage];
	[panelView pageDidAppear];
}

- (void)viewWillAppear:(BOOL)animated
{
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	PanelView *panelView = [self panelViewAtPage:currentPage];
	[panelView pageWillDisappear];
}


#pragma mark frame and sizes

/*
 Overwrite this to change size of scroll view.
 Default implementation fills the screen
 */
- (CGRect)scrollViewFrame
{
	return CGRectMake(0,OffUpHeight,[self.view bounds].size.width,[self.view bounds].size.height-OffUpHeight);
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


#pragma mark scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView_
{
	PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
	[panelView pageWillDisappear];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView_
{
	//NSLog(@"%@", scrollView_);
	[self tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
    NSLog(@"scrollViewDidEndDecelerating");
	if (currentPage!=lastDisplayedPage)
	{
		PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
		[panelView pageDidAppear];
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
	
	
	if (firstNeededPageIndex<0) firstNeededPageIndex = 0;
	if (lastNeededPageIndex>=[self numberOfPanels]) lastNeededPageIndex = [self numberOfPanels]-1;
	
	currentPage = firstNeededPageIndex;
	
	for (PanelView *panel in self.visiblePages)
	{
		if (panel.pageNumber < firstNeededPageIndex || panel.pageNumber > lastNeededPageIndex)
		{
			[self.recycledPages addObject:panel];
			[panel removeFromSuperview];
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
	PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+page];
	return panelView;
}

- (PanelView *)panelForPage:(NSInteger)page
{
//	static NSString *identifier = @"PanelTableView";
//	PanelView *panelView = (PanelView*)[self dequeueReusablePageWithIdentifier:identifier];
//	if (panelView == nil)
//	{
		PanelView *panelView = [[[PanelView alloc] initWithFrame:CGRectZero]autorelease];
//	}
	return panelView;
}

- (NSInteger)numberOfPanels
{
	return 0;
}

- (CGFloat)panelView:(PanelView *)panelView heightForRowAtIndexPath:(PanelIndexPath *)indexPath
{
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
- (CGFloat)panelView:(id)panelView Page:(NSInteger)pageNumber heightForRowAtIndexPath:(PanelIndexPath *)indexPath
{
    return 44.0f;
}
- (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath
{
	//点击响应
}

- (NSInteger)panelView:(id)panelView numberOfSectionsInPage:(NSInteger)pageNumber
{
	return 1;
}

- (CGFloat)panelView:(id)panelView heightForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section
{
    return 0;
}

- (CGFloat)panelView:(id)panelView heightForFooterInPage:(NSInteger)pageNumber section:(NSInteger)section
{
    return 0.1;
}

- (UIView *)panelView:(id)panelView viewForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section
{
    return nil;
}

- (UIView *)panelView:(id)panelView viewForFooterInPage:(NSInteger)pageNumber section:(NSInteger)section
{
    return nil;
}

- (NSString*)panelView:(id)panelView titleForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section
{
	return [NSString stringWithFormat:@"Page %i Section %i", pageNumber, section];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
	return [super respondsToSelector:aSelector];
}


@end
