//
//  LWCViewController.h
//  ScrollViewDemo
//
//  Created by 李伟超 on 14-9-23.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageScrollView.h"

@interface LWCViewController : UIViewController<pageScrollViewDelegate>

@property (retain, nonatomic) NSMutableArray *imageNameArray;

@end
