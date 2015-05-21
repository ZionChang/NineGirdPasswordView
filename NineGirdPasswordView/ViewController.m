//
//  ViewController.m
//  NineGirdPasswordView
//
//  Created by archerzz on 15/5/21.
//  Copyright (c) 2015年 archerzz. All rights reserved.
//

#import "ViewController.h"
#import "ZHPasswordView.h"
#import "UIAlertView+Blocks.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ZHPasswordView *passwordView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.passwordView settingWithSuccessCallBack:^(NSArray *passwordNumberArray, int time) {
        if (time == 1) {
            NSMutableString *string = [NSMutableString stringWithString:@"密码为"];
            for (NSNumber *number in passwordNumberArray) {
                [string appendFormat:@"%d ", number.intValue];
            }
            self.tipLabel.text = string;
        } else if (time == 2) {
            UIAlertView * alertView = [UIAlertView alertWithTitle:@"提示" message:@"绘制成功" block:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [self.passwordView resetPassword];
                }
            } cancelButtonTitle:@"重置" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
        
    } failCallBack:^(NSString *reason) {
        UIAlertView * alertView = [UIAlertView alertWithTitle:@"提示" message:reason block:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];

}


@end
