//
//  ZHLockView.m
//  九宫格
//
//  Created by archerzz on 15/5/20.
//  Copyright (c) 2015年 archerzz. All rights reserved.
//

#import "ZHPasswordView.h"
#import "ZHButtonView.h"

@import CoreFoundation;

static CGFloat const btnCount = 9;
static CGFloat const btnW = 74;
static CGFloat const btnH = 74;
static int const columnCount = 3;

static BOOL isRefresh = NO;

// 当前第一次
static int currentIndex = 1;
// 延迟时间
static CGFloat delayTime = 0;

// 当前屏幕宽度
#define KScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ZHPasswordView ()

// 当前选中的按钮
@property (nonatomic, strong) NSMutableArray *selectedBtns;
// 当前坐标
@property (nonatomic, assign) CGPoint currentPoint;
// 第一次选中密码
@property (nonatomic, strong) NSMutableArray *firstPasswordNumberArray;
// 第二次选中密码
@property (nonatomic, strong) NSMutableArray *secondPasswordNumberArray;
// 成功回调
@property (nonatomic, copy) ZHSuccessCallBack successCallBack;
// 失败回调
@property (nonatomic, copy) ZHFailCallBack failCallBack;


@end


@implementation ZHPasswordView


- (instancetype)initWithFrame:(CGRect)frame
              successCallBack:(ZHSuccessCallBack)successCallBack
                 failCallBack:(ZHFailCallBack)failCallBack {
    if (self = [super initWithFrame:frame]) {
        self.successCallBack = successCallBack;
        self.failCallBack = failCallBack;
        [self initializeUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self initializeUserInterface];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeUserInterface];
    }
    return self;
}

- (void)settingWithSuccessCallBack:(ZHSuccessCallBack)successCallBack failCallBack:(ZHFailCallBack)failCallBack {
    self.successCallBack = successCallBack;
    self.failCallBack = failCallBack;
}

- (void)initializeUserInterface {
    self.numberOfPassword = 4;
    CGFloat height = 0;
    CGFloat margin = (KScreenWidth - columnCount * btnW) / (columnCount + 1);
    for (int i = 0; i < btnCount; i++) {
        int row = i / columnCount;
        int column = i % columnCount;
        CGFloat btnX = margin + column * (btnW + margin);
        CGFloat btnY = row * (btnW + margin);
        height = btnH + btnY;
        ZHButtonView *button = [[ZHButtonView alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        button.userInteractionEnabled = NO;
        button.currentIndex = i + 1;
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        [self addSubview:button];
    }

}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.selectedBtns.count == 0) {
        return;
    }
    // 绘制贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 2;
    path.lineJoinStyle = kCGLineJoinRound;
    if (delayTime == 0) {
        [[UIColor colorWithRed:0.125 green:0.839 blue:0.996 alpha:0.500] set];
    } else {
        [[UIColor colorWithRed:0.606 green:0.105 blue:0.172 alpha:1.000] set];
    }
    
    [path moveToPoint:[[self.selectedBtns firstObject] center]];
    for (int i = 1; i < self.selectedBtns.count; i++) {
        ZHButtonView *button = self.selectedBtns[i];
        ZHButtonView *preButton = self.selectedBtns[i - 1];
        CGPoint startPoint = preButton.center;
        CGPoint endPoint = button.center;
        CGFloat angle = [self angleInCoordinateSystemWithPoint:startPoint endPoint:endPoint];
        // 判断是否为空
        if (!isnan(angle)) {
            preButton.angle = angle;
        }
        [path addLineToPoint:endPoint];
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
    if (isRefresh) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            delayTime = 0;
            isRefresh = NO;
            [self setButtonBackgroundImage];
            [self resetSelectedBtns];
        });
        
    }
}


/**
 *  计算真实坐标系中的角度
 *
 *  @param startPoint 开始点
 *  @param endPoint   结束点
 *
 *  @return 角度
 */
- (CGFloat)angleInCoordinateSystemWithPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGFloat x = endPoint.x - startPoint.x;
    CGFloat y = endPoint.y - startPoint.y;
    CGFloat angle = ABS(atan(x / y));
    // 默认就是右上方（包括右和上）所以只需要判断其他的方向即可
    
    if (x == 0 && y > 0) {
        // 判断下方
        angle += M_PI;
    } else if (y == 0 && x < 0) {
        // 判断左方
        angle += M_PI;
    } else if (x > 0 && y > 0) {
        // 判断右下方
        angle = M_PI - angle;
    } else if (x < 0 && y > 0) {
        // 判断左下方
        angle = angle + M_PI;
    } else if (x < 0 && y < 0) {
        // 判断左上方
        angle = M_PI * 2 - angle;
    }
    
    return angle;
    
}

