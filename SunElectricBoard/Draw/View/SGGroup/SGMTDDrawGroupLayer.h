//
//  SGDrawGroupLayer.h
//  SunElectricBoard
//
//  Created by sungrow on 2019/9/7.
//  Copyright © 2019 CWW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGMTDDrawGroupModel.h"
#import "SGMTDDrawItemLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface SGMTDDrawGroupLayer : CAShapeLayer

@property (nonatomic,assign,getter=isSelected) BOOL selected;

@property (nonatomic, strong) SGMTDDrawGroupModel *groupModel;

- (SGMTDDrawItemLayer *)itemLayerForLocation:(CGPoint)location;

@end

NS_ASSUME_NONNULL_END
