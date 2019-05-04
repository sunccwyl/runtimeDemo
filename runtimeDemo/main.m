//
//  main.m
//  runtimeDemo
//
//  Created by ShiTou on 2018/11/15.
//  Copyright © 2018年 suncheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSLog(@"1");
        int a =  UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        NSLog(@"2");
        return a;
    }
}
