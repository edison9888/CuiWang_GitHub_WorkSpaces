
#import "GKSlideSwitchView.h"
#import "titleClass.h"

#define isNetOk [CW_Tools checkNetworkConnection]

static const CGFloat kHeightOfTopScrollView = 33.0f;
static const CGFloat kWidthOfButtonMargin = 16.0f;
static const CGFloat kFontSizeOfTabButton = 16.0f;
static const NSUInteger kTagOfRightSideButton = 999;

@implementation GKSlideSwitchView

#pragma mark - 初始化参数

- (void)initValues
{
    //创建顶部可滑动的tab
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kHeightOfTopScrollView)];
    _topScrollView.delegate = self;
    _topScrollView.backgroundColor = [UIColor whiteColor];
    _topScrollView.pagingEnabled = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_topScrollView];
    _userSelectedChannelID = 100;
    //创建主滚动视图
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeightOfTopScrollView, self.bounds.size.width, self.bounds.size.height - kHeightOfTopScrollView)];
//        DLog(@"_rootScrollView 宽高  %f   %f",self.bounds.size.height,self.bounds.size.height - kHeightOfTopScrollView);
    _rootScrollView.delegate = self;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.userInteractionEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _userContentOffsetX = 0;
    [_rootScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    [self addSubview:_rootScrollView];
    
    _viewArray = [[NSMutableArray alloc] init];
    
    _isBuildUI = NO;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValues];
    }
    return self;
}

#pragma mark getter/setter

- (void)setRigthSideButton:(UIButton *)rigthSideButton
{
    UIButton *button = (UIButton *)[self viewWithTag:kTagOfRightSideButton];
    [button removeFromSuperview];
    rigthSideButton.tag = kTagOfRightSideButton;
    _rigthSideButton = rigthSideButton;
    [self addSubview:_rigthSideButton];
    
}

#pragma mark - 创建控件

//当横竖屏切换时可通过此方法调整布局

- (void)layoutSubviews
{
    //创建完子视图UI才需要调整布局
    if (_isBuildUI) {
        //如果有设置右侧视图，缩小顶部滚动视图的宽度以适应按钮
        if (self.rigthSideButton.bounds.size.width > 0) {
            _rigthSideButton.frame = CGRectMake(self.bounds.size.width - self.rigthSideButton.bounds.size.width, 0,
                                                _rigthSideButton.bounds.size.width, _topScrollView.bounds.size.height);
            
            _topScrollView.frame = CGRectMake(0, 0,
                                              self.bounds.size.width - self.rigthSideButton.bounds.size.width, kHeightOfTopScrollView);
        }
        
        //调整顶部滚动视图选中按钮位置
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        [self adjustScrollViewContentX:button];
    }
}

/*!
 * @method 创建子视图UI
 * @abstract
 * @discussion
 * @param 清空多余VC
 * @result
 */
- (void)buildUI:(BOOL)flash
{
    
    if (flash) {
        //--------移除多余视图
        for (int i = 2; i < _viewArray.count; i++) {
            [_viewArray removeLastObject];
        }
         [_topScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除头部
        _userSelectedChannelID = 100;//重置
        _userContentOffsetX = 0;//重置
    }

    NSUInteger number = [self.slideSwitchViewDelegate numberOfTab:self]; //标签的个数
    //更新主视图的总宽度
    _rootScrollView.contentSize = CGSizeMake(self.bounds.size.width * number, 0);
    //--------预加载2个视图
    
    for (int i=0; i<2; i++) {
        GKListViewController *vc = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:i];
        if (![_viewArray containsObject:vc]) {
             [vc viewWillCurrentView];
            vc.view.frame = CGRectMake(0+_rootScrollView.bounds.size.width*i, 0,
                                       _rootScrollView.bounds.size.width, _rootScrollView.bounds.size.height);
            [_viewArray addObject:vc];
            [_rootScrollView addSubview:vc.view];
        }
    }
    
    
    //--------创建头部视图
    [self createNameButtons];
    //--------滚动到第一个视图
    [_rootScrollView setContentOffset:CGPointMake((_userSelectedChannelID - 100)*self.bounds.size.width, 0) animated:NO];
    //选中第一个view
    if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
        [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
    }
    
    _isBuildUI = YES;
    
    //创建完子视图UI才需要调整布局
    [self setNeedsLayout];
}

