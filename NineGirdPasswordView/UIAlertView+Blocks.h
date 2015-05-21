//
//  UIAlertView+Blocks.h
//  动态绑定
//
//  Created by zz on 15/3/2.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewBlock)(NSInteger buttonIndex);

@interface UIAlertView (Blocks)

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message block:(UIAlertViewBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@property (nonatomic, copy) UIAlertViewBlock block;

@end
