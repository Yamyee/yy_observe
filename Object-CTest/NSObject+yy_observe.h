//
//  NSObject+yy_observe.h
//  Object-CTest
//
//  Created by YAMYEE on 2019/6/27.
//  Copyright © 2019 yamyee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define yy_weakTarget(target) __weak typeof(target) weakTarget = target;
#define yy_strongTarget(target) __strong typeof(target) strongTarget = target;

typedef NSString * yy_keyPath;
typedef void(^yy_keyPathBlock)(id object,NSString *keyPath,NSDictionary<NSKeyValueChangeKey,id> * change,void *context);
typedef void(^yy_notificationBlock) (NSNotification *notification);



@interface NSObject (yy_observe)
///监听keyPath值变化，任何变化都有回调，block对应keyPath，无需在delloc中移除
-(void)yy_addObserveForKeyPath:(yy_keyPath _Nonnull)keyPath block:(yy_keyPathBlock)block;
///监听通知，block对应name，无需在delloc中移除
-(void)yy_addObserveForNotification:(NSNotificationName _Nonnull)name object:(id _Nullable)object block:(yy_notificationBlock)block;

@end

NS_ASSUME_NONNULL_END
