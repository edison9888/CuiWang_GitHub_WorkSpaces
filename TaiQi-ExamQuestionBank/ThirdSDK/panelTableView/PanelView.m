
#import "PanelView.h"

@interface PanelView()
@end

@implementation PanelView
@synthesize pageNumber;
@synthesize tableView;
@synthesize delegate;
//@synthesize identifier;

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		[self setBackgroundColor:[UIColor whiteColor]];
		self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
		[self addSubview:self.tableView];
		[self.tableView setDelegate:self];
		[self.tableView setDataSource:self];
//        [self.tableView release];
    }
    return self;
}

- (id)initWithIdentifier:(NSString*)_identifier
{
	if (self = [super init])
	{
//		NSLog(@".... init with identifier");
//		self.identifier = _identifier;
	}
	return self;
}

- (void)setFrame:(CGRect)frame_
{
	[super setFrame:frame_];
	
	CGRect tableViewFrame = [self.tableView frame];
	tableViewFrame.size.width = self.frame.size.width;
	tableViewFrame.size.height = self.frame.size.height;
	[self.tableView setFrame:tableViewFrame];
}

- (void)reset
{
	//NSLog(@"reset page %i", pageNumber);
}

- (void)pageWillAppear
{
	NSLog(@"page will appear %i", pageNumber);
	//[self showPanel:YES animated:YES];
	//[self removePanelWithAnimation:YES];
    //加载数据？
    
//	[self.tableView reloadData];
    
//	[self restoreTableviewOffset];
}

- (void)pageDidAppear
{
	NSLog(@"page did appear %i", pageNumber);
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, 0)];
	//[self showPanel:YES animated:YES];
}

- (void)pageWillDisappear
{
//	[self saveTableviewOffset];
}

- (void)dealloc 
{
//	[self.identifier release];
	[self.tableView release];
    [super dealloc];
}



#pragma mark table

- (CGFloat)tableView:(UITableView *)tableView_ heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([delegate respondsToSelector:@selector(panelView:Page:heightForRowAtIndexPath:)])
	{
		return [delegate panelView:self Page:self.pageNumber heightForRowAtIndexPath:[PanelIndexPath panelIndexPathForPage:self.pageNumber indexPath:indexPath]];
	}
	else return 44.0f;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([delegate respondsToSelector:@selector(panelView:didSelectRowAtIndexPath:)])
	{
		return [delegate panelView:self didSelectRowAtIndexPath:[PanelIndexPath panelIndexPathForPage:self.pageNumber indexPath:indexPath]];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([delegate respondsToSelector:@selector(panelView:cellForRowAtIndexPath:)])
	{
		return [delegate panelView:self cellForRowAtIndexPath:[PanelIndexPath panelIndexPathForPage:self.pageNumber indexPath:indexPath]];
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
	if ([delegate respondsToSelector:@selector(panelView:numberOfRowsInPage:section:)])
	{
		return [delegate panelView:self numberOfRowsInPage:self.pageNumber section:section];
	}
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if ([delegate respondsToSelector:@selector(panelView:numberOfSectionsInPage:)])
	{
		return [delegate panelView:self numberOfSectionsInPage:self.pageNumber];
	}
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ([delegate respondsToSelector:@selector(panelView:titleForHeaderInPage:section:)])
	{
		return [delegate panelView:self titleForHeaderInPage:self.pageNumber section:section];
	}
	return nil;
}
// Variable height support


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([delegate respondsToSelector:@selector(panelView:heightForHeaderInPage:section:)])
        {
		return [delegate panelView:self heightForHeaderInPage:self.pageNumber section:section];
        }
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([delegate respondsToSelector:@selector(panelView:heightForFooterInPage:section:)])
        {
		return [delegate panelView:self heightForFooterInPage:self.pageNumber section:section];
        }
	return 0;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([delegate respondsToSelector:@selector(panelView:viewForHeaderInPage:section:)])
        {
		return [delegate panelView:self viewForHeaderInPage:self.pageNumber section:section];
        }
	return nil;
}// custom view for header. will be adjusted to default or specified header height

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([delegate respondsToSelector:@selector(panelView:viewForFooterInPage:section:)])
        {
		return [delegate panelView:self viewForFooterInPage:self.pageNumber section:section];
        }
	return nil;
}// custom view for footer. will be adjusted to default or specified footer height

@end
