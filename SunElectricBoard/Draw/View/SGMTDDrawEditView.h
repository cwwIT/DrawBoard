//
//  SelfDefineView.h
//  PVEdit
//
//  Created by sungrow on 2019/9/4.
//  Copyright © 2019 CWW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGDrawHead.h"

#define kDefineViewHeight 260
#define kPickViewHeight 90

typedef void(^CompeleteConfigBlock)(NSInteger row, NSInteger column, MastermindItemHVType type, CGFloat rotationDegrees);

NS_ASSUME_NONNULL_BEGIN

@interface SGMTDDrawEditView : UIView

@property (nonatomic,copy) CompeleteConfigBlock compeleteConfigBlock;
 
-(void)show;
-(void)dismissSelf;

@end

NS_ASSUME_NONNULL_END
