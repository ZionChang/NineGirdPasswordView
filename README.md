##介绍

仿支付宝手势密码

只需要导入ZHPasswordView即可,公开方法

```objc
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
```

##联系


个人博客:[archerzz](http://www.archerzz.ninja)

邮箱:eilianlove@gmail.com