//
//  UIView+DefaultColor.m
//  runtimeDemo
//
//  Created by ShiTou on 2018/11/15.
//  Copyright © 2018年 suncheng. All rights reserved.
//

#import "UIView+DefaultColor.h"
#import "objc/runtime.h"


@implementation UIView (DefaultColor)

static char kDefaultColorKey;

- (void)setDefaultColor:(UIColor *)defaultColor{
    
    //
    objc_setAssociatedObject(self, &kDefaultColorKey, defaultColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


- (UIColor *)defaultColor{
    
    return objc_getAssociatedObject(self, &kDefaultColorKey);
    
}


@end
