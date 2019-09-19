//
//  SelfDefineView.m
//  PVEdit
//
//  Created by sungrow on 2019/9/4.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGMTDDrawEditView.h"
 

@interface SGMTDDrawEditView ()<UIPickerViewDelegate,UIPickerViewDataSource>

//选择行列数量
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) NSInteger column;
//旋转角度
@property (nonatomic,strong) UISlider *mySlider;
@property (nonatomic,assign) CGFloat rotation;
//横竖
@property (nonatomic,strong) UIButton *HBt;
@property (nonatomic,strong) UIButton *VBt;
@property (nonatomic,strong) UIButton *selectBt;
@property (nonatomic,assign) MastermindItemHVType type;
//取消，确定
@property (nonatomic,strong) UIButton *sureBt;
@property (nonatomic,strong) UIButton *cancleBt;
//@property (nonatomic,strong) UILabel *rowNumberLb;
//@property (nonatomic,strong) UILabel *sectionNumberLb;
//行列数量 数组
@property (nonatomic,strong) NSArray *rowTitles;
@property (nonatomic,strong) NSArray *columnTitles;

@end

@implementation SGMTDDrawEditView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configData];
        [self createSubView];
    }
    return self;
}


-(void)configData{
    
    _type = 0;
    _row = 1;
    _column = 1;
    _rotation = 0.0f;
    //限制一次性最多可以建电板数量
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i=1; i<16; i++) {
        [mutableArray addObject:@(i)];
    }
    _rowTitles = [NSArray arrayWithArray:(NSArray *)mutableArray];
    _columnTitles = [NSArray arrayWithArray:(NSArray *)mutableArray];
    
}

-(void)createSubView{
    
    CGFloat left = 20;
    CGFloat top = 20;
    CGFloat W = self.frame.size.width;
    CGFloat H = self.frame.size.height;
    CGFloat w = W - left * 2;
    CGFloat btW = 50;
    CGFloat btH = 40;
    CGFloat lbW = w/2.0;
    CGFloat space = 10;
    CGFloat y = top;
    
    if (!_HBt) {
        _HBt = [[UIButton alloc]initWithFrame:CGRectMake(left, y, btW, btH)];
        [_HBt setTitle:@"水平" forState:UIControlStateNormal];
        _HBt.backgroundColor = kSGMTDBlueColor;
        _HBt.layer.masksToBounds = YES;
        _HBt.layer.cornerRadius = 5;
        [_HBt addTarget:self action:@selector(HBtAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_HBt];
        _selectBt = _HBt;
        
        _VBt = [[UIButton alloc]initWithFrame:CGRectMake(left+btW+space, y, btW, btH)];
        [_VBt setTitle:@"竖直" forState:UIControlStateNormal];
        _VBt.backgroundColor = kSGMTDDarkGrayColor;
        _VBt.layer.masksToBounds = YES;
        _VBt.layer.cornerRadius = 5;
        [_VBt addTarget:self action:@selector(VBtAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_VBt];
        
        _cancleBt = [[UIButton alloc]initWithFrame:CGRectMake(SGMTDSCREENWIDTH-2*(btW+space), y, btW, btH)];
        [_cancleBt setTitle:@"取消" forState:UIControlStateNormal];
        _cancleBt.backgroundColor = kSGMTDDarkGrayColor;
        _cancleBt.layer.masksToBounds = YES;
        _cancleBt.layer.cornerRadius = 5;
        [_cancleBt addTarget:self action:@selector(cancleConfigAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancleBt];
        //
        _sureBt = [[UIButton alloc]initWithFrame:CGRectMake(SGMTDSCREENWIDTH-(btW+space), y, btW, btH)];
        [_sureBt setTitle:@"添加" forState:UIControlStateNormal];
        _sureBt.backgroundColor = kSGMTDBlueColor;
        _sureBt.layer.masksToBounds = YES;
        _sureBt.layer.cornerRadius = 5;
        [_sureBt addTarget:self action:@selector(sureConfigAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBt];
    }
    
    y = y + space + btH;
    CGFloat sliderX = left + 50;
    if (!_mySlider) {
        _mySlider = [[UISlider alloc]initWithFrame:CGRectMake(sliderX, y, (W-2*(left+50)), btH)];
        [self addSubview:_mySlider];
        [_mySlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
        _mySlider.maximumValue = 180;
        _mySlider.minimumValue = 0;
        _mySlider.value = 0;
        //
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(left, y, 50, btH)];
        leftLabel.font = [UIFont systemFontOfSize:16];
        leftLabel.text = @"0";
        leftLabel.textAlignment = NSTextAlignmentCenter;
//        leftLabel.backgroundColor = SGMTDRANDOMCOLOR;
        [self addSubview:leftLabel];
        //
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SGMTDSCREENWIDTH-left-50, y, 50, btH)];
        rightLabel.font = [UIFont systemFontOfSize:16];
        rightLabel.text = @"180";
        rightLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:rightLabel];
        
    }
    
    y = y + space + btH;
    if (!_pickerView) {
        //
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(left, y, lbW, btH)];
        leftLabel.font = [UIFont boldSystemFontOfSize:15];
        leftLabel.text = @"选择行数";
//        leftLabel.backgroundColor = SGMTDRANDOMCOLOR;
        leftLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:leftLabel];
        //
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(left+lbW, y, lbW, btH)];
        rightLabel.font = [UIFont boldSystemFontOfSize:15];
        rightLabel.text = @"选择列数";
        rightLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:rightLabel];
        //
        y = y + space + btH;
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, y, W, kPickViewHeight)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = SGMTDRANDOMCOLOR;//kSGMTDLightGrayColor;//kSGMTDBackGroundColor;//
        [self addSubview:_pickerView];
    }
    
    
}

#pragma mark action

-(void)HBtAction{
    _type = 0;
    _selectBt.backgroundColor = kSGMTDDarkGrayColor;
    _selectBt = _HBt;
    _selectBt.backgroundColor = kSGMTDBlueColor;
}

-(void)VBtAction{
    _type = 1;
    _selectBt.backgroundColor = kSGMTDDarkGrayColor;
    _selectBt = _VBt;
    _selectBt.backgroundColor = kSGMTDBlueColor;
}

-(void)sureConfigAction{
    
    if (_compeleteConfigBlock) {
        _compeleteConfigBlock(_row,_column,_type,_rotation);
    }
    [self dismissSelf];
    
}

-(void)cancleConfigAction{
    [self dismissSelf];
}

-(void)sliderChange:(UISlider *)mySlider{
    
    CGFloat value = mySlider.value;
    _rotation = value;
//    NSLog(@"%.2f",value);
}

#pragma mark pickerView delegate,dataSource

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        
        return _rowTitles.count;
        
    }else{
        
        return _columnTitles.count;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *title = @"";
    if (component == 0) {
        
        title = [NSString stringWithFormat:@"%@",_rowTitles[row]];
        return title;
        
    }else{
        
        title = [NSString stringWithFormat:@"%@",_columnTitles[row]];
        return title;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSInteger count = 1;
    
    if (component == 0) {
        
        count = [_rowTitles[row] integerValue];
        _row = count;
        
    }else{
        
        count = [_columnTitles[row] integerValue];
        _column = count;
    }
}

-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SGMTDSCREENHEIGHT-kDefineViewHeight, SGMTDSCREENWIDTH, kDefineViewHeight);
    }];
}

-(void)dismissSelf{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SGMTDSCREENHEIGHT, SGMTDSCREENWIDTH, kDefineViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
