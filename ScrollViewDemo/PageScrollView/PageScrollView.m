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

#define VIEW_WITDTH self.frame.size.width
#define VIEW_HEIGHT self.frame.size.height

@implementation PageScrollView {
    NSInteger imageCount;
    NSTimer *timer;
    
    //设置是否可以进行动画， if is committing animation , canCommitanimation is NO.
    BOOL canCommitanimation;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _allCycle = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    debug_NSLog(@"draw");
    [[UIColor whiteColor] set];
    UIRectFill(rect);
    
    if (_autoScrolled) {
        if (!_Durations) {
            _Durations = 2.f;
        }
    }else {
        _Durations = 0;
    }
    
    if (_autoScrolled) {
        [self performSelector:@selector(setTimer) withObject:nil afterDelay:0];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    debug_NSLog(@"layout subviews");
//    self.backgroundColor = [UIColor whiteColor];
    
    imageCount = [_ImageArray count];
    _totalCount = imageCount + 2;
    
    //加入分页控件
    [self addPageControl];
    
    if (_myScrollView == nil) {
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WITDTH, VIEW_HEIGHT)];
        _myScrollView.showsHorizontalScrollIndicator = NO;
        _myScrollView.pagingEnabled = YES;
        _myScrollView.decelerationRate = 0.1f;
        _myScrollView.contentSize = CGSizeMake(VIEW_WITDTH * _totalCount, 0);
        
        _myScrollView.delegate = self;
        [self setContentOffsetToPage:_pageControl.currentPage animated:NO];
        [self insertSubview:_myScrollView belowSubview:_pageControl];
    }
}

- (void)addsubImageView {
//    for (CustomImageView *imageView in _myScrollView.subviews) {
//        if (imageView.tag >= _pageControl.currentPage && imageView.tag <= (_pageControl.currentPage + 2)) {
//            continue;
//        }else {
////            debug_NSLog(@"当前：%d   ----   clear第 %d 个图片",_pageControl.currentPage ,imageView.tag);
//            [imageView removeFromSuperview];
//        }
//    }

    
//    debug_NSLog(@"加载图片：%d",_pageControl.currentPage);
    for (int i = -1; i < 2; i++) {
        CGRect frame = _myScrollView.frame;
        frame.origin.x = VIEW_WITDTH * (_pageControl.currentPage + i + 1);
        frame.origin.y = 0;
        
        CustomImageView *imageView = [[CustomImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        imageView.tag = _pageControl.currentPage + i + 1;
        
        NSUInteger index = 0;
        
        if (_pageControl.currentPage == [_ImageArray count]-1 && i == 1) {
            //第一张图 放在最后面
            index = 0;
        }else if (_pageControl.currentPage == 0 && i == -1) {
            //最后一张图 添加到最前面
            index = imageCount - 1;
        }else {
            index = _pageControl.currentPage + i;
        }
        if (imageView.image == nil) {
            imageView.image = [UIImage imageNamed:_ImageArray[index]];

//           #warning -  一定要记得 remove掉 imageview
//            imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_ImageArray[index] ofType:nil]];
        }else {
            continue;
        }
        [_myScrollView addSubview:imageView];
    }
    
 /*
//    for (int i = 0; i < _totalCount; i++) {
//        CGRect frame = CGRectMake(0, 0, VIEW_WITDTH, VIEW_HEIGHT);
//        frame.origin.x = VIEW_WITDTH * i;
//        frame.origin.y = 0;
//        
//        CustomImageView *imageView = [[CustomImageView alloc] initWithFrame:frame];
//        imageView.delegate = self;
//        [_myScrollView addSubview:imageView];
//        
//        if (i == 0) {
//            //把最后一张图片放在最前面
//            imageView.tag = _totalCount - 2;
//            imageView.image = [UIImage imageNamed:[_ImageArray lastObject]];
//        }else if (i != _totalCount - 1) {
//            imageView.tag = i;
//            imageView.image = [UIImage imageNamed:_ImageArray[i-1]];
//        }else {
//            //把第一张图片放在最后面
//            imageView.tag = 1;
//            imageView.image = [UIImage imageNamed:_ImageArray[0]];
//        }
//    }
  */
}

- (void)addPageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.frame = CGRectMake((VIEW_WITDTH - 17*imageCount)/2, VIEW_HEIGHT - 40, 17*imageCount, 20);//指定位置大小
        _pageControl.numberOfPages = imageCount;//指定页面个数
        _pageControl.currentPage = 0;//指定pagecontroll的值
        [_pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        //添加委托方法，当点击小白点就执行此方法
        [self insertSubview:_pageControl atIndex:0];
    }
}

- (void)changePage:(id)sender {
    UIPageControl *pageC = (UIPageControl *)sender;
    debug_NSLog(@"%d",pageC.currentPage);
    [self setContentOffsetToPage:pageC.currentPage animated:NO];
}

#pragma mark - timer

//设置定时器
- (void)setTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:_Durations target:self selector:@selector(changeTheImage) userInfo:nil repeats:YES];
}

