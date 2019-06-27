//
//  Person.h
//  Object-CTest
//
//  Created by YAMYEE on 2019/6/27.
//  Copyright © 2019 Zhongshan bear. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *KillMySelf = @"KillMySelf";
static NSString *SayHello = @"SayHello";
@interface Person : NSObject
@property (nonatomic,strong)NSString        *name;
@property (nonatomic,assign)NSInteger       age;

@end

NS_ASSUME_NONNULL_END
