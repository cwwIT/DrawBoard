//
//  UIView+Util.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-17.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SGMTDDrawUtil)

@property (nonatomic, assign) CGFloat SGMTD_x;
@property (nonatomic, assign) CGFloat SGMTD_y;
@property (nonatomic, assign, readonly) CGFloat SGMTD_top;
@property (nonatomic, assign, readonly) CGFloat SGMTD_bottom;
@property (nonatomic, assign, readonly) CGFloat SGMTD_right;
@property (nonatomic, assign, readonly) CGFloat SGMTD_left;
@property (nonatomic, assign) CGFloat SGMTD_centerX;
@property (nonatomic, assign) CGFloat SGMTD_centerY;
@property (nonatomic, assign) CGFloat SGMTD_width;
@property (nonatomic, assign) CGFloat SGMTD_height;
@property (nonatomic, assign) CGSize SGMTD_size;
@property (nonatomic, assign) CGPoint SGMTD_origin;

- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color;

- (UIImage *)convertViewToImage;

@end
