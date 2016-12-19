//
//  NSObject+YJModelDicTransform.h
//  YJModelDicTransform
//
//  Created by d-engine on 16/12/15.
//  Copyright © 2016年 yangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YJModelDicTransform <NSObject>

@optional

/**
 *  数组中存储的类型
 *
 *  @return key --- 属性名,  value --- 数组中存储的类型
 */
+ (NSDictionary *)yj_objectClassInArray;

/**
 *  替换一些字段
 *
 *  @return key -- 模型中的字段， value --- 字典中的字段
 */
+ (NSDictionary *)yj_propertykeyReplacedWithValue;

@end

@interface NSObject (YJModelDicTransform)<YJModelDicTransform>

+ (instancetype)yj_initWithDictionary:(NSDictionary *)dic;
+ (instancetype)yj_initWithArray:(NSArray *)arr;

@end
