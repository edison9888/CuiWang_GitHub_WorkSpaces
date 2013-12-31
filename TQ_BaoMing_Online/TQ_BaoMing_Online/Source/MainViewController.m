//
//  ViewController.m
//  SLCoverFlow
//
//  Created by jiapq on 13-6-13.
//  Copyright (c) 2013年 HNAGroup. All rights reserved.
//

#import "MainViewController.h"
#import "webViewController.h"
#import "SLCoverFlowView.h"
#import "SLCoverView.h"

static const CGFloat SLCoverViewWidth = 256.784698; // 图片的宽
static const CGFloat SLCoverViewHeight = 369.997955;//图片的高
static const CGFloat SLCoverViewSpace = 98.838562;//图片间的空隙
static const CGFloat SLCoverViewAngle = M_PI_4;//旋转的角度
static const CGFloat SLCoverViewScale = 1.137050;//图片的缩放

@interface MainViewController () <SLCoverFlowViewDataSource> {
    SLCoverFlowView *_coverFlowView;
    NSMutableArray *_colors; // 图片集合
    NSMutableArray *images; // 
    
    UISlider *_widthSlider;
    UISlider *_heightSlider;
    UISlider *_spaceSlider;
    UISlider *_angleSlider;
    UISlider *_scaleSlider;
    
    UIImageView *up;
    UIImageView *down;
    UIImageView *left;
    UIImageView *right;
}

@end

@implementation MainViewController


- (void)loadView {
    [super loadView];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]]];
//    CGRect frame = CGRectMake(-130, 70, 1024, 800);
    CGRect frame = self.view.bounds;
    frame.size.height /= 1.4;
    _coverFlowView = [[SLCoverFlowView alloc] initWithFrame:frame];
    _coverFlowView.backgroundColor = [UIColor clearColor];
    _coverFlowView.delegate = self;
    _coverFlowView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;//自适应
    _coverFlowView.coverSize = CGSizeMake(SLCoverViewWidth, SLCoverViewHeight); //图片大小
    _coverFlowView.coverSpace = 98.838562; // 图片间的距离 越小 越近
    _coverFlowView.coverAngle = 0.913105;//图片的旋转 越小 越平
    _coverFlowView.coverScale = 1.137050;// 图片的大小  越小 显示越小
    
    [self.view addSubview:_coverFlowView];
    
    up = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kuangkuang_01.png"]];
    up.frame = CGRectMake(330, 80+5, 379, 46);
    
    down = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kuangkuang_05.png"]];
    down.frame = CGRectMake(330, 80+46+395+5, 379, 46);
    //39 395
    left = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kuangkuang_02.png"]];
    left.frame = CGRectMake(330, 80+46+5, 39, 395);
    right = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kuangkuang_04.png"]];
    right.frame = CGRectMake(330+379-39, 80+46+5, 39, 395);
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(test)
                                                 name: @"move"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(test2)
                                                 name: @"stop"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(OpenWebView:)
                                                 name: @"openWeb"
                                               object: nil];
    
    [self.view addSubview:up];
    [self.view addSubview:down];
    [self.view addSubview:left];
    [self.view addSubview:right];
    
    //---------------------------------
    
    // width
    _widthSlider = [self addSliderWithMinY:(CGRectGetMaxY(_coverFlowView.frame) + 20.0) labelText:@"Width:"];
    _coverFlowView.coverSize = CGSizeMake(SLCoverViewWidth * _widthSlider.value,
                                              _coverFlowView.coverSize.height);
    
    // height
    _heightSlider = [self addSliderWithMinY:(CGRectGetMaxY(_widthSlider.frame) + 20.0) labelText:@"Height:"];
    [self.view addSubview:_heightSlider];
    _coverFlowView.coverSize = CGSizeMake(_coverFlowView.coverSize.width,
                                              SLCoverViewHeight * _heightSlider.value);
    
    // space
    _spaceSlider = [self addSliderWithMinY:(CGRectGetMaxY(_heightSlider.frame) + 20.0) labelText:@"Space:"];
    _coverFlowView.coverSpace = _spaceSlider.value * SLCoverViewSpace;
    
    // angle
    _angleSlider = [self addSliderWithMinY:(CGRectGetMaxY(_spaceSlider.frame) + 20.0) labelText:@"Angle:"];
    _coverFlowView.coverAngle = _angleSlider.value * SLCoverViewAngle;
    
    // scale
    _scaleSlider = [self addSliderWithMinY:(CGRectGetMaxY(_angleSlider.frame) + 20.0) labelText:@"Scale:"];
    _coverFlowView.coverScale = _scaleSlider.value * SLCoverViewScale;
    
    //---------------------------------
}

