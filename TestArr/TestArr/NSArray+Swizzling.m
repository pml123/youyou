//
//  NSArray+Swizzling.m
//  TestArr
//
//  Created by haowin007 on 15/10/2019.
//  Copyright © 2019 LuckyLottery. All rights reserved.
//

#import "NSArray+Swizzling.h"
#import <objc/runtime.h>

@implementation NSArray (Swizzling)

+ (void)load{
    id obj = [[self alloc] init];
    [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(swizzlingObjectAtIndex:)];
    [obj swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(swizzlingObjectAtIndexedSubscript:)];
    [obj swizzleMethod:@selector(removeObjectAtIndex:) withMethod:@selector(swizzlingRemoveObjectAtIndex:)];
    [obj swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(swizzlingInsertObject:atIndex:)];
}

- (instancetype)swizzlingInitWithObjects:(id)firstObj{
    
}

- (id)swizzlingObjectAtIndex:(NSUInteger)index{
    if (index >= self.count) {
        NSLog(@"所取元素超出数组范围");
        return nil;
    }else{
        return [self swizzlingObjectAtIndex:index];
    }
}

- (id)swizzlingObjectAtIndexedSubscript:(NSUInteger)index{
    if (index >= self.count) {
        NSLog(@"所取元素超出数组范围");
        return nil;
    }else{
        return [self swizzlingObjectAtIndexedSubscript:index];
    }
}

- (void)swizzlingRemoveObjectAtIndex:(NSUInteger)index{
    if (index >= self.count) {
        NSLog(@"移除元素超出吧数组吧范围");
    }else{
        [self swizzlingRemoveObjectAtIndex:index];
    }
}

- (void)swizzlingInsertObject:(id)anObject atIndex:(NSUInteger)index{
    if (!anObject) {
        NSLog(@"插入数据不能为空");
    }else{
        [self swizzlingInsertObject:anObject atIndex:index];
    }
    
}

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzleMethod = class_getInstanceMethod(class, newSelector);
    BOOL didAddMethod = class_addMethod(class, origSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}


@end
