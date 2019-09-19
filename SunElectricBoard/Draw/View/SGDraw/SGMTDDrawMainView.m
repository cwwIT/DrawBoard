//
//  SGDrawMainView.m
//  SunElectricBoard
//
//  Created by sungrow on 2019/9/7.
//  Copyright © 2019 CWW. All rights reserved.
//


#import "SGMTDDrawMainView.h"


@interface SGMTDDrawMainView ()

@property (nonatomic, strong) NSMutableArray <SGMTDDrawGroupLayer *> *groupLayers;
@property (nonatomic, strong) NSMutableArray <SGMTDDrawGroupModel *>*groupModels;
@property (nonatomic, strong) SGMTDDrawGroupLayer *selectionGroupLayer;
@property (nonatomic, strong) SGMTDDrawItemLayer *selectionItemLayer;


@end

@implementation SGMTDDrawMainView

#pragma mark - lazy
- (NSMutableArray <SGMTDDrawGroupLayer *> *)groupLayers {
    if (!_groupLayers) {
        _groupLayers = [NSMutableArray array];
    }
    return _groupLayers;
}

-(NSMutableArray<SGMTDDrawGroupModel *> *)groupModels{
    if (!_groupModels) {
        _groupModels = [NSMutableArray array];
    }
    return _groupModels;
}
#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configDataAngGestureRecognizer];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configDataAngGestureRecognizer];
}

#pragma mark - view
- (void)configDataAngGestureRecognizer {
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.2;
    [self addGestureRecognizer:longPress];
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)];
    [self addGestureRecognizer:rotation];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    // 双击事件响应失败时, 响应单击事件
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (SGMTDDrawGroupLayer *)groupLayerForLocation:(CGPoint)location {
    for (SGMTDDrawGroupLayer *layer in self.groupLayers.reverseObjectEnumerator) {
        if (CGRectContainsPoint(layer.bounds, [self.layer convertPoint:location toLayer:layer])) {
            return layer;
        }
    }
    return nil;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    if (self.selectionGroupLayer && self.selectionGroupLayer.isSelected) { return; }
    
    if (_longPressActionBlock) {
        _longPressActionBlock(self,longPress);
    }
    CGPoint location = [longPress locationInView:self];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.selectionGroupLayer = [self groupLayerForLocation:location];
        if (_longPressChangeLayerBlock) {
            _longPressChangeLayerBlock(self,longPress);
        }
        self.selectionGroupLayer.opacity = 0.7; //不透明度
        if (@available(iOS 10.0, *)) {
            UIImpactFeedbackGenerator *feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [feedback prepare];
            [feedback impactOccurred];
        } else {
            
        }
    } else if ((longPress.state == UIGestureRecognizerStateEnded) || (longPress.state == UIGestureRecognizerStateCancelled)) {
        [self registerUndo];
        self.selectionGroupLayer.groupModel.position = self.selectionGroupLayer.position;
        self.selectionGroupLayer.opacity = 1.0;
        [self updateCanvasRect];
        self.selectionGroupLayer = nil;
    }
    if (!self.selectionGroupLayer) return;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.selectionGroupLayer.position = location;
    [CATransaction commit];
}

- (void)rotationAction:(UIRotationGestureRecognizer *)rotation {
    if (rotation.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [rotation locationInView:self];
        self.selectionGroupLayer = [self groupLayerForLocation:location];
    } else if ((rotation.state == UIGestureRecognizerStateEnded) || (rotation.state == UIGestureRecognizerStateCancelled)) {
        [self registerUndo];
        CGFloat angle = [(NSNumber *)[self.selectionGroupLayer valueForKeyPath:@"transform.rotation.z"] floatValue];
        self.selectionGroupLayer.groupModel.rotationDegrees = angle * (180 / M_PI);
        [self updateCanvasRect];
        self.selectionGroupLayer = nil;
    }
    if (!self.selectionGroupLayer) return;
    self.selectionGroupLayer.transform = CATransform3DRotate(self.selectionGroupLayer.transform, rotation.rotation, 0, 0, 1);
    rotation.rotation = 0.0;
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    CGPoint location = [tap locationInView:self];
    if (!self.selectionGroupLayer) {
        self.selectionItemLayer.itemModel.select = NO;
        [self.selectionItemLayer reDraw];
        SGMTDDrawGroupLayer *selectionGroupLayer = [self groupLayerForLocation:location];
        if (!selectionGroupLayer) { return; }
        self.selectionItemLayer = [selectionGroupLayer itemLayerForLocation:[self.layer convertPoint:location toLayer:selectionGroupLayer]];
        if (!self.selectionGroupLayer) return;
        self.selectionItemLayer.itemModel.select = !self.selectionItemLayer.itemModel.select;
        [self.selectionItemLayer reDraw];
        return;
    }
    if (self.selectionGroupLayer == [self groupLayerForLocation:location]) {
        [self registerUndo];
        SGMTDDrawItemLayer *itemLayer = [self.selectionGroupLayer itemLayerForLocation:[self.layer convertPoint:location toLayer:self.selectionGroupLayer]];
        if (!itemLayer) return;
        itemLayer.itemModel.hidden = !itemLayer.itemModel.hidden;
        [itemLayer reDraw];
    } else {
        self.selectionGroupLayer.selected = NO;
        self.selectionGroupLayer = nil;
    }
}

