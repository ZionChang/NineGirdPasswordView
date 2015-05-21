//
//  ZHButtonView.h
//  九宫格
//
//  Created by archerzz on 15/5/20.
//  Copyright (c) 2015年 archerzz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZHButtonView : UIButton
// 设置当前下标 (0 - 8)
@property (nonatomic, assign) NSInteger currentIndex;
// 设置角度
@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, assign, getter=isCorrectConnetion) BOOL correctConnection;

/**
 *  清空角度并且隐藏角标视图
 */
- (void)zeroAngle;

@end
