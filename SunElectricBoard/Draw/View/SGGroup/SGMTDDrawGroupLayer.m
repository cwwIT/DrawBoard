//
//  SGDrawGroupLayer.m
//  SunElectricBoard
//
//  Created by sungrow on 2019/9/7.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGMTDDrawGroupLayer.h"


@interface SGMTDDrawGroupLayer ()

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) CGFloat itemH;
@property (nonatomic, assign) CGFloat itemw;

@end

@implementation SGMTDDrawGroupLayer

- (instancetype)init {
    if (self = [super init]) {
        [self configData];
    }
    return self;
}

- (void)configData {
    
}

- (void)setGroupModel:(SGMTDDrawGroupModel *)groupModel {
    _groupModel = groupModel;
    [self updateContentLayer];
}

- (void)updateContentLayer {
    //
    //    1.极少崩溃，但是页面刷新会稍微卡顿
    NSArray<CALayer *> *subLayers = self.sublayers;
    NSArray<CALayer *> *removeLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:[CALayer class]];
    }]];
    [removeLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    //    2.偶尔崩溃
    //    [self.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    //    3.崩溃
    //    [self.sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        [obj removeFromSuperlayer];
    //    }];
    
    for (int i = 0; i < self.groupModel.itemModels.count; i ++) {
        NSArray <SGMTDDrawItemModel *>*columnItems = self.groupModel.itemModels[i];
        for (int j = 0; j < columnItems.count; j ++) {
            SGMTDDrawItemModel *itemModel = columnItems[j];
            SGMTDDrawItemLayer *itemLayer = [[SGMTDDrawItemLayer alloc] init];
            itemModel.indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            itemLayer.itemModel = itemModel;
            itemLayer.frame = itemModel.frame;
            [self addSublayer:itemLayer];
        }
    }
    
    self.bounds = CGRectMake(0, 0, self.groupModel.size.width, self.groupModel.size.height);
    self.transform = CATransform3DMakeRotation(self.groupModel.rotationRadians, 0, 0, 1);
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        if (selected) {
            self.borderColor = UIColor.redColor.CGColor;
            self.borderWidth = 2.0;
        } else {
            self.borderColor = UIColor.redColor.CGColor;
            self.borderWidth = 0.0;
        }
        _selected = selected;
    }
}

- (SGMTDDrawItemLayer *)itemLayerForLocation:(CGPoint)location {
    for (CALayer *layer in self.sublayers.reverseObjectEnumerator) {
        if ([layer isKindOfClass:SGMTDDrawItemLayer.class]) {
            SGMTDDrawItemLayer *itemLayer = (SGMTDDrawItemLayer *)layer;
            if (CGRectContainsPoint(itemLayer.bounds, [itemLayer convertPoint:location fromLayer:itemLayer.superlayer])) {
                return itemLayer;
            }
        }
    }
    return nil;
}



@end
