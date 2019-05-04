//
//  ViewController.m
//  runtimeDemo
//
//  Created by ShiTou on 2018/11/15.
//  Copyright © 2018年 suncheng. All rights reserved.
//

#import "ViewController.h"
#import "UIView+DefaultColor.h"
#import "NSObject+KVO.h"
#import "Person.h"
#import "objc/runtime.h"


@interface ViewController ()

@property(nonatomic, strong) Person * p;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //关联属性
    UIView *test = [UIView new];
    test.defaultColor = [UIColor blackColor];
    NSLog(@"%@", test.defaultColor);
    
    
    //方法交换，防止数组越界
    NSArray * arr = @[@"1",@"2"];
    NSLog(@"%@", [arr objectAtIndex:2]);

    
    
    //系统kvo
    self.p = [Person new];
    [self.p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    //自定义kvo
//    [self.p ZX_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    
    //获取类的属性列表和方法列表
    unsigned int count;
    Method * methods =  class_copyMethodList([UITextView class], &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL selector =  method_getName(method);
    }
    
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    NSLog(@"数值改变了");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.p.name = @"10";
    
    
     NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(show) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void)show{
    NSLog(@"111");
    
}


@end
