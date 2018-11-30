//
//  ELDIYHeader.m
//  budejie
//
//  Created by Soul Ai on 29/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELDIYHeader.h"
@interface ELDIYHeader()

/** 开关 */
@property (nonatomic, weak) UISwitch *kaiguan;
/** logo */
@property (nonatomic, weak) UIImageView *logo;

@end

//重写 自己 DIY 刷新控件
@implementation ELDIYHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UISwitch *kaiguan = [[UISwitch alloc] init];
        [self addSubview:kaiguan];
        self.kaiguan = kaiguan;
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiantou"]];
        [self addSubview:logo];
        self.logo = logo;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.logo.el_x = self.el_width * 0.25;
    self.logo.el_centerY = self.el_height * 0.5;
    self.backgroundColor = [UIColor orangeColor];
    
    self.kaiguan.el_centerX = self.el_width * 0.5;
    self.kaiguan.el_centerY = self.el_height * 0.5;
}

#pragma mark - 重写Header内部的方法
- (void)setState:(MJRefreshState)state {
    [super setState:state];
    
    if (state == MJRefreshStateIdle) {// 下拉可以刷新
        [self.kaiguan setOn:NO animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.kaiguan.transform = CGAffineTransformIdentity;
        }];
    } else if (state == MJRefreshStatePulling) {// 松开立即刷新
        [self.kaiguan setOn:YES animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.kaiguan.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    } else if (state == MJRefreshStateRefreshing) {// 正在刷新
        [self.kaiguan setOn:YES animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.kaiguan.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
}


@end
