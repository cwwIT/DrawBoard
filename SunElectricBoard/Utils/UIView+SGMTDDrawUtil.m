//
//  UIView+Util.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-17.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "UIView+SGMTDDrawUtil.h"

@implementation UIView (SGMTDDrawUtil)

- (void)setSGMTD_x:(CGFloat)SGMTD_x
{
    CGRect frame = self.frame;
    frame.origin.x = SGMTD_x;
    self.frame = frame;
}

- (void)setSGMTD_y:(CGFloat)SGMTD_y
{
    CGRect frame = self.frame;
    frame.origin.y = SGMTD_y;
    self.frame = frame;
}

- (CGFloat)SGMTD_x
{
    return self.frame.origin.x;
}

- (CGFloat)SGMTD_y
{
    return self.frame.origin.y;
}

- (CGFloat)SGMTD_top
{
    return self.frame.origin.x;
}

- (CGFloat)SGMTD_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)SGMTD_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)SGMTD_left
{
    return self.frame.origin.x;
}


- (void)setSGMTD_centerX:(CGFloat)SGMTD_centerX
{
    CGPoint center = self.center;
    center.x = SGMTD_centerX;
    self.center = center;
}

- (CGFloat)SGMTD_centerX
{
    return self.center.x;
}

- (void)setSGMTD_centerY:(CGFloat)SGMTD_centerY
{
    CGPoint center = self.center;
    center.y = SGMTD_centerY;
    self.center = center;
}

- (CGFloat)SGMTD_centerY
{
    return self.center.y;
}

- (void)setSGMTD_width:(CGFloat)SGMTD_width
{
    CGRect frame = self.frame;
    frame.size.width = SGMTD_width;
    self.frame = frame;
}

- (void)setSGMTD_height:(CGFloat)SGMTD_height
{
    CGRect frame = self.frame;
    frame.size.height = SGMTD_height;
    self.frame = frame;
}

- (CGFloat)SGMTD_height
{
    return self.frame.size.height;
}

- (CGFloat)SGMTD_width
{
    return self.frame.size.width;
}

- (void)setSGMTD_size:(CGSize)SGMTD_size
{
    CGRect frame = self.frame;
    frame.size = SGMTD_size;
    self.frame = frame;
}

- (CGSize)SGMTD_size
{
    return self.frame.size;
}

- (void)setSGMTD_origin:(CGPoint)SGMTD_origin
{
    CGRect frame = self.frame;
    frame.origin = SGMTD_origin;
    self.frame = frame;
}

- (CGPoint)SGMTD_origin
{
    return self.frame.origin;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}

@end
