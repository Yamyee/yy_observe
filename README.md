 - (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *person = [[Person alloc]init];
    
    person.name = @"nut";
    person.age = 2;
    
    yy_weakTarget(person)
    
    [person yy_addObserveForKeyPath:@"name" block:^(id  _Nonnull object, NSString * _Nonnull keyPath, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change, void * _Nonnull context) {
    
        yy_strongTarget(weakTarget)
        
        NSLog(@"%@.%@ = %@",[strongTarget class],keyPath,change[NSKeyValueChangeNewKey]);
    }];
    
    [person yy_addObserveForKeyPath:@"age" block:^(id  _Nonnull object, NSString * _Nonnull keyPath, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change, void * _Nonnull context) {
        
        yy_strongTarget(weakTarget)
        
        NSLog(@"%@.%@ = %@",[strongTarget class],keyPath,change[NSKeyValueChangeNewKey]);
    }];

    person.name = @"ace";
    person.age = 22;
        
    [[NSNotificationCenter defaultCenter]postNotificationName:SayHello object:person];
    [[NSNotificationCenter defaultCenter]postNotificationName:KillMySelf object:person];
    
}



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
@end
