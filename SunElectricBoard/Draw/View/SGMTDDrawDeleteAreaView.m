//
//  PVDeleteArea.m
//  PVEdit
//
//  Created by sungrow on 2019/8/28.
//  Copyright © 2019 yuqiang. All rights reserved.
//

#import "SGMTDDrawDeleteAreaView.h"

@implementation SGMTDDrawDeleteAreaView
#pragma mark - lazy

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    if (buttonType == UIButtonTypeCustom) {
        return [[SGMTDDrawDeleteAreaView alloc] init];
    }
    return [super buttonWithType:buttonType];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createView];
}

#pragma mark - view
- (void)createView {
    
    self.userInteractionEnabled = NO;
    [self setTitle:NSLocalizedString(@"拖到这删除", @"") forState:UIControlStateNormal];
    [self setTitleColor:UIColor.redColor forState:UIControlStateNormal];
}

#pragma mark - action
- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
}

@end
