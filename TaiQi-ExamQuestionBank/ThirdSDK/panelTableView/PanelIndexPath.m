

#import "PanelIndexPath.h"


@implementation PanelIndexPath
@synthesize page, section, row;

- (id)initWithRow:(int)_row section:(int)_section page:(int)_page
{
	if (self = [super init])
	{
		self.row = _row;
		self.section = _section;
		self.page = _page;
	}
	return self;
}

+ (id)panelIndexPathForRow:(int)_row section:(int)_section page:(int)_page
{
	return [[[self alloc] initWithRow:_row section:_section page:_page] autorelease];
}

+ (id)panelIndexPathForPage:(int)_page indexPath:(NSIndexPath*)indexPath
{
	return [[[self alloc] initWithRow:indexPath.row section:indexPath.section page:_page] autorelease];
}

@end
