//
//  SGDrawItemLayer.m
//  SunElectricBoard
//
//  Created by sungrow on 2019/9/7.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGMTDDrawItemLayer.h"

@implementation SGMTDDrawItemLayer

- (instancetype)init {
    if (self = [super init]) {
        [self configData];
    }
    return self;
}

- (void)configData {
    
    self.levelsOfDetail = 1;
    self.levelsOfDetailBias = 4;
    self.tileSize = CGSizeMake(256, 256);
}
//取消动画效果/设置动画时间。默认0.25秒。
+(CFTimeInterval)fadeDuration{
    return 0.0f;
}

- (void)reDraw {
    
    [self setNeedsDisplay];
}

- (void)setItemModel:(SGMTDDrawItemModel *)itemModel {
    
    _itemModel = itemModel;
    [self reDraw];
}

- (void)drawInContext:(CGContextRef)ctx{
    
    [super drawInContext:ctx];
    if (self.itemModel.isHidden) { return; }
    //    开始画layer 层
    if (_itemModel.kindType == ItemTypeFourG) {
        
        [self draw4GByContext:ctx];
        
    }else if (_itemModel.kindType == ItemTypeLogger){
        
        [self drawLoggerByContext:ctx];
        
    }else if (_itemModel.kindType == ItemTypeOneTwo || _itemModel.kindType == ItemTypeOneEight || _itemModel.kindType == ItemTypeIntellect){
        
        [self drawIntellectByContext:ctx];
        
    }else if (_itemModel.kindType == ItemTypeInverter){
        
        [self drawInverterContext:ctx];
        
    }else if (_itemModel.kindType == ItemTypeTurnOffController){
        
        [self drawTurnOffControllerByContext:ctx];
        
    }
    
    
}

#pragma mark layer 层绘制 优化
//1.使用calayer(硬件加速 绘制) 和 UIBezierPath 配合，不使用 CGGrophics（CPU绘制）的方法 见《核心动画高级技巧》115页
//2.使用appendPath 追加路径 例如 [fourG_Path0 appendPath:fourG_Path1]; 少创建层，只追加路径。
//3.优化路径末尾和结合处连接方式 .lineJoinStyle/.lineCapStyle;
//4.避免频繁调用  UIGraphicsPopContext();  UIGraphicsPushContext(ctx);
//画4G
-(void)draw4GByContext:(CGContextRef)ctx{
    
    CGFloat lineWidth = 2.0 / [UIScreen mainScreen].scale;
    UIBezierPath *fourG_Path0 = [self createPath];
    UIBezierPath *fourG_Path1 = [self createPath];
    UIBezierPath *fourG_Path2 = [self createPath];
    UIBezierPath *fourG_Path3 = [self createPath];
    CAShapeLayer *layer = [self createLayer];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGPoint centPoint = CGPointMake(w-1.0, h-1.0);
    
    CGFloat sapce = (kSGMTDItemWidth-4.0)/3.0;
    CGFloat radius3 = kSGMTDItemWidth-2.0;
    CGFloat radius2 = kSGMTDItemWidth-sapce;
    CGFloat radius1 = kSGMTDItemWidth-2*sapce;
    CGFloat radius0 = 2.0;
    
    fourG_Path3 = [UIBezierPath bezierPathWithArcCenter:centPoint radius:radius3 startAngle:M_PI_2*2 endAngle:M_PI_2*3 clockwise:YES];
    fourG_Path2 = [UIBezierPath bezierPathWithArcCenter:centPoint radius:radius2 startAngle:M_PI_2*2 endAngle:M_PI_2*3 clockwise:YES];
    fourG_Path1 = [UIBezierPath bezierPathWithArcCenter:centPoint radius:radius1 startAngle:M_PI_2*2 endAngle:M_PI_2*3 clockwise:YES];
    fourG_Path0 = [UIBezierPath bezierPathWithArcCenter:centPoint radius:radius0 startAngle:M_PI_2*2 endAngle:M_PI_2*3 clockwise:YES];
    
    
    [fourG_Path0 appendPath:fourG_Path1];
    [fourG_Path0 appendPath:fourG_Path2];
    [fourG_Path0 appendPath:fourG_Path3];
    layer.lineWidth = lineWidth;
    //
    layer.strokeColor = kSGMTDBlueColor.CGColor;
    layer.path = fourG_Path0.CGPath;
    [self addSublayer:layer];
    
    [fourG_Path3 closePath];
    [fourG_Path3 removeAllPoints];
    [fourG_Path2 closePath];
    [fourG_Path2 removeAllPoints];
    [fourG_Path1 closePath];
    [fourG_Path1 removeAllPoints];
    [fourG_Path0 closePath];
    [fourG_Path0 removeAllPoints];
    layer = nil;
    
    self.backgroundColor = kSGMTDLightGrayColor.CGColor;
    self.cornerRadius = 3;
    
}

