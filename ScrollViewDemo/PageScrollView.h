//
//  PageScrollView.h
//  ScrollViewDemo
//
//  Created by 李伟超 on 14-9-24.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"

@protocol pageScrollViewDelegate;

@interface PageScrollView : UIView<CustomImageViewDelegate, UIScrollViewDelegate> {
    UIScrollView *_myScrollView;
}

//是否自动滚动
@property BOOL autoScrolled;
//滚动的间隔时间
@property (nonatomic) NSUInteger Durations;

@property (nonatomic, retain) NSMutableArray *ImageArray;

@property (nonatomic, retain) CustomImageView *selectImageView;
@property (nonatomic, assign) NSUInteger selectIndex;

@end

@protocol pageScrollViewDelegate <NSObject>

@required

@optional

@end
