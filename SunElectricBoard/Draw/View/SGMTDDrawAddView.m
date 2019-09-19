//
//  CWAddView.m
//  ElectricBoards
//
//  Created by sungrow on 2019/9/2.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGMTDDrawAddView.h" 



@interface SGMTDDrawAddView ()

@property (nonatomic,strong) NSArray *title_array;//
@property (nonatomic,strong) NSArray *type_array;//

@end

@implementation SGMTDDrawAddView

-(void)dealloc{
//    NSLog(@"CWAddView_dismiss!");
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _title_array = @[@"4G",@"logger",@"一拖二",@"一拖八",@"自定义",@"逆变器",@"关断控制器"];
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews{
    
    CGFloat x = kLeftSpace;
    CGFloat y = kTopSpace;
    
    for (int i = 0; i < _title_array.count; i++) {
        
        NSString *title = _title_array[i];
        y = kTopSpace + (kItemHeiht+kTopSpace)*i;
        UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(x, y, kItemWidth, kItemHeiht)];
        [bt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bt setTitle:title forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:12];
        bt.titleLabel.adjustsFontSizeToFitWidth = YES;
        bt.titleLabel.numberOfLines = 0;
        bt.backgroundColor = kSGMTDBlueColor;
        bt.layer.masksToBounds = YES;
        bt.layer.cornerRadius = 3;
        bt.tag = i;
//        bt.backgroundColor = [UIColor colorWithRed:arc4random(255)/255.0 green:arc4random(255)/255.0 blue:arc4random(255)/255.0 alpha:1];
        [self addSubview:bt];
    }
    
}

-(void)buttonClick:(UIButton *)bt{
    
    NSInteger tag = bt.tag;
    
    if (_addTypeBlock) {
        _addTypeBlock(tag);
    }
    [self dismissSelf];
}

-(void)show{
    
    
    [UIView animateWithDuration:kDismissTime animations:^{
        self.frame = CGRectMake(SGMTDSCREENWIDTH-(kItemWidth+2*kLeftSpace), 120, (kItemWidth+2*kLeftSpace), (7 * (kItemHeiht + kTopSpace)+kTopSpace));
    }];
}
-(void)dismissSelf{
    
    [UIView animateWithDuration:kDismissTime animations:^{
        
        self.frame = CGRectMake(SGMTDSCREENWIDTH, 120, (kItemWidth+2*kLeftSpace), (7 * (kItemHeiht + kTopSpace)+kTopSpace));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
