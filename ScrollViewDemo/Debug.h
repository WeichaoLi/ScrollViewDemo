//
//  Debug.h
//  ScrollViewDemo
//
//  Created by 李伟超 on 14-10-10.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#ifdef DEBUG
#define debug_NSLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define debug_NSLog(format, ...)
#endif