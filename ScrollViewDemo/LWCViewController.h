//
//  LWCViewController.h
//  ScrollViewDemo
//
//  Created by 李伟超 on 14-9-23.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWCViewController : UIViewController<UIScrollViewDelegate>

@property (retain, nonatomic) NSMutableArray *imageNameArray;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@end
