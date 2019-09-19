//
//  SGDrawItemModel.h
//  SunElectricBoard
//
//  Created by sungrow on 2019/9/7.
//  Copyright © 2019 CWW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGMTDDrawBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SGMTDDrawItemModel : SGMTDDrawBaseModel<NSCoding>

@property (nonatomic, assign) MastermindItemHVType hvType;    // 水平竖直
@property (nonatomic, assign) MastermindItemKindType kindType;//模块类型
@property (nonatomic, strong) NSIndexPath *indexPath;//在父视图中的下标
@property (nonatomic, assign, getter=isSelect) BOOL select;//选中
@property (nonatomic, assign, getter=isHidden) BOOL hidden;//隐藏，删除

@property (nonatomic, assign, readonly) CGSize size;      //
@property (nonatomic, assign, readonly) NSInteger row;
@property (nonatomic, assign, readonly) NSInteger column;
@property (nonatomic, assign, readonly) CGRect frame;
@property (nonatomic, assign, readonly) CGPoint origin;

@end

NS_ASSUME_NONNULL_END