- (void)resetPassword {
    currentIndex = 1;
    self.firstPasswordNumberArray = nil;
    self.secondPasswordNumberArray = nil;
}

#pragma mark - private methods

/**
 *  获取touches中触控点
 *
 *  @param touches touches集合
 *
 *  @return 触控点
 */
- (CGPoint)pointWithTouch:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return point;
}

/**
 *  根据当前点获取按钮
 *
 *  @param point 触控点
 *
 *  @return 按钮
 */
- (ZHButtonView *)buttonWithPoint:(CGPoint)point {
    for (ZHButtonView *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}

/**
 *  根据touches添加button到数组，并且返回当前触控点
 *
 *  @param touches 手势集合
 *
 *  @return 当前触控点，如果添加button成功，则返回0
 */
- (CGPoint)addButtonWithTouches:(NSSet *)touches {
    CGPoint point = [self pointWithTouch:touches];
    ZHButtonView *button = [self buttonWithPoint:point];
    if (button && !button.selected) {
        button.selected = YES;
        [self.selectedBtns addObject:button];
        
        if (currentIndex == 1) {
            [self.firstPasswordNumberArray addObject:@(button.currentIndex)];
        } else {
            [self.secondPasswordNumberArray addObject:@(button.currentIndex)];
        }
        
        return CGPointZero;
    }
    return point;
}

#pragma mark - 判断手势密码

/**
 *  判断绘制数量是否足够
 *
 *  @return 只需要判断一个数组即可
 */
- (BOOL)judgeNumberIsEnough {
    if (_firstPasswordNumberArray && _firstPasswordNumberArray.count  < self.numberOfPassword) {
        [self.firstPasswordNumberArray removeAllObjects];
        return NO;
    }
    return YES;
}

/**
 *  判断两个数组的值是否相同
 *
 *  @return 如果第二个数组不存在,则直接返回YES
 */
- (BOOL)judgeNumberIsSame {
    // 如果第二个数组都不存在，就没必要比较
    if (!_secondPasswordNumberArray) {
        return YES;
    }
    // 第二个数组存在 并且相同
    if (_secondPasswordNumberArray && [self.firstPasswordNumberArray isEqualToArray:self.secondPasswordNumberArray]) {
        return YES;
    }
    [self.secondPasswordNumberArray removeAllObjects];
    return NO;
}

/**
 *  设置按钮背景图片
 */
- (void)setButtonBackgroundImage {
    
    for (ZHButtonView *button in self.selectedBtns) {
        if (isRefresh) {
            button.correctConnection = NO;
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateSelected];
        } else {
            button.correctConnection = YES;
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        }
    }
}

#pragma mark - Touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self addButtonWithTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint currentPoint = [self addButtonWithTouches:touches];
    
    if (!CGPointEqualToPoint(currentPoint, CGPointZero)) {
        self.currentPoint = currentPoint;
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (![self judgeNumberIsEnough]) {
        NSString *failString = [NSString stringWithFormat:@"至少连接%ld个点,请重新输入", (long)self.numberOfPassword];
        if (self.failCallBack) {
            self.failCallBack(failString);
        }
    } else{
        if (currentIndex == 1) {
            self.successCallBack(self.firstPasswordNumberArray, currentIndex);
        }
        if (![self judgeNumberIsSame]) {
            NSString *failString = @"与上次绘制不一样,请重新绘制";
            isRefresh = YES;
            delayTime = 0.3;
            [self setButtonBackgroundImage];
            if (self.failCallBack) {
                self.failCallBack(failString);
            }
        } else {
            if (currentIndex == 2 && self.successCallBack) {
                self.successCallBack(self.firstPasswordNumberArray, currentIndex);
            }
            currentIndex = 2;
        }
        
    }
    [self setNeedsDisplay];
    if (!isRefresh) {
        [self resetSelectedBtns];
    }
   
   
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)resetSelectedBtns {
    // 取消数组中所有元素的选中状态
    [self.selectedBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    // 让所有角标图片隐藏并且恢复
    [self.selectedBtns makeObjectsPerformSelector:@selector(zeroAngle)];
    [self.selectedBtns removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark - lazy init

- (NSMutableArray *)selectedBtns {
    if (!_selectedBtns) {
        _selectedBtns = [[NSMutableArray alloc] init];
    }
    return _selectedBtns;
}

- (NSMutableArray *)firstPasswordNumberArray {
    if (!_firstPasswordNumberArray) {
        _firstPasswordNumberArray = [[NSMutableArray alloc] init];
    }
    return _firstPasswordNumberArray;
}

- (NSMutableArray *)secondPasswordNumberArray {
    if (!_secondPasswordNumberArray) {
        _secondPasswordNumberArray = [[NSMutableArray alloc] init];
    }
    return _secondPasswordNumberArray;
}



@end
