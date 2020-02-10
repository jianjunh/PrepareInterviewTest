//
//  Person.m
//  PrepareInterView
//
//  Created by junjian_h@163.com on 2020/2/9.
//  Copyright © 2020年 junjian_h@163.com. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)setName:(NSString *)name {
    _name = [name copy];
    _anotherName = @"111";
}

- (void)willChangeValueForKey:(NSString *)key {
    NSLog(@"willChangeValueForKey - begin");
    [super willChangeValueForKey:key];
    NSLog(@"willChangeValueForKey - end");
}

- (void)didChangeValueForKey:(NSString *)key {
    NSLog(@"didChangeValueForKey - begin");
    [super didChangeValueForKey:key];
    NSLog(@"didChangeValueForKey - end");
}

- (void)showMyName {
    
}

+ (void)showCount {
    
}
@end
