//
//  NSObject+KVO.h
//  runtimeDemo
//
//  Created by ShiTou on 2018/11/16.
//  Copyright © 2018年 suncheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVO)
-(void)ZX_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options
              context:(void *)context;
@end

NS_ASSUME_NONNULL_END
