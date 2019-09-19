//
//  SGDrawHead.h
//  SunElectricBoard
//
//  Created by sungrow on 2019/9/7.
//  Copyright © 2019 CWW. All rights reserved.
//

#ifndef SGDrawHead_h
#define SGDrawHead_h



//NS_ASSUME_NONNULL_BEGIN

//不同机型对应的 footer tabar status 高度
#define ISSGMTDIPHONEX ([UIScreen mainScreen].bounds.size.height>800.0f)
#define kMTDTabarNavigationHeight (ISSGMTDIPHONEX ? 88 : 64)
#define kMTDNavigationHeight (ISSGMTDIPHONEX ? 68 : 44)
#define kMTDFooterHeight (ISSGMTDIPHONEX ? 68 : 50)
#define kMTDStatusBarHeight (ISSGMTDIPHONEX ? 44 : 20)

//#pragma mark size

#define SGMTDSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SGMTDSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define kSGMTDScrollowViewHeight (SGMTDSCREENHEIGHT-120)
#define kSGMTDScrollowViewContentInset 20
#define kSGMTDItemWidth 25
#define kSGMTDItemHeiht 25
#define kSGMTDSqurtWidth 6
#define kSGMTDSqurtHeight 4
#define kSGMTDSqurtBlack 4
#define kSGMTDSqurtSpace 2

//#pragma mark color

#define kSGMTDSunWhiteColor SGMTDCOLORBYRGB(0xffffff)
#define kSGMTDBlackColor SGMTDRGB(66, 66, 66)
#define kSGMTDBlueColor SGMTDRGB(115, 195, 245)
#define kSGMTDGreenColor SGMTDRGB(155, 203, 103)
#define kSGMTDDarkGrayColor SGMTDRGB(180, 180, 180)
#define kSGMTDGrayColor SGMTDRGB(205, 205, 205)
#define kSGMTDLightGrayColor SGMTDRGB(235, 235, 235)
#define kSGMTDBackGroundColor SGMTDRGB(250, 250, 250)

#define SGMTDRGBALPA(r, g, b, a)        \
[UIColor colorWithRed:(CGFloat)r/255.0f \
green:(CGFloat)g/255.0f \
blue:(CGFloat)b/255.0f \
alpha:(CGFloat)a]
#define SGMTDRGB(r, g, b)            SGMTDRGBALPA(r, g, b, 1)

#define SGMTDRANDOMCOLOR [UIColor colorWithRed:(arc4random()%255)/256.0 green:(arc4random()%255)/256.0 blue:(arc4random()%255)/256.0 alpha:1]
#define SGMTDRANDOMCOLORALPA(a) [UIColor colorWithRed:(arc4random()%255)/256.0 green:(arc4random()%255)/256.0 blue:(arc4random()%255)/256.0 alpha:a]

#define SGMTDCOLORBYRGBALPA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define SGMTDCOLORBYRGB(rgbValue) SGMTDCOLORBYRGBALPA(rgbValue, 1.0)

//#pragma mark enum

typedef enum : NSUInteger {
    ItemHVTypeHorizontal,
    ItemHVTypeVertical,
}MastermindItemHVType;

typedef enum : NSUInteger {
    ItemTypeFourG = 0,//4G模块
    ItemTypeLogger,//logger
    ItemTypeOneTwo,//一拖二关断器
    ItemTypeOneEight,//一拖八关断器
    ItemTypeIntellect,//智能自定义关断器
    ItemTypeInverter,//逆变器
    ItemTypeTurnOffController,//关断控制器
}MastermindItemKindType;




#endif /* SGDrawHead_h */