//画logger
-(void)drawLoggerByContext:(CGContextRef)ctx{
    
    CGFloat lineWidth = 2.0 / [UIScreen mainScreen].scale;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat outEdge = 2.0f;
    CGPoint outP0 = CGPointMake(outEdge, outEdge);
    CGPoint outP1 = CGPointMake(width-outEdge, outEdge);
    CGPoint outP2 = CGPointMake(width-outEdge, height-outEdge);
    CGPoint outP3 = CGPointMake(outEdge, height-outEdge);
    
    CGFloat inEdge = 6.0f;
    CGPoint inP0 = CGPointMake(inEdge, inEdge);
    CGPoint inP1 = CGPointMake(width-inEdge, inEdge);
    CGPoint inP2 = CGPointMake(width-inEdge, height-inEdge);
    CGPoint inP3 = CGPointMake(inEdge, height-inEdge);
    
    UIBezierPath *path = [self createPath];
    CAShapeLayer *layer = [self createLayer];
    //        画外环
    [path moveToPoint:outP0];
    [path addLineToPoint:outP1];
    [path addLineToPoint:outP2];
    [path addLineToPoint:outP3];
    [path addLineToPoint:outP0];
    //        画内环
    [path moveToPoint:inP0];
    [path addLineToPoint:inP1];
    [path addLineToPoint:inP2];
    [path addLineToPoint:inP3];
    [path addLineToPoint:inP0];
    
    path.lineWidth = lineWidth;
    layer.path = path.CGPath;
    layer.strokeColor = kSGMTDBlueColor.CGColor;
    [self addSublayer:layer];
    
    [path closePath];
    [path removeAllPoints];
    layer = nil;
    
    self.backgroundColor = kSGMTDLightGrayColor.CGColor;
    self.cornerRadius = 3;
    
}

