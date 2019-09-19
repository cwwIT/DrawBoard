//
//  SGDrawItemLayer.h
//  SunElectricBoard
//
//  Created by sungrow on 2019/9/7.
//  Copyright © 2019 CWW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGMTDDrawItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SGMTDDrawItemLayer : CATiledLayer

@property (nonatomic, strong) SGMTDDrawItemModel *itemModel;

- (void)reDraw;

@end

NS_ASSUME_NONNULL_END