/*!
 * @method 初始化顶部tab的各个按钮
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)createNameButtons
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    titleArray = [ud objectForKey:@"titleArray"]; //标题数组
    //-------切换的阴影背景
    _shadowImageView = [[UIImageView alloc] init];
    [_shadowImageView setImage:_shadowImage];
    [_topScrollView addSubview:_shadowImageView];
    
    //顶部tabbar的总长度
    CGFloat topScrollViewContentWidth = kWidthOfButtonMargin;
    //每个tab偏移量
    CGFloat xOffset = kWidthOfButtonMargin;
    for (int i = 0; i < [titleArray count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGSize textSize = [[((NSDictionary *)[titleArray objectAtIndex:i]) objectForKey:@"catname" ] sizeWithFont:[UIFont systemFontOfSize:kFontSizeOfTabButton]
                                    constrainedToSize:CGSizeMake(_topScrollView.bounds.size.width, kHeightOfTopScrollView)
                                        lineBreakMode:NSLineBreakByTruncatingTail];
        
        //累计每个tab文字的长度
        topScrollViewContentWidth += kWidthOfButtonMargin+textSize.width;
        //设置按钮尺寸
        [button setFrame:CGRectMake(xOffset,0,
                                    textSize.width, kHeightOfTopScrollView)];
        //计算下一个tab的x偏移量
        xOffset += textSize.width + kWidthOfButtonMargin;
        
        [button setTag:i+100];
        if (i == 0) {
            _shadowImageView.frame = CGRectMake(kWidthOfButtonMargin/2, 0, textSize.width+kWidthOfButtonMargin, _shadowImage.size.height-11);
            button.selected = YES;
        }
        [button setTitle:[((NSDictionary *)[titleArray objectAtIndex:i]) objectForKey:@"catname" ] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:kFontSizeOfTabButton];
        [button setTitleColor:self.tabItemNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.tabItemSelectedColor forState:UIControlStateSelected];
        [button setBackgroundImage:self.tabItemNormalBackgroundImage forState:UIControlStateNormal];
        [button setBackgroundImage:self.tabItemSelectedBackgroundImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:button];
    }
    //设置顶部滚动视图的内容总尺寸
    _topScrollView.contentSize = CGSizeMake(topScrollViewContentWidth, kHeightOfTopScrollView);
}

#pragma mark - 顶部滚动视图逻辑方法

/*!
 * @method 选中tab时间
 * @abstract
 * @discussion
 * @param 按钮
 * @result
 */
- (void)selectNameButton:(UIButton *)sender
{
    //如果点击的tab文字显示不全，调整滚动视图x坐标使用使tab文字显示全
    [self adjustScrollViewContentX:sender];
    //如果更换按钮
    if (sender.tag != _userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        lastButton.selected = NO;
        //赋值按钮ID
        _userSelectedChannelID = sender.tag;
    }
    [self addUIVC:_userSelectedChannelID - 100];
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            
            [_shadowImageView setFrame:CGRectMake(sender.frame.origin.x-kWidthOfButtonMargin/2, 0, sender.frame.size.width+kWidthOfButtonMargin, _shadowImage.size.height-11)];
            
            if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
                [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
            }
            
        } completion:^(BOOL finished) {
            if (finished) {
                //设置新页出现
                _isRootScroll = NO;
            }
        }];
      
        if (!_isRootScroll) {
            //--------这个用来更新视图数据 请注意了
           
            
            [_rootScrollView setContentOffset:CGPointMake((sender.tag - 100)*self.bounds.size.width, 0) animated:NO];
        }
    }
    //重复点击选中按钮
    else {
        
    }
}

