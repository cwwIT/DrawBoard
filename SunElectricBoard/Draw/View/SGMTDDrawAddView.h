//
//  CWAddView.h
//  ElectricBoards
//
//  Created by sungrow on 2019/9/2.
//  Copyright © 2019 CWW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGDrawHead.h"
#import "SGMTDDrawEditView.h"

#define kDismissTime 0.3
#define kItemWidth 54
#define kItemHeiht 40
#define kTopSpace 5
#define kLeftSpace 5

typedef void(^AddTypeBlock)(MastermindItemKindType tag);


NS_ASSUME_NONNULL_BEGIN

@interface SGMTDDrawAddView : UIView

@property (nonatomic,copy) AddTypeBlock addTypeBlock;

-(void)show;
-(void)dismissSelf;

@end

NS_ASSUME_NONNULL_END
