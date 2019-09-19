//
//  PVBaseModel.m
//  PVEdit
//
//  Created by sungrow on 2019/9/2.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGMTDDrawBaseModel.h"
#import <objc/runtime.h>

@interface SGMTDDrawBaseModel () 

@end

@implementation SGMTDDrawBaseModel

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    u_int count;
    objc_property_t *properties  = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        /// 获取当前property 是否有有绑定对应的成员变量, 如果没有, 就不能使用 setValue:ForKey:
        objc_property_t property = properties[i];
        char *attrName = "V";
        char *value = property_copyAttributeValue(property, attrName);
        if (value != NULL) {
            /// 当前属性已有对应的成员变量 则使用 KVC 赋值
            const char *char_f = property_getName(properties[i]);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            id propertyValue = [[self valueForKey:(NSString *)propertyName] copy];
            if (propertyValue) {
                [copy setValue:propertyValue forKey:propertyName];
            }
        }
    }
    free(properties);
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        const char* char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [[self valueForKey:(NSString *)propertyName] copy];
        if (propertyValue) {
            [copy setValue:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return copy;
}

@end