- (void)doubleTapAction:(UITapGestureRecognizer *)tap {
    self.selectionItemLayer.itemModel.select = NO;
    [self.selectionItemLayer reDraw];
    CGPoint location = [tap locationInView:self];
    self.selectionGroupLayer.selected = NO;
    self.selectionGroupLayer = [self groupLayerForLocation:location];
    if (!self.selectionGroupLayer) return;
    self.selectionGroupLayer.selected = YES;
}


- (SGMTDDrawGroupLayer *)addGroupLayerRow:(NSInteger)row column:(NSInteger)column type:(MastermindItemHVType)type kindType:(MastermindItemKindType)kindType rotationDegrees:(CGFloat)rotationDegrees position:(CGPoint)position{
    [self registerUndo];
    SGMTDDrawGroupLayer *groupLayer = [[SGMTDDrawGroupLayer alloc] init];
    SGMTDDrawGroupModel *groupModel = [[SGMTDDrawGroupModel alloc] init];
    groupModel.kindType = kindType;
    groupModel.itemModels = [NSMutableArray array];
    for (int i = 0; i < row; i ++) {
        NSMutableArray *temp = [NSMutableArray array];
        for (int j = 0; j < column; j ++) {
            SGMTDDrawItemModel *item = [[SGMTDDrawItemModel alloc] init];
            item.hvType = type;
            item.kindType = kindType;
            [temp addObject:item];
        }
        [groupModel.itemModels addObject:temp];
    }
    groupModel.rotationDegrees = rotationDegrees;
    groupModel.position = position;
    groupLayer.groupModel = groupModel;
    [self.layer addSublayer:groupLayer];
    [self.groupLayers addObject:groupLayer];
    groupLayer.position = position;
    [self updateCanvasRect];
    return groupLayer;
    return nil;
}

- (void)addGroupLayerRow:(NSInteger)row column:(NSInteger)column type:(MastermindItemHVType)type kindType:(MastermindItemKindType)kindType rotationDegrees:(CGFloat)rotationDegrees position:(CGPoint)position groupModel:(SGMTDDrawGroupModel *)groupModel{
    
    [self registerUndo];
    SGMTDDrawGroupLayer *groupLayer = [[SGMTDDrawGroupLayer alloc] init]; 
    groupLayer.groupModel = groupModel;
    [self.layer addSublayer:groupLayer];
    [self.groupLayers addObject:groupLayer];
    groupLayer.position = position;
    [self updateCanvasRect];
}


- (void)removeGroupLayerAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.groupLayers.count) {
        SGMTDDrawGroupLayer *groupLayer = [self.groupLayers objectAtIndex:index];
        [self removeGroupLayer:groupLayer];
    }
}

- (void)removeGroupLayer:(SGMTDDrawGroupLayer *)groupLayer {
    [self registerUndo];
    if (groupLayer.superlayer) {
        [groupLayer removeFromSuperlayer];
    }
    if ([self.groupLayers containsObject:groupLayer]) {
        [self.groupLayers removeObject:groupLayer];
    }
    [self updateCanvasRect];
}

- (void)updateCanvasRect {
    NSMutableArray <SGMTDDrawGroupModel *>*groupModels = [NSMutableArray array];
    for (SGMTDDrawGroupLayer *groupLayer in self.groupLayers) {
        [groupModels addObject:groupLayer.groupModel];
    }
    [SGMTDDrawGroupModel findBorderRectModelInGroupModels:groupModels completion:^(SGMTDDrawGroupModel * _Nonnull minXModel, SGMTDDrawGroupModel * _Nonnull minYModel, SGMTDDrawGroupModel * _Nonnull maxXModel, SGMTDDrawGroupModel * _Nonnull maxYModel) {
        // 修正X
        CGFloat correctionX = minXModel.transformRect.origin.x;
        // 修正Y
        CGFloat correctionY = minYModel.transformRect.origin.y;
        [self rectCorrectionX:correctionX y:correctionY];
        CGSize resultSize = CGSizeMake(CGRectGetMaxX(maxXModel.transformRect), CGRectGetMaxY(maxYModel.transformRect));
        !self.canvasRectDidChangedBlock ?: self.canvasRectDidChangedBlock(resultSize);
    }];
}

- (void)rectCorrectionX:(CGFloat)x y:(CGFloat)y {
    for (SGMTDDrawGroupLayer *obj in self.groupLayers) {
        obj.groupModel.position = CGPointMake(obj.position.x - x, obj.position.y - y);
        obj.position = obj.groupModel.position;
    }
}
//
- (BOOL)canUndo {
    return self.undoManager.canUndo;
}

- (BOOL)canRedo {
    return self.undoManager.canRedo;
}

- (void)undoAction {
    BOOL can = [self canUndo];
    if (can) {
        [self.undoManager undo];
    }
}

- (void)redoAction {
    BOOL can = [self canRedo];
    if (can) {
        [self.undoManager redo];
    }
}
 

