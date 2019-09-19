//
//  SGDrawMainView.h
//  SunElectricBoard
//
//  Created by sungrow on 2019/9/7.
//  Copyright © 2019 CWW. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SGMTDDrawItemLayer.h"
#import "SGMTDDrawGroupLayer.h"

NS_ASSUME_NONNULL_BEGIN
@class SGMTDDrawMainView;

typedef void(^CanvasRectDidChangedBlock)(CGSize size);
typedef void(^ChangeMyScaleAndpointBlock)(void);
typedef void(^RegisterUndoBlock)(void);
typedef void(^UndoZoomScaleAndpointBlock)(CGFloat zoomScale,CGPoint contentOffset);
typedef void(^LongPressActionBlock)(SGMTDDrawMainView *drawMainView,UILongPressGestureRecognizer *longPress);

@interface SGMTDDrawMainView : UIView

//@property (nonatomic, strong) NSUndoManager *SGUndoManager;

@property (nonatomic, copy) CanvasRectDidChangedBlock canvasRectDidChangedBlock;
@property (nonatomic, copy) ChangeMyScaleAndpointBlock changeMyScaleAndpointBlock;
@property (nonatomic, copy) RegisterUndoBlock registerUndoBlock;
@property (nonatomic, copy) UndoZoomScaleAndpointBlock undoZoomScaleAndpointBlock;
//改变层级，选中的放在最上面
@property (nonatomic, copy) LongPressActionBlock longPressActionBlock;
//改变数组，选中的 放在最后一个
@property (nonatomic, copy) LongPressActionBlock longPressChangeLayerBlock;
//
@property (nonatomic, strong, readonly) NSMutableArray <SGMTDDrawGroupLayer *>*groupLayers;
@property (nonatomic, strong, readonly) NSMutableArray <SGMTDDrawGroupModel *>*groupModels;

@property (nonatomic, strong, readonly) SGMTDDrawGroupLayer *selectionGroupLayer;
@property (nonatomic, strong, readonly) SGMTDDrawItemLayer *selectionItemLayer;

@property (nonatomic, assign) CGFloat zoomScale;
@property (nonatomic, assign) CGPoint contentOffset;

- (BOOL)canUndo ;
- (BOOL)canRedo ; 
- (void)undoAction ;
- (void)redoAction ;

- (void)removeGroupLayerAtIndex:(NSInteger)index;
- (void)removeGroupLayer:(SGMTDDrawGroupLayer *)groupLayer;

//清理画板
-(void)clearView;
//保存画板数据
-(void)saveData;
//把画板数据取出来
-(NSMutableArray *)getDrawBoardDataFromFinder;
//添加内容
- (SGMTDDrawGroupLayer *)addGroupLayerRow:(NSInteger)row column:(NSInteger)column type:(MastermindItemHVType)type kindType:(MastermindItemKindType)kindType rotationDegrees:(CGFloat)rotationDegrees position:(CGPoint)position;

//添加刷新内容
- (void)addGroupLayerRow:(NSInteger)row column:(NSInteger)column type:(MastermindItemHVType)type kindType:(MastermindItemKindType)kindType rotationDegrees:(CGFloat)rotationDegrees position:(CGPoint)position groupModel:(SGMTDDrawGroupModel *)groupModel;

@end

NS_ASSUME_NONNULL_END
