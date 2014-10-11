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
    
    pageview = [[PageScrollView alloc] initWithFrame:CGRectMake(40, 40, 250, 400)];
    pageview.ImageArray = [NSMutableArray arrayWithObjects:@"0.png", @"1.png", @"2.png", @"3.png", @"4.png", nil];
    pageview.autoScrolled = YES;
    pageview.pageViewDelegate = self;
    pageview.Durations = 3.f;
    [self.view addSubview:pageview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectedImage:(CustomImageView *)imageView {
//    debug_NSLog(@"%@",imageView);
//    debug_NSLog(@"%d",imageView.tag);
//    [pageview startScrolling];
}

@end
