//
//  SGDrawItemModel.m
//  SunElectricBoard
//
//  Created by sungrow on 2019/9/7.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGMTDDrawItemModel.h"

@interface SGMTDDrawItemModel ()<NSCoding>
 

@end

@implementation SGMTDDrawItemModel


-(void)setHvType:(MastermindItemHVType)hvType {
    
    if (_hvType != hvType) {
        _hvType = hvType;
    }
}
-(void)setKindType:(MastermindItemKindType)kindType {
    
    if (_kindType != kindType) {
        _kindType = kindType;
    }
}

//每一块电板的横竖 小方格
- (NSInteger)row {
    
    if (self.kindType == ItemTypeFourG || self.kindType == ItemTypeLogger || self.kindType == ItemTypeInverter || self.kindType == ItemTypeTurnOffController) {
        
        return 0;
        
    } else{
        return self.hvType == ItemHVTypeHorizontal ? 5 : 4;
    }
}

//每一块电板的横竖 小方格
- (NSInteger)column {
    
    if (self.kindType == ItemTypeFourG || self.kindType == ItemTypeLogger || self.kindType == ItemTypeInverter || self.kindType == ItemTypeTurnOffController) {
        
        return 0;
        
    } else{
        
        return self.hvType == ItemHVTypeHorizontal ? 3 : 4;
    }
}

- (CGPoint)origin {
    
    return CGPointMake(self.indexPath.row * self.size.width, self.indexPath.section * self.size.height);
}

-(CGSize)size{
    
    if (self.kindType == ItemTypeFourG || self.kindType == ItemTypeLogger || self.kindType == ItemTypeInverter || self.kindType == ItemTypeTurnOffController) {
        
        return CGSizeMake(kSGMTDItemWidth, kSGMTDItemHeiht);
        
    }else if (self.kindType == ItemTypeIntellect || self.kindType == ItemTypeOneTwo || self.kindType == ItemTypeOneEight) {
        
        if (self.hvType == ItemHVTypeHorizontal) {
            
            return CGSizeMake(kSGMTDSqurtWidth*self.row+kSGMTDSqurtSpace, kSGMTDSqurtHeight*self.column+kSGMTDSqurtBlack+kSGMTDSqurtSpace);
        } else {
            return CGSizeMake(kSGMTDSqurtHeight*self.row+kSGMTDSqurtSpace, kSGMTDSqurtWidth*self.column+kSGMTDSqurtBlack+kSGMTDSqurtSpace);
        }
        
    }else{
        
        return CGSizeZero;
    }
    
}

- (CGRect)frame {
    
    return CGRectMake(self.origin.x, self.origin.y, self.size.width, self.size.height);
}


- (id)copyWithZone:(NSZone *)zone {
    SGMTDDrawItemModel *instance = [super copyWithZone:zone];
    return instance;
}
 

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
    [aCoder encodeBool:self.select forKey:@"select"];
    [aCoder encodeBool:self.hidden forKey:@"hidden"];
    [aCoder encodeInteger:self.hvType forKey:@"hvType"];
    [aCoder encodeObject:self.indexPath forKey:@"indexPath"];
    [aCoder encodeInteger:self.kindType forKey:@"kindType"];
    
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    
    self.select = [aDecoder decodeBoolForKey:@"select"];
    self.hidden = [aDecoder decodeBoolForKey:@"hidden"];
    self.hvType = [aDecoder decodeIntegerForKey:@"hvType"];
    self.indexPath = [aDecoder decodeObjectForKey:@"indexPath"];
    self.kindType = [aDecoder decodeIntegerForKey:@"kindType"];
    
    return self;
    
}

- (BOOL)isEqual:(SGMTDDrawItemModel *)object {
    BOOL equal = YES;
    equal = equal && self.select == object.select;
    equal = equal && self.hidden == object.hidden;
    equal = equal && self.hvType == object.hvType;
    equal = equal && [self.indexPath compare:object.indexPath] == NSOrderedSame;
    equal = equal && self.kindType == object.kindType;
    
    return equal;
}






@end
