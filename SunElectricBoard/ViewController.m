//
//  ViewController.m
//  SunElectricBoard
//
//  Created by sungrow on 2019/9/7.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "ViewController.h"

#import "SGMTDDrawMainView.h"
#import "SGMTDDrawEditView.h"
#import "SGMTDDrawAddView.h"
#import "SGMTDDrawDeleteAreaView.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) SGMTDDrawMainView *drawView;
@property (nonatomic, strong) SGMTDDrawDeleteAreaView *deleteArea;

@property (nonatomic,strong) UIButton *clearButton;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *editButton;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) SGMTDDrawEditView *editView;
@property (nonatomic,strong) SGMTDDrawAddView *addView;

@property (nonatomic,strong) UIButton *undoButton;
@property (nonatomic,strong) UIButton *redoButton;

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

@end

@implementation ViewController

- (SGMTDDrawDeleteAreaView *)deleteArea {
    if (!_deleteArea) {
        _deleteArea = [[SGMTDDrawDeleteAreaView alloc] initWithFrame:CGRectMake(0, 20, 100, 100)];
        [_deleteArea hide];
        _deleteArea.backgroundColor = [UIColor blackColor];
        _deleteArea.alpha = 0.6;
    }
    return _deleteArea;
}

- (void)loadView{
    [super loadView];
//    [self startActivityIndicator];
    [self configData];
    [self createSubView];
//    [self startActivityIndicator];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawLastBoardContent];
    
}

-(void)startActivityIndicator{
    
    if (!_activityIndicator) {
        
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
//        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.backScrollView addSubview:self.activityIndicator];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.backScrollView.centerYAnchor].active = YES;
        [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.backScrollView.centerXAnchor].active = YES;
        //设置小菊花的frame
//        self.activityIndicator.size= CGSizeMake(118, 118);
        self.activityIndicator.frame = CGRectMake(0, 0, 118, 118);
        self.activityIndicator.layer.cornerRadius = 5;
        //设置小菊花颜色
//        self.activityIndicator.color = [UIColor redColor];
        //设置背景颜色
        self.activityIndicator.backgroundColor = kSGMTDLightGrayColor;
        //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
        self.activityIndicator.hidesWhenStopped = NO;
    }
    [_activityIndicator startAnimating];
}

-(void)drawLastBoardContent{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    dataArray = [_drawView getDrawBoardDataFromFinder];
    
    for (SGMTDDrawGroupModel *groupModel in dataArray) {
        
        MastermindItemHVType type = groupModel.hvType;
        NSInteger row = groupModel.row;
        NSInteger column = groupModel.column;
        CGFloat rotation = groupModel.rotationDegrees;
        MastermindItemKindType kindType = groupModel.kindType;
//        CGFloat maxX = self.view.bounds.size.width*0.3;
//        CGFloat maxY = self.view.bounds.size.height*0.3;
        CGPoint position = groupModel.position;
        //
//        [self addGroupLayerByRow:row column:column type:type kindType:kindType rotationDegrees:rotation position:position];
        
        [self.drawView addGroupLayerRow:row column:column type:type  kindType:kindType rotationDegrees:rotation position:position groupModel:groupModel];
        
    }
    
//    [self performSelector:@selector(stopActivity) withObject:nil afterDelay:1.0];
}

-(void)stopActivity{
    
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
    _activityIndicator = nil;
}
-(void)configData{
    
}

-(void)createSubView{
    
//    __weak typeof(self) weakSelf = self;
    
    if (!_backScrollView) {
        //
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SGMTDSCREENWIDTH, kSGMTDScrollowViewHeight)];
        _backScrollView.delegate = self;
        _backScrollView.backgroundColor = kSGMTDBackGroundColor;
        _backScrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
        [self.view addSubview:_backScrollView];
        
