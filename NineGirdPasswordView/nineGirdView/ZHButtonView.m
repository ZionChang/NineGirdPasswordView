//
//  ZHButtonView.m
//  九宫格
//
//  Created by archerzz on 15/5/20.
//  Copyright (c) 2015年 archerzz. All rights reserved.
//

#import "ZHButtonView.h"

@interface ZHButtonView ()

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, assign, getter=isRotate) BOOL rotate;

@end

@implementation ZHButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self initializeUserInterface];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self initializeUserInterface];
    }
    return self;
}

- (void)setCorrectConnection:(BOOL)correctConnection {
    _correctConnection = correctConnection;
    if (_correctConnection) {
        self.arrowImageView.image = [UIImage imageNamed:@"gesture_arrownode_normal"];
    } else {
        self.arrowImageView.image = [UIImage imageNamed:@"gesture_arrownode_wronginput"];
    }
}

- (void)initializeUserInterface {
    
    self.arrowImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
        imageView;
    });
    [self zeroAngle];
}

- (void)setAngle:(CGFloat)angle {
    // 只需要绘制一次
    if (![self isRotate]) {
        _angle = angle;
        _arrowImageView.hidden = NO;
        _arrowImageView.transform = CGAffineTransformRotate(_arrowImageView.transform, angle);
    }
    _rotate = YES;
}

- (void)zeroAngle {
    self.correctConnection = YES;
    _rotate = NO;
    _arrowImageView.hidden = YES;
    _arrowImageView.transform = CGAffineTransformIdentity;
}



@end
