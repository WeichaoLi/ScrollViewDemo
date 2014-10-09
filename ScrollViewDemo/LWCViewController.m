//
//  LWCViewController.m
//  ScrollViewDemo
//
//  Created by 李伟超 on 14-9-23.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "LWCViewController.h"
#import "CustomImageView.h"
#import "PageScrollView.h"

@interface LWCViewController ()<CustomImageViewDelegate> {
    UIImageView *checkImageView;
    NSTimer *timer;
    
    //设置是否可以进行动画， if is committing animation , canCommitanimation is NO.
    BOOL canCommitanimation;
}

@end

@implementation LWCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    _imageNameArray = [NSMutableArray arrayWithObjects:@"1.png", @"2.png", @"3.png", @"4.png", nil];
    
    _myScrollView.contentSize = CGSizeMake(([_imageNameArray count] + 1)*_myScrollView.frame.size.width, 0);
    _myScrollView.bounces = NO; //不允许 弹动
    _myScrollView.decelerationRate = 0.1f;
    
//    [_myScrollView setUserInteractionEnabled:NO];  //不允许手势交互
    
    _myScrollView.delegate = self;
    
    //是否分页，如果YES，decelerate将在最近的subview那里滚动到最近的边界上停止滚动
    _myScrollView.pagingEnabled = YES;
    
    for (int i = 0; i <= [_imageNameArray count]; i++) {
        CGRect frame = _myScrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;

        CustomImageView *imageView = [[CustomImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        
        [_myScrollView addSubview:imageView];
        if (i != [_imageNameArray count]) {
            imageView.image = [UIImage imageNamed:_imageNameArray[i]];
//            if (i == 0) {
//                imageView.image = [UIImage imageNamed:_imageNameArray[i]];
//            }
            imageView.tag = i;
        }else {
            imageView.image = [UIImage imageNamed:_imageNameArray[0]];
            imageView.tag = 0;
        }
    }
    
    [self performSelector:@selector(setTimer) withObject:nil afterDelay:0];
    
    PageScrollView *pageview = [[PageScrollView alloc] initWithFrame:CGRectMake(40, 350, 200, 200)];
    pageview.ImageArray = _imageNameArray;
    [self.view addSubview:pageview];
}

//设置定时器
- (void)setTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(changeTheImage) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)changeTheImage {
    CGPoint point = _myScrollView.contentOffset;
    point.x += _myScrollView.frame.size.width;
    [_myScrollView setContentOffset:point animated:YES];
    if (_myScrollView.contentOffset.x == (_myScrollView.frame.size.width * [_imageNameArray count])) {
        //重新回到第一张
        [_myScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [timer setFireDate:[NSDate distantPast]];
}

//惯性滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"%f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x == (scrollView.frame.size.width * [_imageNameArray count])) {
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
    [self.view insertSubview:checkImageView aboveSubview:_myScrollView];

    [UIView animateWithDuration:0.8f animations:^(){
        canCommitanimation = NO;
        checkImageView.frame = self.view.frame;
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
