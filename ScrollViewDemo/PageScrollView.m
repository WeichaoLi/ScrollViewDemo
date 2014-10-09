//
//  PageScrollView.m
//  ScrollViewDemo
//
//  Created by 李伟超 on 14-9-24.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "PageScrollView.h"
#import "CustomImageView.h"

@implementation PageScrollView {
    UIImageView *checkImageView;
    NSTimer *timer;
    
    //设置是否可以进行动画， if is committing animation , canCommitanimation is NO.
    BOOL canCommitanimation;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    NSLog(@"draw");
//    [[UIColor redColor] set];
//    UIRectFill(rect);
    
    [self performSelector:@selector(setTimer) withObject:nil afterDelay:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"layout subviews");
    self.backgroundColor = [UIColor whiteColor];
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _myScrollView.bounces = NO;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.pagingEnabled = YES;
//    _myScrollView.decelerationRate = 4.f;
    _myScrollView.contentSize = CGSizeMake(([_ImageArray count] + 1)*_myScrollView.frame.size.width, 0);

    _myScrollView.delegate = self;
    for (int i = 0; i <= [_ImageArray count]; i++) {
        CGRect frame = _myScrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        
        CustomImageView *imageView = [[CustomImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        
        [_myScrollView addSubview:imageView];
        if (i != [_ImageArray count]) {
            imageView.image = [UIImage imageNamed:_ImageArray[i]];
            //            if (i == 0) {
            //                imageView.image = [UIImage imageNamed:_imageNameArray[i]];
            //            }
            imageView.tag = i;
        }else {
            imageView.image = [UIImage imageNamed:_ImageArray[0]];
            imageView.tag = 0;
        }
    }
    [self addSubview:_myScrollView];
}

//设置定时器
- (void)setTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(changeTheImage) userInfo:nil repeats:YES];
}

- (void)changeTheImage {
    CGPoint point = _myScrollView.contentOffset;
    point.x += _myScrollView.frame.size.width;
    [_myScrollView setContentOffset:point animated:YES];
    if (_myScrollView.contentOffset.x == (_myScrollView.frame.size.width * [_ImageArray count])) {
        //重新回到第一张
        [_myScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [timer setFireDate:[NSDate distantPast]];
}

//惯性滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    NSLog(@"%f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x == (scrollView.frame.size.width * [_ImageArray count])) {
        //重新回到第一张
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    
    //开启定时器，并定制开启定时器的时间
    [timer setFireDate:[[NSDate date] dateByAddingTimeInterval:2.f]];
}

#pragma mark - CustomImageView

- (void)touchTheImageView:(CustomImageView *)imageView {
    //为了防止touch事件和 gesture 事件冲突
    if (_myScrollView.isDragging) {
        //如果scrollview被拖动，则不执行touch事件
        return;
    }
    [timer setFireDate:[NSDate distantFuture]];
    [_myScrollView setUserInteractionEnabled:NO]; //不能手势交互
    
    [checkImageView removeFromSuperview];
    checkImageView = [[UIImageView alloc] initWithFrame:_myScrollView.frame];
    checkImageView.image = imageView.image;
    [self insertSubview:checkImageView aboveSubview:_myScrollView];
    
    [UIView animateWithDuration:0.8f animations:^(){
        canCommitanimation = NO;
        checkImageView.frame = self.frame;
    }completion:^(BOOL finished){
        canCommitanimation = YES;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!canCommitanimation) {
        return;
    }
    [UIView animateWithDuration:0.5f animations:^(){
        canCommitanimation = NO;
        checkImageView.frame = _myScrollView.frame;
    }completion:^(BOOL finished){
        [checkImageView removeFromSuperview];
        [_myScrollView setUserInteractionEnabled:YES];
    }];
    
    //开启定时器，并定制开启定时器的时间
    [timer setFireDate:[[NSDate date] dateByAddingTimeInterval:2.f]];
}
@end
