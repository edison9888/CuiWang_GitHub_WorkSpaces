//
//  FlowCoverViewController.m
//  FlowCover
//
//  Created by William Woody on 12/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "FlowCoverViewController.h"
#import "webViewController.h"
@implementation FlowCoverViewController




// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor redColor]];
    }
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.




/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
			(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc 
{
    [super dealloc];
}



/************************************************************************/
/*																		*/
/*	FlowCover Callbacks													*/
/*																		*/
/************************************************************************/

- (int)flowCoverNumberImages:(FlowCoverView *)view
{
	return 7;
}

- (UIImage *)flowCover:(FlowCoverView *)view cover:(int)image
{
	switch (image % 6) {
		case 0:
		default:
			return [UIImage imageNamed:@"11.png"];
		case 1:
			return [UIImage imageNamed:@"12.png"];
		case 2:
			return [UIImage imageNamed:@"13.png"];
		case 3:
			return [UIImage imageNamed:@"14.png"];
		case 4:
			return [UIImage imageNamed:@"15.png"];
		case 5:
			return [UIImage imageNamed:@"16.png"];
        case 6:
			return [UIImage imageNamed:@"17.png"];

	}
}

- (void)flowCover:(FlowCoverView *)view didSelect:(int)image
{
	NSLog(@"Selected Index %d",image);
    webViewController *webView = [[webViewController alloc]init];
    webView.urlString = @"http://www.taiqiedu.com";
    [self presentModalViewController:webView animated:YES];
}


@end