/*!
 * @method 调整顶部滚动视图x位置
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)adjustScrollViewContentX:(UIButton *)sender
{
    //如果 当前显示的最后一个tab文字超出右边界
    
    //这里偏移了10 是因为 右边按钮变成了30
    if (sender.frame.origin.x - _topScrollView.contentOffset.x > self.bounds.size.width - (kWidthOfButtonMargin+10+sender.bounds.size.width)) {
        //向左滚动视图，显示完整tab文字
        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - (_topScrollView.bounds.size.width- (kWidthOfButtonMargin+sender.bounds.size.width)), 0)  animated:YES];
    }
    
    //如果 （tab的文字坐标 - 当前滚动视图左边界所在整个视图的x坐标） < 按钮的隔间 ，代表tab文字已超出边界
    if (sender.frame.origin.x - _topScrollView.contentOffset.x < kWidthOfButtonMargin) {
        //向右滚动视图（tab文字的x坐标 - 按钮间隔 = 新的滚动视图左边界在整个视图的x坐标），使文字显示完整
        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - kWidthOfButtonMargin, 0)  animated:YES];
    }
}

#pragma mark 主视图逻辑方法

//滚动视图开始时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        _userContentOffsetX = scrollView.contentOffset.x;
    }
}

//滚动视图正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        //判断用户是否左滚动还是右滚动
        if (_userContentOffsetX < scrollView.contentOffset.x) {
            _isLeftScroll = YES;
        }
        else {
            _isLeftScroll = NO;
        }
    }
}

//滚动视图结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        _isRootScroll = YES;
        //调整顶部滑条按钮状态
        int tag = (int)scrollView.contentOffset.x/self.bounds.size.width +100;
//        int titleIndex = tag - 100 ;
        //tag == 100 推荐
        
//        [self addUIVC:titleIndex];
        
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:tag];
        [self selectNameButton:button];
    }
}

-(void)addUIVC:(int)titleIndex
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *myViewDidLoadArr = [ud objectForKey:@"myViewDidLoad"];
    
    if (titleIndex >0 && titleIndex < titleArray.count) {
        if (titleIndex == titleArray.count-1) {
            
            NSString *str_pre = [((NSDictionary *)[titleArray objectAtIndex:titleIndex-1]) objectForKey:@"catname" ];;
            NSString *str = [((NSDictionary *)[titleArray objectAtIndex:titleIndex]) objectForKey:@"catname" ];
            
            if ((  ![myViewDidLoadArr containsObject:str] ||![myViewDidLoadArr containsObject:str_pre] ))
                {
                GKListViewController *vc2 = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:(titleIndex-1)];
                GKListViewController *vc0 = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:(titleIndex)];
                if (![_viewArray containsObject:vc2]) {
                    [vc2 viewWillCurrentView];
                    vc2.view.frame = CGRectMake(0+_rootScrollView.bounds.size.width*(titleIndex-1), 0,
                                                _rootScrollView.bounds.size.width, _rootScrollView.bounds.size.height);
                    [_viewArray addObject:vc2];
                    [_rootScrollView addSubview:vc2.view];
                }
                if (![_viewArray containsObject:vc0]) {
                    [vc0 viewWillCurrentView];
                    vc0.view.frame = CGRectMake(0+_rootScrollView.bounds.size.width*(titleIndex), 0,
                                                _rootScrollView.bounds.size.width, _rootScrollView.bounds.size.height);
                    [_viewArray addObject:vc0];
                    [_rootScrollView addSubview:vc0.view];
                }
                }
        } else {
            
            NSString *str_pre = [((NSDictionary *)[titleArray objectAtIndex:titleIndex-1]) objectForKey:@"catname" ];
            NSString *str = [((NSDictionary *)[titleArray objectAtIndex:titleIndex]) objectForKey:@"catname" ];
            NSString *str_next = [((NSDictionary *)[titleArray objectAtIndex:titleIndex+1]) objectForKey:@"catname" ];
            
            if ((  ![myViewDidLoadArr containsObject:str] || ![myViewDidLoadArr containsObject:str_next] ||![myViewDidLoadArr containsObject:str_pre] )) {
                
                GKListViewController *vc2 = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:(titleIndex-1)];
                GKListViewController *vc0 = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:(titleIndex)];
                GKListViewController *vc1 = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:(titleIndex+1)];
                
                if (![_viewArray containsObject:vc0]) {
                    [vc0 viewWillCurrentView];
                    vc0.view.frame = CGRectMake(0+_rootScrollView.bounds.size.width*(titleIndex), 0,
                                                _rootScrollView.bounds.size.width, _rootScrollView.bounds.size.height);
                    [_viewArray addObject:vc0];
                    [_rootScrollView addSubview:vc0.view];
                }
                if (![_viewArray containsObject:vc1]) {
                    [vc1 viewWillCurrentView];
                    vc1.view.frame = CGRectMake(0+_rootScrollView.bounds.size.width*(titleIndex+1), 0,
                                                _rootScrollView.bounds.size.width, _rootScrollView.bounds.size.height);
                    [_viewArray addObject:vc1];
                    [_rootScrollView addSubview:vc1.view];
                }
                if (![_viewArray containsObject:vc2]) {
                    [vc2 viewWillCurrentView];
                    vc2.view.frame = CGRectMake(0+_rootScrollView.bounds.size.width*(titleIndex-1), 0,
                                                _rootScrollView.bounds.size.width, _rootScrollView.bounds.size.height);
                    [_viewArray addObject:vc2];
                    [_rootScrollView addSubview:vc2.view];
                }
                
            }
        }
        
        
       
        
    }
}

//传递滑动事件给下一层
-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    //当滑道左边界时，传递滑动事件给代理
    if(_rootScrollView.contentOffset.x <= 0) {
        if (self.slideSwitchViewDelegate
            && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panLeftEdge:)]) {
            [self.slideSwitchViewDelegate slideSwitchView:self panLeftEdge:panParam];
        }
    } else if(_rootScrollView.contentOffset.x >= _rootScrollView.contentSize.width - _rootScrollView.bounds.size.width) {
        if (self.slideSwitchViewDelegate
            && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panRightEdge:)]) {
            [self.slideSwitchViewDelegate slideSwitchView:self panRightEdge:panParam];
        }
    }
}


@end
