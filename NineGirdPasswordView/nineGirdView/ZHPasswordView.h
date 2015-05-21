//
//  ZHLockView.h
//  九宫格
//
//  Created by archerzz on 15/5/20.
//  Copyright (c) 2015年 archerzz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZHSuccessCallBack)(NSArray *passwordNumberArray, int time);
typedef void(^ZHFailCallBack)(NSString *reason);

@interface ZHPasswordView : UIView

@property (nonatomic, assign) NSInteger numberOfPassword; // 默认为4;

- (instancetype)initWithFrame:(CGRect)frame
              successCallBack:(ZHSuccessCallBack)successCallBack
                 failCallBack:(ZHFailCallBack)failCallBack;

- (void)settingWithSuccessCallBack:(ZHSuccessCallBack)successCallBack
                      failCallBack:(ZHFailCallBack)failCallBack;

/**
 *  重置密码
 */
- (void)resetPassword;

@end
