//
//  PageScrollView.m
//  ScrollViewDemo
//
//  Created by 李伟超 on 14-9-24.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "PageScrollView.h"
#import "CustomImageView.h"
#import "Debug.h"

@implementation PageScrollView {
    NSTimer *timer;
    UIPageControl *pageControl;
    //设置是否可以进行动画， if is committing animation , canCommitanimation is NO.
    BOOL canCommitanimation;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _allCycle = YES;
        _leftCycle = YES;
        _rightCycle = YES;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    debug_NSLog(@"draw");
//    [[UIColor redColor] set];
//    UIRectFill(rect);
    
    if (_autoScrolled) {
        if (!_Durations) {
            _Durations = 2.f;
        }
    }
    
    [self performSelector:@selector(setTimer) withObject:nil afterDelay:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    debug_NSLog(@"layout subviews");
    self.backgroundColor = [UIColor whiteColor];
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _myScrollView.bounces = NO;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.pagingEnabled = YES;
    _myScrollView.contentSize = CGSizeMake(([_ImageArray count] + 1)*_myScrollView.frame.size.width, 0);
    
    _myScrollView.delegate = self;
    [self addsubImageView];
    [self addSubview:_myScrollView];
    
    [self addPageControl];
}

- (void)addsubImageView {
    for (int i = 0; i <= [_ImageArray count]; i++) {
        CGRect frame = _myScrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        
        CustomImageView *imageView = [[CustomImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        
        [_myScrollView addSubview:imageView];
        
        if (i != [_ImageArray count]) {
            imageView.tag = i;
            imageView.image = [UIImage imageNamed:_ImageArray[i]];
        }else {
            imageView.tag = 1;
            imageView.image = [UIImage imageNamed:_ImageArray[0]];
        }
    }
}

- (void)addPageControl {
    pageControl = [[UIPageControl alloc] init];
    pageControl.backgroundColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.frame = CGRectMake(90, 350, 70, 20);//指定位置大小
    pageControl.numberOfPages = [_ImageArray count];//指定页面个数
    pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    //添加委托方法，当点击小白点就执行此方法
    [self addSubview:pageControl];
}

- (void)changePage:(id)sender {
    NSLog(@"kkkkkkkkk");
}

#pragma mark - timer

//设置定时器
- (void)setTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:_Durations target:self selector:@selector(changeTheImage) userInfo:nil repeats:YES];
}

- (void)changeTheImage {
    if (_myScrollView.contentOffset.x == (_myScrollView.frame.size.width * [_ImageArray count])) {
        //重新回到第一张
        [self setContentOffsetToPage:0 animated:NO];
    }
    [_myScrollView setUserInteractionEnabled:NO];
    if (pageControl.currentPage == [_ImageArray count] - 1) {
        [self setContentOffsetToPage:pageControl.currentPage + 1 animated:YES];
    }else {
        pageControl.currentPage += 1;
        [self setContentOffsetToPage:pageControl.currentPage animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    debug_NSLog(@"begin dragging");
    [self stopScrolling];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isTracking) {
        pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    debug_NSLog(@"end scroll:  %f",scrollView.contentOffset.x);
    if (!scrollView.decelerating) {
        [_myScrollView setUserInteractionEnabled:YES];
    }
}

//减速滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    debug_NSLog(@"end decelerate:%f",scrollView.contentOffset.x);
    pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    if (scrollView.contentOffset.x == (scrollView.frame.size.width * [_ImageArray count])) {
        //重新回到第一张
        pageControl.currentPage = 0;
        [self setContentOffsetToPage:0 animated:NO];
    }
    [_myScrollView setUserInteractionEnabled:YES];
    [self startScrolling];
}

#pragma mark - CustomImageView

- (void)touchTheImageView:(CustomImageView *)imageView {
    
//    if (fmodf(_myScrollView.contentOffset.x, _myScrollView.frame.size.width) != 0.0) {
//        _myScrollView.canCancelContentTouches = YES;
//    }
    _selectImageView = imageView;
    //为了防止touch事件和 gesture 事件冲突
    if (_myScrollView.isDragging || _myScrollView.isDecelerating) {
        //如果scrollview被拖动，则不执行touch事件
        return;
    }
    
    if ([_pageViewDelegate respondsToSelector:@selector(didSelectedImage:)]) {
        [_pageViewDelegate didSelectedImage:_selectImageView];
    }
}

#pragma mark - custom method

- (void)setAllCycle:(BOOL)allCycle {
    _allCycle = allCycle;
    if (!allCycle) {
        _leftCycle = NO;
        _rightCycle = NO;
    }
}

- (void)startScrolling {
    //开启定时器，并定制开启定时器的时间
    [timer setFireDate:[[NSDate date] dateByAddingTimeInterval:_Durations]];
}

- (void)stopScrolling {
    [timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - content offset

- (void)setContentOffsetToPage:(NSUInteger)index animated:(BOOL)animated{
    CGPoint point;
    point.x = _myScrollView.frame.size.width * index;
    if (point.x == (_myScrollView.frame.size.width * [_ImageArray count])) {
        pageControl.currentPage = 0;
    }
    [_myScrollView setContentOffset:point animated:animated];
}

@end
