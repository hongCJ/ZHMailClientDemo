//
//  UIView+Frame.h
//  CoreMainDemo
//
//  Created by 郑红 on 14/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic,assign) CGFloat MS_X;
@property (nonatomic,assign) CGFloat MS_Y;
@property (nonatomic,assign) CGFloat MS_Witdh;
@property (nonatomic,assign) CGFloat MS_Height;
@property (nonatomic,assign) CGFloat MS_CenterX;
@property (nonatomic,assign) CGFloat MS_CenterY;

@property (nonatomic,assign,readonly) CGFloat MS_MaxY;
@property (nonatomic,assign,readonly) CGFloat MS_MinY;
@property (nonatomic,assign,readonly) CGFloat MS_MaxX;
@property (nonatomic,assign,readonly) CGFloat MS_MinX;

@property (nonatomic,assign) CGPoint MS_Orgin;
@property (nonatomic,assign) CGSize MS_Size;

@end