//画逆变器
-(void)drawInverterContext:(CGContextRef)ctx{
    
    UIBezierPath *inverter_Path = [self createPath];
    CAShapeLayer *layer = [self createLayer];
    layer.lineWidth = 1.0 / [UIScreen mainScreen].scale;
    
    CGFloat outSpace = 0.0;
    CGFloat inSpace = 2.0;
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGPoint point1 = CGPointMake(outSpace, outSpace);
    CGPoint point2 = CGPointMake(w-outSpace, outSpace);
    CGPoint point3 = CGPointMake(w-outSpace, h-outSpace);
    CGPoint point4 = CGPointMake(outSpace, h-outSpace);
    CGPoint point0 = CGPointMake(outSpace, outSpace);
    //
    [inverter_Path moveToPoint:point1];
    [inverter_Path addLineToPoint:point2];
    [inverter_Path addLineToPoint:point3];
    [inverter_Path addLineToPoint:point4];
    [inverter_Path addLineToPoint:point0];
    //
    CGPoint point5 = CGPointMake(w-inSpace, inSpace);
    CGPoint point6 = CGPointMake(inSpace, h-inSpace);
    [inverter_Path moveToPoint:point5];
    [inverter_Path addLineToPoint:point6];
    //
    CGFloat control1 = (w/8.0+inSpace);
    CGFloat control2 = (w*3/8.0-inSpace);
    CGPoint point7 = CGPointMake(outSpace+1.0, outSpace+6.0);
    CGPoint point8 = CGPointMake(w/2.0-2, outSpace+6.0);
    CGPoint point9 = CGPointMake(control1, outSpace+3.0);
    CGPoint point10 = CGPointMake(control2, outSpace+9.0);
    [inverter_Path moveToPoint:point7];
    [inverter_Path addCurveToPoint:point8 controlPoint1:point9 controlPoint2:point10];
    //
    CGFloat control3 = w/2.0+control1;
    CGFloat control4 = w/2.0+control2;
    CGPoint point11 = CGPointMake(w/2.0+1.0, outSpace+8.0+h/2.0);
    CGPoint point12 = CGPointMake(w-2.0, outSpace+8.0+h/2.0);
    CGPoint point13 = CGPointMake(control3, outSpace+5.0+h/2.0);
    CGPoint point14 = CGPointMake(control4, outSpace+11.0+h/2.0);
    [inverter_Path moveToPoint:point11];
    [inverter_Path addCurveToPoint:point12 controlPoint1:point13 controlPoint2:point14];
    
    layer.strokeColor = kSGMTDBlackColor.CGColor;
    layer.path = inverter_Path.CGPath;
    [self addSublayer:layer];
    
    [inverter_Path closePath];
    [inverter_Path removeAllPoints];
    layer = nil;
    self.backgroundColor = kSGMTDGreenColor.CGColor;
    
}
//画关断控制器
-(void)drawTurnOffControllerByContext:(CGContextRef)ctx{
    
    UIBezierPath *turnOff_Path = [self createPath];
    CAShapeLayer *layer = [self createLayer];
    layer.lineWidth = 1.0 / [UIScreen mainScreen].scale;
    
    CGFloat outSpace = 0.0;
    CGFloat inSpace = 2.0;
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGPoint point1 = CGPointMake(outSpace, outSpace);
    CGPoint point2 = CGPointMake(w-outSpace, outSpace);
    CGPoint point3 = CGPointMake(w-outSpace, h-outSpace);
    CGPoint point4 = CGPointMake(outSpace, h-outSpace);
    CGPoint point0 = CGPointMake(outSpace, outSpace);
    //
    [turnOff_Path moveToPoint:point1];
    [turnOff_Path addLineToPoint:point2];
    [turnOff_Path addLineToPoint:point3];
    [turnOff_Path addLineToPoint:point4];
    [turnOff_Path addLineToPoint:point0];
    //
    CGPoint point5 = CGPointMake(w-inSpace, inSpace);
    CGPoint point6 = CGPointMake(inSpace, h-inSpace);
    [turnOff_Path moveToPoint:point5];
    [turnOff_Path addLineToPoint:point6];
    //
    CGPoint point7 = CGPointMake(4, 4);
    CGPoint point8 = CGPointMake(13, 4);
    CGPoint point9 = CGPointMake(4, 8);
    CGPoint point10 = CGPointMake(13, 8);
    //
    [turnOff_Path moveToPoint:point7];
    [turnOff_Path addLineToPoint:point8];
    [turnOff_Path moveToPoint:point9];
    [turnOff_Path addLineToPoint:point10];
    //
    CGFloat control1 = (w/8.0+inSpace);
    CGFloat control2 = (w*3/8.0-inSpace);
    CGFloat control3 = w/2.0+control1;
    CGFloat control4 = w/2.0+control2;
    CGPoint point11 = CGPointMake(w/2.0+1.0, outSpace+8.0+h/2.0);
    CGPoint point12 = CGPointMake(w-2.0, outSpace+8.0+h/2.0);
    CGPoint point13 = CGPointMake(control3, outSpace+5.0+h/2.0);
    CGPoint point14 = CGPointMake(control4, outSpace+11.0+h/2.0);
    [turnOff_Path moveToPoint:point11];
    [turnOff_Path addCurveToPoint:point12 controlPoint1:point13 controlPoint2:point14];
    
    layer.strokeColor = kSGMTDBlackColor.CGColor;
    layer.path = turnOff_Path.CGPath;
    [self addSublayer:layer];
    
    [turnOff_Path closePath];
    [turnOff_Path removeAllPoints];
    self.backgroundColor = kSGMTDGreenColor.CGColor;
    
    
}
//画关断器
-(void)drawIntellectByContext:(CGContextRef)ctx{
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGFloat lineWidth = 1.0 / [UIScreen mainScreen].scale;  
    CGSize itemSize = self.itemModel.size;
    NSInteger row = self.itemModel.row;
    NSInteger column = self.itemModel.column;
    //选中 填充
    if (self.itemModel.isSelect) {
        
        UIGraphicsPushContext(ctx);
        UIBezierPath *orangeRect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, w - kSGMTDSqurtSpace, h - kSGMTDSqurtSpace)];
        orangeRect.lineCapStyle = kCGLineCapRound;
        orangeRect.lineJoinStyle = kCGLineJoinRound;
        CGContextSetFillColorWithColor(ctx, UIColor.orangeColor.CGColor);
        [orangeRect fill];
        UIGraphicsPopContext();
        return;
    }
    
    //未选中 黑色阴影
    UIGraphicsPushContext(ctx);
    CGRect rect = CGRectMake(0, itemSize.height - kSGMTDSqurtSpace - kSGMTDSqurtBlack, itemSize.width - kSGMTDSqurtSpace, kSGMTDSqurtBlack);
    UIBezierPath *extraRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:lineWidth];
    extraRect.lineCapStyle = kCGLineCapRound;
    extraRect.lineJoinStyle = kCGLineJoinRound;
    CGContextSetFillColorWithColor(ctx, UIColor.blackColor.CGColor);
    [extraRect fill];
    
    //未选中 蓝色背景
    UIBezierPath *blueRect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, itemSize.width - kSGMTDSqurtSpace, itemSize.height - kSGMTDSqurtSpace - kSGMTDSqurtBlack)];
    blueRect.lineCapStyle = kCGLineCapRound;
    blueRect.lineJoinStyle = kCGLineJoinRound;
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0.48 green:0.80 blue:0.99 alpha:1.00].CGColor);
    [blueRect fill];
    
    //未选中 横竖线条
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:0.36 green:0.68 blue:0.85 alpha:1.00] setStroke];
    CGContextSetLineWidth(ref, lineWidth);
    CGContextSetLineCap(ref, kCGLineCapRound);
    CGContextSetLineJoin(ref, kCGLineJoinRound);
    
    CGFloat unitW = kSGMTDSqurtWidth;
    CGFloat unitH = kSGMTDSqurtHeight;
    if (self.itemModel.hvType == ItemHVTypeVertical) {
        
        unitW = kSGMTDSqurtHeight;
        unitH = kSGMTDSqurtWidth;
    }
    
    for (int i = 0; i <= row; i ++) {
        CGContextBeginPath(ref);
        CGContextMoveToPoint(ref, unitW*i, 0);
        CGContextAddLineToPoint(ref, unitW*i, h-kSGMTDSqurtBlack-kSGMTDSqurtSpace);
        CGContextStrokePath(ref);
    }
 
    for (int i = 0; i <= column; i ++) {
        CGContextBeginPath(ref);
        CGContextMoveToPoint(ref, 0, unitH*i);
        CGContextAddLineToPoint(ref, w-kSGMTDSqurtSpace, unitH*i);
        CGContextStrokePath(ref);
    }
    UIGraphicsPopContext();
    
}



#pragma mark layer path init
-(CALayer *)createLayerByType:(NSInteger)type{
    
    CGFloat w = self.frame.size.width-1.0;
    CGFloat h = w;
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, w, h);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    return layer;
}
//描边线
- (CAShapeLayer *)createLayer {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor darkGrayColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    return layer;
}
//填充
- (CAShapeLayer *)createFillLayer {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor clearColor].CGColor;
    layer.fillColor = kSGMTDBlueColor.CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    return layer;
}

- (UIBezierPath *)createPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    return path;
}

//白天 夜晚 颜色
-(UIColor *)colorByColor:(UIColor *)color{
    
    BOOL dayNight = YES;
    return dayNight ? kSGMTDLightGrayColor : [UIColor whiteColor];
    
}

@end


