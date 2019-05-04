//
//  NSArray+Boundary.m
//  runtimeDemo
//
//  Created by ShiTou on 2018/11/15.
//  Copyright © 2018年 suncheng. All rights reserved.
//

#import "NSArray+Boundary.h"
#import "objc/runtime.h"


@implementation NSArray (Boundary)

//这个方法会在NSArray加载进内存时调用一次


+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
        Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(safe_ObjectAtIndex:));
        method_exchangeImplementations(fromMethod, toMethod);
    
    });
}


-(id)safe_ObjectAtIndex:(NSUInteger)index{
    
    if (self.count-1 < index) {
        // 这里做一下异常处理，不然都不知道出错了。
        @try {
            return [self safe_ObjectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息，方便我们调试。
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    } else {
        return [self safe_ObjectAtIndex:index];
    }
    
}


@end
