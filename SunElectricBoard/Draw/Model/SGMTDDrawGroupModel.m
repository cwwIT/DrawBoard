//
//  SGDrawGroupModel.m
//  SunElectricBoard
//
//  Created by sungrow on 2019/9/7.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGMTDDrawGroupModel.h"

@interface SGMTDDrawGroupModel ()<NSCoding>

@end

@implementation SGMTDDrawGroupModel

- (CGFloat)rotationRadians {
    return self.rotationDegrees * M_PI / 180.0;
}

- (NSInteger)row {
    return self.itemModels.count;
}

- (NSInteger)column {
    return self.itemModels.firstObject.count;
}

- (CGSize)itemSize {
    return self.itemModels.firstObject.firstObject.size;
}

- (CGSize)size {
    CGFloat width = self.column * self.itemSize.width;
    CGFloat height = self.row * self.itemSize.height;
    return CGSizeMake(width, height);
}

- (CGPoint)origin {
    return CGPointMake(self.position.x - self.size.width * 0.5, self.position.y - self.size.height * 0.5);
}

- (CGRect)rect {
    return CGRectMake(self.origin.x, self.origin.y, self.size.width, self.size.height);
}

- (CGRect)transformRect {
    CGAffineTransform rotation = CGAffineTransformMakeRotation(self.rotationRadians);
    CGRect centerRect = CGRectMake(
                                   -self.size.width/2.0,
                                   -self.size.height/2.0,
                                   self.size.width,
                                   self.size.height);
    CGRect transformRect = CGRectApplyAffineTransform(centerRect, rotation);
    CGRect resultRect = CGRectMake(
                                   transformRect.origin.x + CGRectGetMidX(self.rect),
                                   transformRect.origin.y + CGRectGetMidY(self.rect),
                                   transformRect.size.width,
                                   transformRect.size.height);
    return resultRect;
}

+ (void)findBorderRectModelInGroupModels:(NSArray <SGMTDDrawGroupModel *>*)groupModels completion:(void (^)(SGMTDDrawGroupModel *minXModel, SGMTDDrawGroupModel *minYModel, SGMTDDrawGroupModel *maxXModel, SGMTDDrawGroupModel *maxYModel))completion {
    
    SGMTDDrawGroupModel *minXModel = groupModels.firstObject;
    SGMTDDrawGroupModel *minYModel = groupModels.firstObject;
    
    SGMTDDrawGroupModel *maxXModel = groupModels.lastObject;
    SGMTDDrawGroupModel *maxYModel = groupModels.lastObject;
    for (SGMTDDrawGroupModel *model in groupModels) {
        minXModel = CGRectGetMinX(model.transformRect) < CGRectGetMinX(minXModel.transformRect) ? model : minXModel;
        minYModel = CGRectGetMinY(model.transformRect) < CGRectGetMinY(minYModel.transformRect) ? model : minYModel;
        
        maxXModel = CGRectGetMaxX(model.transformRect) > CGRectGetMaxX(maxXModel.transformRect) ? model : maxXModel;
        maxYModel = CGRectGetMaxY(model.transformRect) > CGRectGetMaxY(maxYModel.transformRect) ? model : maxYModel;
    }
    !completion ?: completion(minXModel, minYModel, maxXModel, maxYModel);
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
    [aCoder encodeObject:self.itemModels forKey:@"itemModels"];
    [aCoder encodeCGPoint:self.position forKey:@"position"];
    [aCoder encodeFloat:self.rotationDegrees forKey:@"rotationDegrees"];
    [aCoder encodeInteger:self.kindType forKey:@"kindType"];
    [aCoder encodeInteger:self.hvType forKey:@"hvType"];
    
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    
    self.itemModels = [aDecoder decodeObjectForKey:@"itemModels"];
    self.position = [aDecoder decodeCGPointForKey:@"position"];
    self.rotationDegrees = [aDecoder decodeFloatForKey:@"rotationDegrees"];
    self.kindType = [aDecoder decodeIntegerForKey:@"kindType"];
    self.hvType = [aDecoder decodeIntegerForKey:@"hvType"];
    return self;
}

+ (NSArray <SGMTDDrawGroupModel *>*)deepCopyModels:(NSArray <SGMTDDrawGroupModel *>*)models {
    NSArray *deepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:models]];
    return deepCopyArray;
}

- (BOOL)isEqual:(SGMTDDrawGroupModel *)object {
    BOOL equal = YES;
    equal = equal && CGPointEqualToPoint(self.position, object.position);
    equal = equal && self.rotationDegrees == object.rotationDegrees;
    equal = equal && self.kindType == object.kindType;
    equal = equal && self.hvType == object.hvType;
    equal = equal && self.itemModels.count == object.itemModels.count;
    if (equal) {
        for (int i = 0; i < self.itemModels.count && i < object.itemModels.count; i ++) {
            equal = equal && [self.itemModels[i] isEqual:object.itemModels[i]];
            if (!equal) { break; }
        }
    }
    return equal;
}

@end
