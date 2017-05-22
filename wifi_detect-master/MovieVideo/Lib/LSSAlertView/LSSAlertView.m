//
//  LSSAlertView.m
//  LSSAlertView
//
//  Created by MS on 16/5/11.
//  Copyright © 2016年 LSS. All rights reserved.
//

#import "LSSAlertView.h"

#define LAVSCREEN [UIScreen mainScreen].bounds
#define LAVSCREENW [UIScreen mainScreen].bounds.size.width
#define LAVSCREENH [UIScreen mainScreen].bounds.size.height
#define RGBa(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//默认宽度
#define LAVWIDTH LAVSCREENW - 120
///各个栏目之间的距离
#define LAVSPACE 10.0
@interface LSSAlertView()
//根window
@property (nonatomic) UIWindow *rootWindow;
//弹窗
@property (nonatomic) UIView *alertView;
//title,默认为一行，多行还未做
@property (nonatomic) UILabel *titleLabel;
//内容
@property (nonatomic) UIButton *button1;
//确认按钮
@property (nonatomic) UIButton *button2;
//取消按钮
@property (nonatomic) UIButton *cancleBtn;
///闲的记录一下高度吧
@property (nonatomic) CGFloat alertHeight;
@end
@implementation LSSAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)button1 sureBtn:(NSString *)button2 cancleBtn:(NSString *)cancleBtn{
    if (self == [super init]) {
        self.frame = LAVSCREEN;
        self.backgroundColor = [UIColor colorWithWhite:.7 alpha:.7];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 10.0;
        if (title) {
            
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,10,LAVWIDTH, 30)];
            self.titleLabel.text = title;
            self.tintColor = [UIColor colorWithRed:83.0/255 green:71.0/255 blue:65.0/255 alpha:1];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.titleLabel];
        }
        
        if (button1) {
            
            self.button1 = [UIButton buttonWithType:UIButtonTypeSystem];
            self.button1.frame = CGRectMake((LAVWIDTH - 180)/2, CGRectGetMaxY(self.titleLabel.frame) + LAVSPACE, 180, 40);
            self.button1.backgroundColor = kMainScreenColor;
            [self.button1 setTitle:button1 forState:UIControlStateNormal];
            [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.button1.tag = 0;
            [self.button1 addTarget:self action:@selector(buttonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.button1];
            
        }
        if (button2) {
            self.button2 = [UIButton buttonWithType:UIButtonTypeSystem];
            self.button2.frame = CGRectMake((LAVWIDTH - 180)/2, CGRectGetMaxY(self.button1.frame) + LAVSPACE, 180, 40);
            self.button2.backgroundColor = kMainScreenColor;
            [self.button2 setTitle:button2 forState:UIControlStateNormal];
            [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.button2.tag = 1;
            [self.button2 addTarget:self action:@selector(buttonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.button2];
        }
        if(cancleBtn){
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake((LAVWIDTH - 180)/2, CGRectGetMaxY(self.button2.frame) + LAVSPACE, 180, 40);
            self.cancleBtn.backgroundColor = RGBa(200, 200, 200, 1);
            [self.cancleBtn setTitle:cancleBtn forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.cancleBtn.tag = 2;
            [self.cancleBtn addTarget:self action:@selector(buttonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.cancleBtn];
        }
        self.alertHeight = 60 + CGRectGetHeight(self.titleLabel.frame)+CGRectGetHeight(self.button1.frame)+CGRectGetHeight(self.button2.frame)+CGRectGetHeight(self.cancleBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, LAVWIDTH, self.alertHeight);
        [self addSubview:self.alertView];
    }
    return self;
}
#pragma mark - 弹出 -
- (void)showAlertView{
    
    self.rootWindow = [UIApplication sharedApplication].keyWindow;
    [self.rootWindow addSubview:self];
    ///创建动画
    [self creatShowAnimation];
}
- (void)creatShowAnimation{
    
    CGPoint startPoint = CGPointMake(self.frame.size.height, -self.alertHeight);
    self.alertView.layer.position = startPoint;
    self.alertView.layer.position = self.center;

}
#pragma mark - 点击按钮的回调 -
- (void)buttonBeClicked:(UIButton *)button{
    if (self.returnIndex) {
        self.returnIndex(button.tag);
    }
    [self removeFromSuperview];
}



@end