- (void)changeTheImage {
    if (_myScrollView.contentOffset.x == VIEW_WITDTH * (_totalCount - 1)) {
        //重新回到第一张
        [self setContentOffsetToPage:0 animated:NO];
    }
    
    [_myScrollView setUserInteractionEnabled:NO];
    
    if (_pageControl.currentPage == imageCount - 1) {
        [self setContentOffsetToPage:_pageControl.currentPage + 1 animated:YES];
    }else {
        _pageControl.currentPage += 1;
        [self setContentOffsetToPage:_pageControl.currentPage animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    debug_NSLog(@"begin dragging");
    [self stopScrolling];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    debug_NSLog(@"end scroll:  %f",scrollView.contentOffset.x);
    if (!scrollView.decelerating) {
        [_myScrollView setUserInteractionEnabled:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        _pageControl.currentPage = scrollView.contentOffset.x / VIEW_WITDTH;
        [self addsubImageView];
    }
}

//减速滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    debug_NSLog(@"end decelerate:%f",scrollView.contentOffset.x);
    _pageControl.currentPage = scrollView.contentOffset.x / VIEW_WITDTH - 1;
    
//    [self addsubImageView];
    
    if (scrollView.contentOffset.x >= VIEW_WITDTH * (_totalCount - 1)) {
        //重新 回到第一张
        _pageControl.currentPage = 0;
        [self setContentOffsetToPage:_pageControl.currentPage animated:NO];
    }
    if (scrollView.contentOffset.x <= 0) {
        //回到 最后一张
        _pageControl.currentPage = imageCount - 1;
        [self setContentOffsetToPage:_pageControl.currentPage animated:NO];
    }
    
    [_myScrollView setUserInteractionEnabled:YES];
    [self startScrolling];
}

#pragma mark - CustomImageView

- (void)touchTheImageView:(CustomImageView *)imageView {
    _selectImageView = imageView;
    //为了防止touch事件和 gesture 事件冲突
    if (_myScrollView.isDragging || _myScrollView.isDecelerating) {
        //如果scrollview被拖动，则不执行touch事件
        return;
    }
    
    if ([_pageViewDelegate respondsToSelector:@selector(didSelectedImage:)]) {
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_selectImageView.image, @"image", [NSNumber numberWithInteger:_pageControl.currentPage], @"currentpage", nil];
        [_pageViewDelegate didSelectedImage:info];
    }
}

#pragma mark - custom method

- (void)setAllCycle:(BOOL)allCycle {
    _allCycle = allCycle;
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
    index += 1;
    CGPoint point;
    point.x = VIEW_WITDTH * index;
    if (point.x == VIEW_WITDTH * (_totalCount - 1)) {
        _pageControl.currentPage = 0;
    }
    if (point.x == 0) {
        _pageControl.currentPage = imageCount - 1;
    }
    [_myScrollView setContentOffset:point animated:animated];
    
    [self addsubImageView];
}

@end
