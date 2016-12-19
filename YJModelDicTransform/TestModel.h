//
//  TestModel.h
//  YJModelDicTransform
//
//  Created by d-engine on 16/12/15.
//  Copyright © 2016年 yangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface TestModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) UserModel *user;

@property (nonatomic, strong) NSArray *arrUsers;

@end


@interface UserModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@end