-(void)test
{
    
    [up setHidden:YES];
    [down setHidden:YES];
    [left setHidden:YES];
    [right setHidden:YES];

    
    
        }
-(void)test2
{
    [up setHidden:NO];
    [down setHidden:NO];
    [left setHidden:NO];
    [right setHidden:NO];
    
    
}
-(void)OpenWebView:(NSNotification *)_notification
{
    NSString *url = [_notification object];
    NSLog(@"url ==%@",url);
    
    webViewController *webView = [[webViewController alloc]init];
    webView.urlString = url;
    [self presentModalViewController:webView animated:YES];
//    [self presentViewController:webView animated:YES completion:^{
//        NSLog(@"打开浏览器!");
//    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    if (_colors) {
        [_colors removeAllObjects];
    }
    _colors = [NSMutableArray arrayWithCapacity:50];
    for (NSInteger i = 0; i < 7; ++i) {
        NSString *imagename = [NSString stringWithFormat:@"1%d.png",i+1];
        UIImage *image = [UIImage imageNamed:imagename];
        [_colors addObject:image];
    }
    
    [_coverFlowView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)valueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if ([slider isEqual:_widthSlider]) {
        NSLog(@"_widthSlider == %f",SLCoverViewWidth * _widthSlider.value);
        _coverFlowView.coverSize = CGSizeMake(SLCoverViewWidth * _widthSlider.value,
                                                  _coverFlowView.coverSize.height);
    } else if ([slider isEqual:_heightSlider]) {
        NSLog(@"_heightSlider == %f",SLCoverViewHeight * _heightSlider.value);
        _coverFlowView.coverSize = CGSizeMake(_coverFlowView.coverSize.width,
                                                  SLCoverViewHeight * _heightSlider.value);
    } else if ([slider isEqual:_spaceSlider]) {
         
        _coverFlowView.coverSpace = _spaceSlider.value * SLCoverViewSpace;
         NSLog(@"_coverFlowView.coverSpace == %f",  _coverFlowView.coverSpace);
    } else if ([slider isEqual:_angleSlider]) {
        
        _coverFlowView.coverAngle = _angleSlider.value * SLCoverViewAngle;
        NSLog(@" _coverFlowView.coverAngle == %f", _coverFlowView.coverAngle);
    } else if ([slider isEqual:_scaleSlider]) {
        _coverFlowView.coverScale = _scaleSlider.value * SLCoverViewScale;
        NSLog(@"_coverFlowView.coverScale == %f", _coverFlowView.coverScale);
    }
}

#pragma mark - SLCoverFlowViewDataSource 

- (NSInteger)numberOfCovers:(SLCoverFlowView *)coverFlowView {
    return _colors.count;
}

- (SLCoverView *)coverFlowView:(SLCoverFlowView *)coverFlowView coverViewAtIndex:(NSInteger)index {
    SLCoverView *view = [[SLCoverView alloc] initWithFrame:CGRectMake(0.0, 0.0, 128.0, 128.0)];
    view.imageView.image = [_colors objectAtIndex:index];
    view.imageView.tag = index;
    return view;
}

#pragma mark - Private methods

- (UISlider *)addSliderWithMinY:(CGFloat)minY labelText:(NSString *)labelText {
    CGRect labelFrame = CGRectMake(20.0, minY, 80.0, 30.0);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:22.0];
    label.text = labelText;
    label.textColor = [UIColor darkTextColor];
    [self.view addSubview:label];
    
    CGRect sliderFrame = CGRectMake(CGRectGetMaxX(labelFrame) + 20.0, minY, 200.0, 30.0);
    sliderFrame.size.width = CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(labelFrame) - 40.0;
    UISlider *slider = [[UISlider alloc] initWithFrame:sliderFrame];
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    slider.minimumValue = 0.0;
    slider.maximumValue = 2.0;
    slider.value = 1.0;
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    return slider;
}
#pragma mark - 强制横屏
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    //return YES;
}
@end
