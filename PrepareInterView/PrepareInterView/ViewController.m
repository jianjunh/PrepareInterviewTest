//
//  ViewController.m
//  PrepareInterView
//
//  Created by junjian_h@163.com on 2020/2/9.
//  Copyright © 2020年 junjian_h@163.com. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/objc.h>
#import "Person.h"
#import "Chinese.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person *p1 = [[Person alloc] init];
    Person *p2 = [[Person alloc] init];
    
    Class cls1 = object_getClass(p1);
    Class cls2 = object_getClass(p2);
//    NSLog(@"%@   %@",cls1,cls2);
//    NSLog(@"%@  %@",object_getClass(p1),object_getClass(p2));
    //    SEL sel = @selector(setName:);
//    IMP imp1 = [p1 methodForSelector:sel];
//    IMP imp2 = [p2 methodForSelector:sel];
//    NSLog(@"%p   %p",imp1,imp2);
    [p1 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    cls1 = object_getClass(p1);
    cls2 = object_getClass(p2);
    NSLog(@"%@   %@",cls1,cls2);
    
    NSString *methodList1 = [self printClassMethods:cls1];
    NSString *methodList2 = [self printClassMethods:cls2];

    NSLog(@"%@",methodList1);
    NSLog(@"%@",methodList2);
    //    Class superCls1 = class_getSuperclass(cls1);
//    Class superCls2 = class_getSuperclass(cls2);
//    NSLog(@"super:%@   %@",superCls1,superCls2);
    
//    cls1 = object_getClass(object_getClass(cls1));
//    cls2 = object_getClass(object_getClass(cls2));
    
    BOOL isMeta1 = class_isMetaClass([cls1 class]);
    BOOL isMeta2 = class_isMetaClass([cls2 class]);
//
//    NSLog(@"%@   %@   isMeta:%ld    %ld",cls1,cls2,isMeta1,isMeta2);

    cls1 = object_getClass(cls1);
    cls2 = object_getClass(cls2);

    isMeta1 = class_isMetaClass(cls1);
    isMeta2 = class_isMetaClass(cls2);
    
    NSLog(@"%@   %@   isMeta:%ld    %ld",cls1,cls2,isMeta1,isMeta2);
    
//    NSString *methodList1 = [self printClassMethods:cls1];
    methodList2 = [self printClassMethods:cls2];
    
//    NSLog(@"%@",methodList1);
    NSLog(@"元类方法%@",methodList2);

    NSLog(@"%@  %@",object_getClass(p1),object_getClass(p2));

//    imp1 = [p1 methodForSelector:sel];
//    imp2 = [p2 methodForSelector:sel];
//    NSLog(@"%p   %p",imp1,imp2);
    p1.name = @"111";
    p2.name = @"222";
    p1.age = 10;
    p2.age = 20;
    
//    Chinese *chinese = [[Chinese alloc] init];
//    [chinese didChangeValueForKey:@"1"];
    
    Person *p3 = [[Person alloc] init];
    Class cls3 = object_getClass(p3);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"改变:%@",change[@"new"]);
    
}

- (NSString *)printClassMethods:(Class)cls {
    unsigned int count = 0;
    Method *propertys = class_copyMethodList(cls, &count);
    NSMutableString *methodList = [NSMutableString string];
    [methodList appendString:@"[\n"];
    for (int i = 0; i < count; i++) {
        Method method = propertys[i];
//        NSString *ivarStr = [NSString stringWithUTF8String:property_getName(method)];
        SEL sel = method_getName(method);
        [methodList appendFormat:@"%@",NSStringFromSelector(sel)];
//        [methodList appendFormat:@"%@",ivarStr];

        [methodList appendString:@"\n"];
    }
    [methodList appendString:@"]"];
    free(propertys);
    
    return methodList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
