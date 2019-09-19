//
//  SGDrawGroupModel.h
//  SunElectricBoard
//
//  Created by sungrow on 2019/9/7.
//  Copyright © 2019 CWW. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SGMTDDrawBaseModel.h"
#import "SGMTDDrawItemModel.h" 


NS_ASSUME_NONNULL_BEGIN

@interface SGMTDDrawGroupModel : SGMTDDrawBaseModel<NSCoding>

@property (nonatomic, strong) NSMutableArray <NSArray <SGMTDDrawItemModel *>*> *itemModels;
@property (nonatomic, assign) CGPoint position;//
@property (nonatomic, assign) MastermindItemKindType kindType;//模块类型
@property (nonatomic, assign) MastermindItemHVType hvType;    // 水平竖直
/** 旋转角度 0 -- 360 */
@property (nonatomic, assign) CGFloat rotationDegrees;
/** 旋转角度 0 -- M_PI * 2 */
@property (nonatomic, assign, readonly) CGFloat rotationRadians;
//@property (nonatomic,assign) CGRect frame;     //

@property (nonatomic, assign, readonly) CGPoint origin;
@property (nonatomic, assign, readonly) CGSize itemSize;
@property (nonatomic, assign, readonly) CGSize size;      //
@property (nonatomic, assign, readonly) NSInteger row;   //多少行
@property (nonatomic, assign, readonly) NSInteger column;//多少列
@property (nonatomic, assign, getter=isSelect) BOOL select;//选中
@property (nonatomic, assign, readonly) CGRect transformRect;

+ (void)findBorderRectModelInGroupModels:(NSArray <SGMTDDrawGroupModel *>*)groupModels completion:(void (^)(SGMTDDrawGroupModel *minXModel, SGMTDDrawGroupModel *minYModel, SGMTDDrawGroupModel *maxXModel, SGMTDDrawGroupModel *maxYModel))completion;

+ (NSArray <SGMTDDrawGroupModel *>*)deepCopyModels:(NSArray <SGMTDDrawGroupModel *>*)models;

@end

NS_ASSUME_NONNULL_END
