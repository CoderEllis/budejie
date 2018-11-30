//
//  ELTabBar.m
//  budejie
//
//  Created by Soul Ai on 21/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELTabBar.h"

@interface ELTabBar()

@property (nonatomic, weak)UIButton *plusButton;
@property (nonatomic, weak)UIControl *previousClickedTabBarButton;

@end

@implementation ELTabBar

//#warning TODO:发布按钮显示不出来 :这样提示第二天从哪里做事情

- (UIButton *)plusButton {
    if (_plusButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        [self addSubview:btn];
        
        _plusButton = btn;
    }
    return _plusButton;
}

- (void)publish {
    ELFunc;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    // 跳转tabBarButton位置
    NSInteger count = self.items.count;
    CGFloat btnW = self.el_width/ (count +1);
    CGFloat btnH = 49;
    CGFloat x = 0;
    int i = 0;
    
    for (UIControl *tabBarbutton in self.subviews) {
        if ([tabBarbutton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            // 设置previousClickedTabBarButton默认值为最前面的按钮
            if (i == 0 && self.previousClickedTabBarButton == nil) {
                self.previousClickedTabBarButton = tabBarbutton;
            }
            
            
            if (i == 2) {
                i += 1;
            }
            x = i *btnW;
            
            tabBarbutton.frame = CGRectMake(x, 0, btnW, btnH);
            
            i ++;
            // UIControlEventTouchDownRepeat : 在短时间内连续点击按钮
            
            // 监听点击
            [tabBarbutton addTarget:self action:@selector(tabBarButtonChick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.plusButton.center = CGPointMake(self.el_width *0.5, btnH *0.5);
//    NSLog(@"%f,%f",self.EL_width,self.El_heigh);
}

/**
 *  tabBarButton的点击
 */
- (void)tabBarButtonChick: (UIControl *)tabBarButton {
    if (self.previousClickedTabBarButton == tabBarButton) {
        // 发出通知，告知外界tabBarButton被重复点击了
        [[NSNotificationCenter defaultCenter] postNotificationName:ELTabBarButtonDidRepeatClickNotification object:nil];
    }
    self.previousClickedTabBarButton = tabBarButton;
}





@end
