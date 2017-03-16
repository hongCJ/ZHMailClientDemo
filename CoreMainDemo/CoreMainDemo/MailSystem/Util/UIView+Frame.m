//
//  UIView+Frame.m
//  CoreMainDemo
//
//  Created by 郑红 on 14/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)


#pragma mark - OrginX
- (void)setMS_X:(CGFloat)MS_X {
    self.frame = CGRectMake(MS_X, self.MS_Y,self.MS_Witdh, self.MS_Height);
}

- (CGFloat)MS_X {
    return self.frame.origin.x;
}

#pragma mark - OrginY

- (void)setMS_Y:(CGFloat)MS_Y {
    self.frame = CGRectMake(self.MS_X, MS_Y,self.MS_Witdh, self.MS_Height);
}

- (CGFloat)MS_Y {
    return self.frame.origin.y;
}

#pragma mark - Width
- (void)setMS_Witdh:(CGFloat)MS_Witdh {
    self.frame = CGRectMake(self.MS_X, self.MS_Y,MS_Witdh, self.MS_Height);
}

- (CGFloat)MS_Witdh {
    return self.frame.size.width;
}
#pragma mark - Height
- (void)setMS_Height:(CGFloat)MS_Height {
    self.frame = CGRectMake(self.MS_X, self.MS_Y,self.MS_Witdh, MS_Height);
}

- (CGFloat)MS_Height {
    return self.frame.size.height;
}

#pragma mark - CenterX
- (void)setMS_CenterX:(CGFloat)MS_CenterX {
    self.center = CGPointMake(MS_CenterX, self.MS_CenterY);
}

- (CGFloat)MS_CenterX {
    return self.center.x;
}

#pragma mark - CenterY
- (void)setMS_CenterY:(CGFloat)MS_CenterY {
    self.center = CGPointMake(self.MS_CenterX, MS_CenterY);
}

- (CGFloat)MS_CenterY {
    return self.center.y;
}

#pragma mark - MaxY and MinY
- (CGFloat)MS_MaxY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)MS_MinY {
    return CGRectGetMinY(self.frame);
}

#pragma mark - MaxX and MinX

- (CGFloat)MS_MaxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)MS_MinX {
    return CGRectGetMinX(self.frame);
}
#pragma mark - Orgin

- (void)setMS_Orgin:(CGPoint)MS_Orgin {
    self.frame = CGRectMake(MS_Orgin.x, MS_Orgin.y, self.MS_Witdh, self.MS_Height);
}

- (CGPoint)MS_Orgin {
    return self.frame.origin;
}

#pragma mark - Size

- (CGSize)MS_Size {
    return self.frame.size;
}

- (void)setMS_Size:(CGSize)MS_Size {
    self.bounds = CGRectMake(0, 0, MS_Size.width, MS_Size.height);
}


@end
