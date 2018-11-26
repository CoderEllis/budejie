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


@end

@implementation ELTabBar

//#warning TODO:发布按钮显示不出来 :这样提示第二天从哪里做事情

- (UIButton *)plusButton {
    if (_plusButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [btn sizeToFit];
        [self addSubview:btn];
        
        _plusButton = btn;
    }
    return _plusButton;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    // 跳转tabBarButton位置
    NSInteger count = self.items.count;
    CGFloat btnW = self.el_width/ (count +1);
    CGFloat btnH = 49;
    CGFloat x = 0;
    int i = 0;
    
    for (UIView *tabBarbutton in self.subviews) {
        if ([tabBarbutton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i == 2) {
                i += 1;
            }
            x = i *btnW;
            
            tabBarbutton.frame = CGRectMake(x, 0, btnW, btnH);
            
            i ++;
        }
    }
    
    self.plusButton.center = CGPointMake(self.el_width *0.5, btnH *0.5);
//    NSLog(@"%f,%f",self.EL_width,self.El_heigh);
}






@end
