//
//  CustomImageView.m
//  ScrollViewDemo
//
//  Created by 李伟超 on 14-9-24.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "CustomImageView.h"

@implementation CustomImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //设置当前视图支持触摸
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_delegate respondsToSelector:@selector(touchTheImageView:)]) {
        [_delegate touchTheImageView:self];
    }
}*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_delegate respondsToSelector:@selector(touchTheImageView:)]) {
        [_delegate touchTheImageView:self];
    }
}

@end
