//
//  NSObject+YJModelDicTransform.m
//  YJModelDicTransform
//
//  Created by d-engine on 16/12/15.
//  Copyright © 2016年 yangjun. All rights reserved.
//

#import "NSObject+YJModelDicTransform.h"
#import <objc/runtime.h>
#include <objc/objc.h>

NSString *const YJClassType_object  =   @"对象类型";
NSString *const YJClassType_basic   =   @"基础数据类型";
NSString *const YJClassType_other   =   @"其它";

@implementation NSObject (YJModelDicTransform)

+ (instancetype)yj_initWithDictionary:(NSDictionary *)dic
{
    id myObj = [[self alloc] init];
    
    unsigned int outCount;
    
    //获取类中的所有成员属性
    objc_property_t *arrPropertys = class_copyPropertyList([self class], &outCount);
    
    for (NSInteger i = 0; i < outCount; i ++) {
        objc_property_t property = arrPropertys[i];
        
        //获取属性名字符串
        //model中的属性名
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        //字典中的属性名
        NSString *newPropertyName;
        
        if ([self respondsToSelector:@selector(yj_propertykeyReplacedWithValue)]) {
            newPropertyName = [[self yj_propertykeyReplacedWithValue] objectForKey:propertyName];
        }
        if (!newPropertyName) {
            newPropertyName = propertyName;
        }
        
        NSLog(@"属性名:%@", propertyName);
        
        id propertyValue = dic[newPropertyName];
        if (propertyValue == nil) {
            continue;
        }
        
        //获取属性是什么类型的
        NSDictionary *dicPropertyType = [self propertyTypeFromProperty:property];
        NSString *propertyClassType = [dicPropertyType objectForKey:@"classType"];
        NSString *propertyType = [dicPropertyType objectForKey:@"type"];
        if ([propertyType isEqualToString:YJClassType_object]) {
            if ([propertyClassType isEqualToString:@"NSArray"] || [propertyClassType isEqualToString:@"NSMutableArray"]) {
                //数组类型
                if ([self respondsToSelector:@selector(yj_objectClassInArray)]) {
                    id propertyValueType = [[self yj_objectClassInArray] objectForKey:propertyName];
                    if ([propertyValueType isKindOfClass:[NSString class]]) {
                        propertyValue = [NSClassFromString(propertyValueType) yj_initWithArray:propertyValue];
                    }
                    else {
                        propertyValue = [propertyValueType yj_initWithArray:propertyValue];
                    }
                    
                    if (propertyValue != nil) {
                        [myObj setValue:propertyValue forKey:propertyName];
                    }
                }
                
            }
            else if ([propertyClassType isEqualToString:@"NSDictionary"] || [propertyClassType isEqualToString:@"NSMutableDictionary"]) {
                //字典类型   不考虑，一般不会用字典，用自定义model
                
            }
            else if ([propertyClassType isEqualToString:@"NSString"]) {
                //字符串类型
                if (propertyValue != nil) {
                    [myObj setValue:propertyValue forKey:propertyName];
                }
            }
            else {
                //自定义类型
                propertyValue = [NSClassFromString(propertyClassType) yj_initWithDictionary:propertyValue];
                if (propertyValue != nil) {
                    [myObj setValue:propertyValue forKey:propertyName];
                }
            }
        }
        else if ([propertyType isEqualToString:YJClassType_basic]) {
            if ([propertyValue isKindOfClass:[NSString class]]) {
                propertyValue = [[[NSNumberFormatter alloc] init] numberFromString:propertyValue];
            }
            else {
                
            }
            
            if (propertyValue != nil) {
                [myObj setValue:propertyValue forKey:propertyName];
            }
        }
        else {
            
        }
    }
    
    free(arrPropertys);
    
    return myObj;
}

+ (instancetype)yj_initWithArray:(NSArray *)arr
{
    NSAssert([arr isKindOfClass:[NSArray class]], @"不是数组");
    
    NSMutableArray *arrModels = [NSMutableArray array];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [arrModels addObject:[self yj_initWithArray:obj]];
        }
        else {
            id model = [self yj_initWithDictionary:obj];
            [arrModels addObject:model];
        }
    }];
    return arrModels;
}

- (NSDictionary *)propertyTypeFromProperty:(objc_property_t)property
{
    //获取属性的类型, 类似 T@"NSString",C,N,V_name    T@"UserModel",&,N,V_user
    NSString *propertyAttrs = @(property_getAttributes(property));
    
    NSMutableDictionary *dicPropertyType = [NSMutableDictionary dictionary];
    
    NSRange commaRange = [propertyAttrs rangeOfString:@","];
    NSString *propertyType = [propertyAttrs substringWithRange:NSMakeRange(1, commaRange.location - 1)];
    NSLog(@"属性类型:%@, %@", propertyAttrs, propertyType);
    
    if ([propertyType hasPrefix:@"@"] && propertyType.length > 2) {
        //对象类型
        NSString *propertyClassType = [propertyType substringWithRange:NSMakeRange(2, propertyType.length - 3)];
        [dicPropertyType setObject:propertyClassType forKey:@"classType"];
        [dicPropertyType setObject:YJClassType_object forKey:@"type"];
    }
    else if ([propertyType isEqualToString:@"q"]) {
        [dicPropertyType setObject:@"NSInteger" forKey:@"classType"];
        [dicPropertyType setObject:YJClassType_basic forKey:@"type"];
    }
    else if ([propertyType isEqualToString:@"d"]) {
        [dicPropertyType setObject:@"CGFloat" forKey:@"classType"];
        [dicPropertyType setObject:YJClassType_basic forKey:@"type"];
    }
    else if ([propertyType isEqualToString:@"B"]) {
        [dicPropertyType setObject:@"BOOL" forKey:@"classType"];
        [dicPropertyType setObject:YJClassType_basic forKey:@"type"];
    }
    else {
        [dicPropertyType setObject:YJClassType_other forKey:@"type"];
    }
    return dicPropertyType;
}

@end