- (void)registerUndo {
    NSMutableArray <SGMTDDrawGroupModel *>*groupModels = [NSMutableArray array];
    for (SGMTDDrawGroupLayer *groupLayer in self.groupLayers) {
        [groupModels addObject:groupLayer.groupModel];
    }
    
    CGFloat zoomScale = 1.0;
    CGPoint contentOffset = CGPointZero;
    
    if (_changeMyScaleAndpointBlock) {
        _changeMyScaleAndpointBlock();
    }
    [[self.undoManager prepareWithInvocationTarget:self] updateContents:[SGMTDDrawGroupModel deepCopyModels:groupModels] zoomScale:zoomScale contentOffset:contentOffset];
    if (_registerUndoBlock) {
        _registerUndoBlock();
    }
    
}


- (void)updateContents:(NSArray <SGMTDDrawGroupModel *>*)groupModels zoomScale:(CGFloat)zoomScale contentOffset:(CGPoint)contentOffset {
    
    if (_undoZoomScaleAndpointBlock) {
        _undoZoomScaleAndpointBlock(_zoomScale,_contentOffset);
    }
    [self registerUndo];
    
    NSMutableArray <SGMTDDrawGroupLayer *>*removeLayers = [NSMutableArray array];
    NSMutableArray <SGMTDDrawGroupLayer *>*addLayers = [NSMutableArray array];
    
    for (int i = 0; i < self.groupLayers.count || i < groupModels.count; i ++) {
        // 是否需要更新
        if (i < self.groupLayers.count && i < groupModels.count) {
            // 更新
            if (![self.groupLayers[i].groupModel isEqual:groupModels[i]]) {
                self.groupLayers[i].groupModel = groupModels[i];
                self.groupLayers[i].position = groupModels[i].position;
            }
        }
        // 删除
        else if (i < self.groupLayers.count && i >= groupModels.count) {
            [removeLayers addObject:self.groupLayers[i]];
        }
        // 添加
        else if (i >= self.groupLayers.count && i < groupModels.count) {
            SGMTDDrawGroupLayer *groupLayer = [[SGMTDDrawGroupLayer alloc] init];
            groupLayer.groupModel = groupModels[i];
            groupLayer.position = groupModels[i].position;
            [addLayers addObject:groupLayer];
        }
    }
    
    [removeLayers enumerateObjectsUsingBlock:^(SGMTDDrawGroupLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeGroupLayer:obj];
    }];
    
    [addLayers enumerateObjectsUsingBlock:^(SGMTDDrawGroupLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.layer addSublayer:obj];
        [self.groupLayers addObject:obj];
    }];
    
    [self updateCanvasRect];
    
    
}

//清理画板
-(void)clearView{
//     1.清理画板；
    NSArray<SGMTDDrawGroupLayer *> *subLayers = self.groupLayers;
    NSArray<SGMTDDrawGroupLayer *> *removeLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:[CALayer class]];
    }]];
    [removeLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    
    [self.groupLayers removeAllObjects];
    [self.groupModels removeAllObjects];
//   2.同时清理缓存
    [self saveData];
}
//保存画板数据
-(void)saveData{
    
    SGMTDDrawGroupModel *groupModel = [[SGMTDDrawGroupModel alloc]init];
    [self.groupModels removeAllObjects];
    for (SGMTDDrawGroupLayer *groupLayer in self.groupLayers) {
        groupModel = groupLayer.groupModel;
        [self.groupModels addObject:groupModel];
    }
    [self saveDataBy:self.groupModels];
    
}
//归档
-(void)saveDataBy:(NSMutableArray *)array{
    
    NSString *pathName = [self pathWithSGDrawBoardDataByFileName:@""];
    //获取文件全路径《如果是单个数据，一般采用的是data类型的数据保存，如果多个数据，比如数组类型的就会保存为.plist文件》
    [NSKeyedArchiver archiveRootObject:array toFile:pathName];
    
//    NSError *error = nil;
//    新方法 只能适用于 循环单个存储
//    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:array requiringSecureCoding:YES error:&error];
//    if (error) {
//        return ;
//    }
//    [saveData writeToFile:pathName atomically:YES];

}

//把画板数据取出来
-(NSMutableArray *)getDrawBoardDataFromFinder{
    
    NSString *pathName = [self pathWithSGDrawBoardDataByFileName:@""];
    //解析文件
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:(NSArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:pathName]];
//    NSError *error;
//    NSData *data = [[NSData alloc] initWithContentsOfFile:pathName];
//    //会调用对象的initWithCoder方法
//    NSMutableArray *dataArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[SGDrawGroupModel class] fromData:data error:&error];
//    if (error) {
//        return nil;
//    }
    
    return dataArray;

}



-(NSString *)pathWithSGDrawBoardDataByFileName:(NSString *)fileName{
    //
    if (!fileName || [fileName isEqualToString:@""]) {
        fileName = @"/SGDrawDataCoding.plist";
    }
    //获取沙河路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //获取文件路径
    NSString * pathName = [path stringByAppendingString:fileName];
    return pathName;
}

@end










 
