//
//  ViewController.m
//  YJModelDicTransform
//
//  Created by d-engine on 16/12/15.
//  Copyright © 2016年 yangjun. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"
#import "NSObject+YJModelDicTransform.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"字典转模型";
    
    NSDictionary *dicTest = @{@"id":@"121",
                              @"name":@"张三",
                              @"phone":@"110",
                              @"age":@"10",
                              @"user":@{@"userId":@"2"},
                              @"arrUsers":@[@{@"userId":@"2"},@{@"userId":@"2"},@{@"userId":@"2"}]};
    TestModel *model = [TestModel yj_initWithDictionary:dicTest];
    NSLog(@"model-----id:%@, name:%@, phone:%@, address:%@, age:%@, userId:%@, userName:%@", model._id, model.name, model.phone, model.address, @(model.age), model.user.userId, model.user.userName);
    [model.arrUsers enumerateObjectsUsingBlock:^(UserModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"arrUser----userId:%@", obj.userId);
    }];
    
//    TestModel *model2 = [[TestModel alloc] init];
//    [model2 setValuesForKeysWithDictionary:dicTest];
//    NSLog(@"model2-----name:%@, phone:%@, address:%@, age:%@, userId:%@", model2.name, model2.phone, model2.address, @(model2.age), model2.user.userId);
}

@end
