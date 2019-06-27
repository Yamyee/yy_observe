//
//  Person.m
//  Object-CTest
//
//  Created by YAMYEE on 2019/6/27.
//  Copyright © 2019 Zhongshan bear. All rights reserved.
//

#import "Person.h"
#import "NSObject+yy_observe.h"
@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self) {

        [self observeNotification];
    }
    return self;
}

-(void)observeNotification{
    
    [self yy_addObserveForNotification:SayHello object:nil block:^(NSNotification * _Nonnull notification) {
        
        NSLog(@"Person:Hello world!");
    }];
    
    [self yy_addObserveForNotification:KillMySelf object:nil block:^(NSNotification * _Nonnull notification) {
        
        id object = notification.object;
        object = nil;
        NSLog(@"I kill myself");
    }];
    
    
}

@end
