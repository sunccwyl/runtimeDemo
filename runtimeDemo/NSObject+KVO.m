//
//  NSObject+KVO.m
//  runtimeDemo
//
//  Created by ShiTou on 2018/11/16.
//  Copyright © 2018年 suncheng. All rights reserved.
//

#import "NSObject+KVO.h"
#import "objc/runtime.h"
#import "objc/message.h"

@implementation NSObject (KVO)

-(void)ZX_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options
              context:(void *)context{
    
        //先去获取旧的类名
    NSString * oldClassName = NSStringFromClass([self class]);
        //先去构建新的类名
    NSString * name = [@"NSZX_" stringByAppendingString:oldClassName];
        //获得新的类名
    const char * newClassName = [name UTF8String];
        //创建新的一个类
    Class newClass = objc_allocateClassPair([self class], newClassName, 0);
    
    
    
    // 1. 检查对象的类有没有相应的 setter 方法。如果没有抛出异常
    SEL setterSelector = NSSelectorFromString([self setterForGetter:keyPath]);
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    const char *types = method_getTypeEncoding(setterMethod);
    //我们需要去添加一个setter的方法
    class_addMethod(newClass, setterSelector, (IMP)zx_setter, types);
    
    
    
    //注册这个类
    objc_registerClassPair(newClass);
    
    //修改被观察者的isa的指针，指向我们定义的类
    object_setClass(self, newClass);
    
    //要先去动态的去绑定observer，因为我们需要在下面中去取到observer
    objc_setAssociatedObject(self, @"key", observer, OBJC_ASSOCIATION_RETAIN);
  
    
}

static void zx_setter(id self,SEL _cmd,id newValue)
{
    
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = [self getterForSetter:setterName];
    
    
    //获取当前的类型
    id class = [self class];
    
    //去修改当前的对象的isa的指向，让其指向父类
    object_setClass(self, class_getSuperclass([self class]));
    
    /*调用父类的setName的方法，因为如果这里不调用的话，那么我们在ZX_addObserver中已经修改了类的指向，而且下面的方法已经被实现，
     所以不会去调用父类的setName方法*/
    objc_msgSend(self, _cmd,newValue);
    
    //然后拿出观察者
    id observer = objc_getAssociatedObject(self, @"key");
    
    //通知外界
    objc_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:),self,getterName,@{@"newString":newValue},nil);
    //改回成子类的类型
    object_setClass(self, class);
    
    
}


#pragma mark - 私有方法

/**
 *  根据getter方法名返回setter方法名
 */
- (NSString *)setterForGetter:(NSString *)key
{
    // name -> Name -> setName:
    
    // 1. 首字母转换成大写
    unichar c = [key characterAtIndex:0];
    NSString *str = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%c", c-32]];
    
    // 2. 最前增加set, 最后增加:
    NSString *setter = [NSString stringWithFormat:@"set%@:", str];
    
    return setter;
    
}

/**
 *  根据setter方法名返回getter方法名
 */
- (NSString *)getterForSetter:(NSString *)key
{
    // setName: -> Name -> name
    
    // 1. 去掉set
    NSRange range = [key rangeOfString:@"set"];
    
    NSString *subStr1 = [key substringFromIndex:range.location + range.length];
    
    // 2. 首字母转换成大写
    unichar c = [subStr1 characterAtIndex:0];
    NSString *subStr2 = [subStr1 stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%c", c+32]];
    
    // 3. 去掉最后的:
    NSRange range2 = [subStr2 rangeOfString:@":"];
    NSString *getter = [subStr2 substringToIndex:range2.location];
    
    return getter;
}




@end
