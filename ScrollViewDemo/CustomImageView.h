//
//  CustomImageView.h
//  ScrollViewDemo
//
//  Created by 李伟超 on 14-9-24.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomImageViewDelegate;

@interface CustomImageView : UIImageView

@property (assign, nonatomic) id<CustomImageViewDelegate> delegate;

@end

@protocol CustomImageViewDelegate <NSObject>

@optional

- (void)touchTheImageView:(CustomImageView *)imageView;

@end
