//
//  PageScrollView.h
//  ScrollViewDemo
//
//  Created by 李伟超 on 14-9-24.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"

@protocol pageScrollViewDelegate <NSObject>
@optional
- (void)didSelectedImage:(NSDictionary *)Info;
@end

@interface PageScrollView : UIView<CustomImageViewDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *myScrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic, assign) id<pageScrollViewDelegate> pageViewDelegate;
@property BOOL autoScrolled; // default NO. if YES, the ScrollView will automatic rolling.

@property (nonatomic, setter = setAllCycle:) BOOL allCycle; //default is YES.if NO, leftCycle and rightCycle are not work.
//@property BOOL leftCycle; //defualt is YES.
//@property BOOL rightCycle; //defualt is YES.

@property (nonatomic) NSUInteger Durations;//The rolling time interval. default is 2.f.
@property (nonatomic, retain) NSMutableArray *ImageArray; //the array include all image name.
@property (nonatomic) NSUInteger totalCount;
@property (nonatomic, retain) CustomImageView *selectImageView;
@property (nonatomic, assign) NSUInteger currentIndex;

- (void)setAllCycle:(BOOL)allCycle;
//- (void)setLeftCycle:(BOOL)leftCycle;
//- (void)setRightCycle:(BOOL)rightCycle;

- (void)stopScrolling;  //suspended rolling.
- (void)startScrolling; //restart rolling;

@end