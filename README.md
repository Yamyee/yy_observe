- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *person = [[Person alloc]init];
    
    person.name = @"nut";
    person.age = 2;
    [person yy_addObserveForKeyPath:@"name" block:^(id  _Nonnull object, NSString * _Nonnull keyPath, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change, void * _Nonnull context) {
       
        NSLog(@"%@ = %@",keyPath,change[NSKeyValueChangeNewKey]);
    }];
    
    [person yy_addObserveForKeyPath:@"age" block:^(id  _Nonnull object, NSString * _Nonnull keyPath, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change, void * _Nonnull context) {
        
        NSLog(@"%@ = %@",keyPath,change[NSKeyValueChangeNewKey]);
    }];

    person.name = @"ace";
    person.age = 22;
        
    [[NSNotificationCenter defaultCenter]postNotificationName:SayHello object:person];
    [[NSNotificationCenter defaultCenter]postNotificationName:KillMySelf object:person];
}
