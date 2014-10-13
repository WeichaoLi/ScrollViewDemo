//
//  LWCViewController.m
//  ScrollViewDemo
//
//  Created by 李伟超 on 14-9-23.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "LWCViewController.h"
#import "PageScrollView.h"
#import "Debug.h"

@implementation LWCViewController{
    PageScrollView *pageview;
    UIImageView *checkImage;
    
    BOOL canCommitAnimation;
}

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
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    pageview = [[PageScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, 200)];
    pageview.ImageArray = [NSMutableArray arrayWithObjects:@"0.png", @"1.png", @"2.png", @"3.png", @"4.png", nil];
    pageview.autoScrolled = YES;
    pageview.pageViewDelegate = self;
    pageview.Durations = 2.f;
    [self.view addSubview:pageview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectedImage:(NSDictionary *)Info {
//    [pageview setUserInteractionEnabled:NO];
//    [pageview stopScrolling];
    
    [self showTheImageView:[Info objectForKey:@"image"]];
    
    debug_NSLog(@"当前页：%@",[Info objectForKey:@"currentpage"]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (canCommitAnimation) {
        [self hiddenTheImageview];
    }
    
//    debug_NSLog(@"%@",self.view.subviews);
}

#pragma mark -

- (void)hiddenTheImageview {
    [UIView animateWithDuration:0.5f animations:^() {
        canCommitAnimation = NO;
        checkImage.frame = pageview.frame;
        
    }completion:^(BOOL finished){
        canCommitAnimation = YES;
        
        [checkImage removeFromSuperview];
        checkImage = nil;
        
        [pageview setUserInteractionEnabled:YES];
        [pageview startScrolling];
    }];
}

- (void)showTheImageView:(UIImage *)image {
    if (checkImage == nil) {
        checkImage = [[UIImageView alloc] initWithFrame:pageview.frame];
        [self.view addSubview:checkImage];
    }
    checkImage.image = image;
    
    [UIView animateWithDuration:0.8f animations:^() {
        canCommitAnimation = NO;
        
        [pageview setUserInteractionEnabled:NO];
        [pageview stopScrolling];
        
        CGRect frame = pageview.frame;
        frame.origin.y = 240;
        checkImage.frame = frame;
    }completion:^(BOOL finished){
        
            canCommitAnimation = YES;
    }];
}

@end
