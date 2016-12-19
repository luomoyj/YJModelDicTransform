//
//  TestModel.m
//  YJModelDicTransform
//
//  Created by d-engine on 16/12/15.
//  Copyright © 2016年 yangjun. All rights reserved.
//

#import "TestModel.h"
#import "NSObject+YJModelDicTransform.h"

@implementation TestModel

+ (NSDictionary *)yj_objectClassInArray
{
    return @{@"arrUsers":@"UserModel"};
}

+ (NSDictionary *)yj_propertykeyReplacedWithValue
{
    return @{@"_id":@"id"};
}

@end

@implementation UserModel


@end