//        [_backScrollView setZoomScale:1.0 animated:YES];
        _backScrollView.bouncesZoom = NO;
        _backScrollView.bounces = NO;
        _backScrollView.alwaysBounceVertical = YES;
        _backScrollView.alwaysBounceHorizontal = YES;
//        _backScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    if (!_drawView) {
        //
        _drawView = [[SGMTDDrawMainView alloc]initWithFrame:CGRectMake(0, 0, SGMTDSCREENWIDTH-2*kSGMTDScrollowViewContentInset, kSGMTDScrollowViewHeight-kSGMTDScrollowViewContentInset*2)];
        _drawView.backgroundColor = kSGMTDBackGroundColor;
//        _drawView.backgroundColor = SGMTDRANDOMCOLOR;
        [_backScrollView addSubview:_drawView];
        __weak typeof(self) weakSelf = self;
        _drawView.canvasRectDidChangedBlock = ^(CGSize size) {
            
            CGSize resultSize = CGSizeMake(size.width * weakSelf.backScrollView.zoomScale, size.height * weakSelf.backScrollView.zoomScale);
            [weakSelf updateCanvasViewFrame:resultSize];
            [weakSelf updateZoomScale];
            
        };
        
        _drawView.changeMyScaleAndpointBlock = ^{
            weakSelf.drawView.zoomScale = weakSelf.backScrollView.zoomScale;
            weakSelf.drawView.contentOffset = weakSelf.backScrollView.contentOffset;
        };
        
        _drawView.registerUndoBlock = ^{
            [weakSelf updateUndoEnable];
        };
        
        _drawView.undoZoomScaleAndpointBlock = ^(CGFloat zoomScale,CGPoint contentOffset){
            
            weakSelf.backScrollView.zoomScale = zoomScale;
            weakSelf.backScrollView.contentOffset = contentOffset;
        };
        
        _drawView.longPressActionBlock = ^(SGMTDDrawMainView * _Nonnull drawMainView,UILongPressGestureRecognizer *longPress) {
            CGPoint location = [longPress locationInView:weakSelf.view];
            if (CGRectContainsPoint(weakSelf.deleteArea.frame, location)) {
                weakSelf.backScrollView.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.2];
            } else {
                weakSelf.backScrollView.backgroundColor = UIColor.whiteColor;
            }
            //将选中的layer放在最上层；不能放在删除layer代码后面
            NSArray *subLayersArray = drawMainView.layer.sublayers;
            if (subLayersArray && subLayersArray.count) {
                NSInteger layersCount = subLayersArray.count;
                [drawMainView.layer insertSublayer:drawMainView.selectionGroupLayer atIndex:(unsigned)(layersCount-0)];
                
            }
            if (longPress.state == UIGestureRecognizerStateBegan) {
                [weakSelf.deleteArea show];
            }else if ((longPress.state == UIGestureRecognizerStateEnded) || (longPress.state == UIGestureRecognizerStateCancelled)) {
                [weakSelf.deleteArea hide];
                weakSelf.backScrollView.backgroundColor = UIColor.whiteColor;
                if (CGRectContainsPoint(weakSelf.deleteArea.frame, location)) {
                    [drawMainView removeGroupLayer:drawMainView.selectionGroupLayer];
                }
            }
        };
        
        _drawView.longPressChangeLayerBlock = ^(SGMTDDrawMainView * _Nonnull drawMainView, UILongPressGestureRecognizer * _Nonnull longPress) {
            
            //将选中的layer放在数组最后一个，下次进入绘制时，大图不会覆盖小图。
            NSArray *groupLayers = drawMainView.groupLayers;
            SGMTDDrawGroupLayer *selectLayer = drawMainView.selectionGroupLayer;
            if (groupLayers && groupLayers.count && selectLayer) {
                NSInteger index = [groupLayers indexOfObject:selectLayer];
                NSInteger count = groupLayers.count;
                [drawMainView.groupLayers exchangeObjectAtIndex:(count-1) withObjectAtIndex:index];
                
            }
            
        };
        
    }
    
    if (!_clearButton) {
        //
        CGFloat btWidth = 64;
        CGFloat bt_w = 44;
        CGFloat btHeight = 30;
        CGFloat space = 15;
        _clearButton = [[UIButton alloc]initWithFrame:CGRectMake(SGMTDSCREENWIDTH-(btWidth+space), SGMTDSCREENHEIGHT-btHeight-space, btWidth, btHeight)];
        [_clearButton setTitle:@"clear" forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _clearButton.backgroundColor = kSGMTDGrayColor;
        [self.view addSubview:_clearButton];
        
        _saveButton = [[UIButton alloc]initWithFrame:CGRectMake(SGMTDSCREENWIDTH-(btWidth+space)*2, SGMTDSCREENHEIGHT-btHeight-space, btWidth, btHeight)];
        [_saveButton setTitle:@"save" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _saveButton.backgroundColor = kSGMTDGrayColor;
        [self.view addSubview:_saveButton];
        
        _addButton = [[UIButton alloc]initWithFrame:CGRectMake(SGMTDSCREENWIDTH-3*(btWidth+space), SGMTDSCREENHEIGHT-btHeight-space, btWidth, btHeight)];
        [_addButton setTitle:@"add" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.backgroundColor = kSGMTDGrayColor;
        [self.view addSubview:_addButton];
        
        _undoButton = [[UIButton alloc]initWithFrame:CGRectMake(space, SGMTDSCREENHEIGHT-btHeight-space, bt_w, btHeight)];
        [_undoButton setTitle:@"⬅︎" forState:UIControlStateNormal];
        [_undoButton addTarget:self action:@selector(undoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _undoButton.enabled = NO;
        _undoButton.backgroundColor = kSGMTDGrayColor;
        [_undoButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_undoButton setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
        [self.view addSubview:_undoButton];
        
        _redoButton = [[UIButton alloc]initWithFrame:CGRectMake(space+(bt_w+space), SGMTDSCREENHEIGHT-btHeight-space, bt_w, btHeight)];
        [_redoButton setTitle:@"➡︎" forState:UIControlStateNormal];
        [_redoButton addTarget:self action:@selector(redoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _redoButton.enabled = NO;
        _redoButton.backgroundColor = kSGMTDGrayColor;
        [_redoButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_redoButton setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
        [self.view addSubview:_redoButton];
        
        
    }
    
    [self.view addSubview:self.deleteArea];
    
}

#pragma mark undomanager action

- (void)updateZoomScale {
    
    CGFloat minX = self.backScrollView.bounds.size.width * 0.5 / self.backScrollView.contentSize.width * self.backScrollView.zoomScale;
    CGFloat minY = self.backScrollView.bounds.size.height * 0.5 / self.backScrollView.contentSize.height * self.backScrollView.zoomScale;
    self.backScrollView.minimumZoomScale = MIN(minX, minY);
    self.backScrollView.maximumZoomScale = 8;
    
    if (self.backScrollView.zoomScale < self.backScrollView.minimumZoomScale) {
        self.backScrollView.zoomScale = self.backScrollView.minimumZoomScale;
    }
}

- (void)updateCanvasViewFrame:(CGSize)resultSize {
    self.backScrollView.contentSize = CGSizeMake(resultSize.width, resultSize.height);
    self.drawView.frame = CGRectMake(0, 0, resultSize.width, resultSize.height);
}


#pragma mark 保存
-(void)saveButtonAction:(UIButton *)button{
    
    [_drawView saveData];
}

#pragma mark 清空
-(void)clearButtonAction:(UIButton *)button{
    
    [_drawView clearView];
    self.undoButton.enabled = NO;
    self.redoButton.enabled = NO;
    [self reDrawView];
    [self reFreshScrollowView];
}
//清空scrollowView位置信息
-(void)reFreshScrollowView{
    _backScrollView.zoomScale = 1.0;
    _backScrollView.frame = CGRectMake(0, 64, SGMTDSCREENWIDTH, kSGMTDScrollowViewHeight);
    _backScrollView.contentSize = CGSizeMake(SGMTDSCREENWIDTH, kSGMTDScrollowViewHeight);
}

//清空画板位置信息
-(void)reDrawView{
    _drawView.zoomScale = 1.0;
    _drawView.frame = CGRectMake(0, 0, SGMTDSCREENWIDTH-2*kSGMTDScrollowViewContentInset, kSGMTDScrollowViewHeight-kSGMTDScrollowViewContentInset*2);
}

#pragma mark 开始编辑 （角度）
-(void)editButtonAction:(UIButton *)button{
    
//    __weak typeof(self) weakSelf = self;
//    if (!_editView) {
//        _editView = [[SelfDefineView alloc]initWithFrame:CGRectMake(0, -74, SGMTDSCREENWIDTH, 74)];
//        _editView.backgroundColor = [UIColor yellowColor];
//        [self.view addSubview:_editView];
//        [_editView show];
//        _editView.changeTranform = ^(CGFloat value) {
//            [weakSelf changSelectViewByValue:value];
//        };
//
//    }else{
//        [_editView dismissSelf];
//        _editView = nil;
//    }
}

-(void)changSelectViewByValue:(CGFloat)value{
    
}

#pragma mark 添加发电板编辑页面
-(void)addButtonAction:(UIButton *)button{
 
    __weak typeof(self) weakSelf = self;
    if (!_addView) {
        _addView = [[SGMTDDrawAddView alloc]initWithFrame:CGRectMake(SGMTDSCREENWIDTH, 120, (kItemWidth+2*kLeftSpace), (7 * (kItemHeiht + kTopSpace)+kTopSpace))];
        _addView.backgroundColor = kSGMTDLightGrayColor;
        [self.view addSubview:_addView];
        [_addView show];
        _addView.addTypeBlock = ^(MastermindItemKindType tag) {
            [weakSelf addViewByType:tag];
            weakSelf.addView = nil;
        };
        
    }else{
        [_addView dismissSelf];
        _addView = nil;
    }
    
    
}

-(void)addViewByType:(NSInteger)kindtype{
    _backScrollView.zoomScale = 1.0;
    //
    MastermindItemHVType type = 0;
    NSInteger row = 1;
    NSInteger column = 1;
    CGFloat rotation = arc4random_uniform(0);
    
    CGFloat maxX = self.view.bounds.size.width*0.3;
    CGFloat maxY = self.view.bounds.size.height*0.3;
    CGPoint position = CGPointMake(arc4random_uniform(maxX)+10, arc4random_uniform(maxY)+30);
    //
    if (kindtype == ItemTypeFourG) {
        [self addGroupLayerByRow:row column:column type:type kindType:kindtype rotationDegrees:rotation position:position];
        
    }else if (kindtype == ItemTypeLogger){
        [self addGroupLayerByRow:row column:column type:type kindType:kindtype rotationDegrees:rotation position:position];
        
    }else if (kindtype == ItemTypeOneTwo){
        
        column = 2;
        type = arc4random_uniform(2) % 2 == 0;
        [self addGroupLayerByRow:row column:column type:type kindType:kindtype rotationDegrees:rotation position:position];
        
    }else if (kindtype == ItemTypeOneEight){
        
        column = 8;
        type = arc4random_uniform(2) % 2 == 0;
        [self addGroupLayerByRow:row column:column type:type kindType:kindtype rotationDegrees:rotation position:position];
        
    }else if (kindtype == ItemTypeIntellect){
        
        __weak typeof(self) weakSelf = self;
        
//                //        测试 1000以上
//                for (int i=0; i<2; i++) {
//                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//                        NSInteger time = arc4random_uniform(5);
//                        NSLog(@"%ld",time);
//                        NSLog(@"i__%d",i);
//                        [NSThread sleepForTimeInterval:0.1*time];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            for (int j=0; j<3; j++) {
//                                NSLog(@"j__%d",j);
//                                CGFloat maxX = self.view.bounds.size.width*0.5;
//                                CGFloat maxY = self.view.bounds.size.height;
//                                CGPoint position = CGPointMake(arc4random_uniform(maxX)+50, arc4random_uniform(maxY)+30);
//                                NSInteger row = 15;//arc4random_uniform(2);
//                                NSInteger column = 15;
//                                [weakSelf addGroupLayerByRow:row column:column type:type kindType:kindtype rotationDegrees:rotation position:position];
//
//                            }
//                        });
//                    });
//                }
        
//        //        测试二 240-480左右
//
//                for (int j=0; j<30; j++) {
//
//                    CGFloat maxX = self.view.bounds.size.width*0.5;
//                    CGFloat maxY = self.view.bounds.size.height;
//                    CGPoint position = CGPointMake(arc4random_uniform(maxX)+50, arc4random_uniform(maxY)+30);
//                    NSInteger row = arc4random_uniform(2);
//                    NSInteger column = 8;
//                    [weakSelf addGroupLayerByRow:row column:column type:type kindType:kindtype rotationDegrees:rotation position:position];
//                }
         
        
//        正式
//        row = arc4random_uniform(7) + 3;
//        column = arc4random_uniform(7) + 3;

        SGMTDDrawEditView *editView = [[SGMTDDrawEditView alloc]initWithFrame:CGRectMake(0, SGMTDSCREENHEIGHT, SGMTDSCREENWIDTH, kDefineViewHeight)];
        [self.view addSubview:editView];
        editView.backgroundColor = kSGMTDLightGrayColor;
        [editView show];
        editView.compeleteConfigBlock = ^(NSInteger row, NSInteger column, MastermindItemHVType type, CGFloat rotationDegrees) {
            [weakSelf addGroupLayerByRow:row column:column type:type kindType:kindtype rotationDegrees:rotationDegrees position:position];
        };
        
        
    }else if (kindtype == ItemTypeInverter){
        
        [self addGroupLayerByRow:row column:column type:type kindType:kindtype rotationDegrees:rotation position:position];
        
    }else if (kindtype == ItemTypeTurnOffController){
        
        [self addGroupLayerByRow:row column:column type:type kindType:kindtype rotationDegrees:rotation position:position];
        
    }else{}
    
}

-(void)addGroupLayerByRow:(NSInteger)row column:(NSInteger)column type:(MastermindItemHVType)type kindType:(MastermindItemKindType)kindType rotationDegrees:(CGFloat)rotationDegrees position:(CGPoint)position{
    
    [self.drawView addGroupLayerRow:row column:column type:type  kindType:kindType rotationDegrees:rotationDegrees position:position];
    [self updateUndoEnable];
}


#pragma mark scrollowView 的scale 给画板
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scale = scrollView.zoomScale;
//    _drawView.scale = scale;
//    NSLog(@"scale--%.3f--",scale);
}

#pragma mark 返回scrollview上面需要所放的view
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    //    CGFloat currentScale = scrollView.zoomScale;
    return self.drawView;
}


- (void)updateUndoEnable {
    
    self.undoButton.enabled = [self.drawView canUndo];
    self.redoButton.enabled = [self.drawView canRedo];
}


//
-(void)undoButtonAction:(UIButton *)bt{
    
    [self.drawView undoAction];
    
    bt.enabled = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:0.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            bt.enabled = YES;
            [self updateUndoEnable];
        });
    });
    
}
//
-(void)redoButtonAction:(UIButton *)bt{
    
    [self.drawView redoAction];
    bt.enabled = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:0.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            bt.enabled = YES;
            [self updateUndoEnable];
        });
    });
}


@end
