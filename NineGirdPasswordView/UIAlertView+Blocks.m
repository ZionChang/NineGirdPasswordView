//
//  UIAlertView+Blocks.m
//  动态绑定
//
//  Created by zz on 15/3/2.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>


// 两个C语言字符串常量
static const void * AlertViewBlockKey = "ZZAlertViewKey";
static const void * AlertViewDelegateKey = "ZZAlertViewDelegateKey";

@implementation UIAlertView (Blocks)

+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                         block:(UIAlertViewBlock)block
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    NSString *other = nil;
    // 读取其他参数
    // 获取参数列表
    va_list args;
    if (otherButtonTitles) {
        // 准备开始读取
        va_start(args, otherButtonTitles);
        while ((other = va_arg(args, NSString*))) {
            // 循环添加其他标题
            [alertView addButtonWithTitle:other];
        }
        // 结束当前读取
        va_end(args);
    }
    // 将block赋值给alertView
    alertView.block = block;
    // 判断ARC和非ARC
#if !__has_feature(objc_arc)
    return [alertView autorelease];
#else
    return alertView;
#endif
}





- (void)checkAlertViewDelegate
{
    // 判断当前代理人是否等于self
    if (self.delegate != (id<UIAlertViewDelegate>)self) {
        // 如果不等
        // 进行动态添加一个Delegate
        objc_setAssociatedObject(self, AlertViewDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        //设置自己为自己的代理，并且遵守这个协议
        self.delegate = (id<UIAlertViewDelegate>)self;
    }
    
}

- (void)setBlock:(UIAlertViewBlock)block
{
    [self checkAlertViewDelegate];
    // 动态添加block作为self的属性
    objc_setAssociatedObject(self, AlertViewBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewBlock)block
{
    // 动态获取当前block
    return objc_getAssociatedObject(self, AlertViewBlockKey);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertViewBlock block = self.block;
    // 利用block执行
    if (block) {
        block(buttonIndex);
    }
    // 动态获取代理
    id originalDelegate = objc_getAssociatedObject(self, AlertViewDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [originalDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}


@end
