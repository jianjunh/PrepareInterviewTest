//
//  Person.h
//  PrepareInterView
//
//  Created by junjian_h@163.com on 2020/2/9.
//  Copyright © 2020年 junjian_h@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

{
    NSInteger _age;
    NSString *_anotherName;
}
/**
 * 名字
 */
@property (nonatomic,copy) NSString *name;

/**
 * 年龄
 */
@property (nonatomic,assign) NSInteger age;


@end
