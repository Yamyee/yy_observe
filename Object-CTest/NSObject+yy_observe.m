//
//  NSObject+yy_observe.m
//  Object-CTest
//
//  Created by YAMYEE on 2019/6/27.
//  Copyright © 2019 yamyee. All rights reserved.
//

#import "NSObject+yy_observe.h"
#import <objc/runtime.h>


NSString *yy_observeKeyPathMapKey = @"yy_observeKeyPathMapKey";
NSString *yy_observeNotificationMapKey = @"yy_observeNotificationMapKey";
NSString *yy_addObserveKey = @"yy_addObserveKey";

@interface NSObject()
///监听的keyPath与block映射
@property (nonatomic,strong)NSMutableDictionary<NSString *,yy_keyPathBlock>         *observeKeyPathMap;
///监听的NSNotificationName与block映射
@property (nonatomic,strong)NSMutableDictionary<NSString *,yy_notificationBlock>    *observeNotificationMap;
///防止在yy_dealloc中对未添加监听的对象处理出现野指针错误
@property (nonatomic,assign)BOOL    yy_addObserver;

@end

@implementation NSObject (yy_observe)
-(void)yy_addObserveForNotification:(NSNotificationName )name object:(id)object block:(nonnull yy_notificationBlock)block{
    
    //替换系统的dealloc方法
    [self yy_swizzledDeallocMethod];
    ///回调block与name一一对应
    [self.observeNotificationMap setValue:block forKey:name];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onObserveForNotification:) name:name object:object];
}
-(void)yy_addObserveForKeyPath:(yy_keyPath)keyPath block:(yy_keyPathBlock)block{
    
    //替换系统的dealloc方法
    [self yy_swizzledDeallocMethod];
    ///回调block与keyPath一一对应
    [self.observeKeyPathMap setValue:block forKey:keyPath];
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew;
    
    [self addObserver:self forKeyPath:keyPath options:options context:nil];
}
#pragma mark - observe
-(void)onObserveForNotification:(NSNotification *)notification{
    
    yy_notificationBlock block = self.observeNotificationMap[notification.name];
    if (block) {
        block(notification);
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    yy_keyPathBlock block = self.observeKeyPathMap[keyPath];
    if (block) {
        block(object,keyPath,change,context);
    }
    
}

#pragma mark - swizzling
-(void)yy_swizzledDeallocMethod{

    self.yy_addObserver = YES;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = object_getClass((id)self);
        Method originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"dealloc"));
        Method swizzledMethod = class_getInstanceMethod(class, @selector(yy_dealloc));

        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

-(void)yy_dealloc{
    
    if (self.yy_addObserver) {
        //清除所有监听的keyPath
        for (NSString *keyPath in [self.observeKeyPathMap allKeys]) {
            
            [self removeObserver:self forKeyPath:keyPath];
        }
        
        for (NSString *name in [self.observeNotificationMap allKeys]) {
            [[NSNotificationCenter defaultCenter]removeObserver:self name:name object:nil];
        }
        
        //移除绑定属性
        objc_removeAssociatedObjects(self);
        
        NSLog(@"%@ die",[self class]);
        
    }
    [self yy_dealloc];
}

#pragma mark - setter & getter

-(void)setObserveKeyPathMap:(NSMutableDictionary<NSString *,yy_keyPathBlock> *)observeKeyPathMap{
    
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(yy_observeKeyPathMapKey), observeKeyPathMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary<NSString *,yy_keyPathBlock> *)observeKeyPathMap{
    
    NSMutableDictionary *map =  objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(yy_observeKeyPathMapKey));
    if (map == nil) {
        map = [[NSMutableDictionary alloc]initWithCapacity:42];
        self.observeKeyPathMap = map;
    }
    return map;
}

-(void)setObserveNotificationMap:(NSMutableDictionary<NSString *,yy_notificationBlock> *)observeNotificationMap{
    
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(yy_observeNotificationMapKey), observeNotificationMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary<NSString *,yy_notificationBlock> *)observeNotificationMap{
    
    NSMutableDictionary *map =  objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(yy_observeNotificationMapKey));
    if (map == nil) {
        map = [[NSMutableDictionary alloc]initWithCapacity:42];
        self.observeNotificationMap = map;
    }
    return map;
}
-(void)setYy_addObserver:(BOOL)yy_addObserver{
    
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(yy_addObserveKey), @(yy_addObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)yy_addObserver{
    NSNumber *number = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(yy_addObserveKey));
    return [number boolValue];
}
@end

