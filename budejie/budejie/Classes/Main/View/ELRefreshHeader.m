//
//  ELRefreshHeader.m
//  budejie
//
//  Created by Soul Ai on 29/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELRefreshHeader.h"

@implementation ELRefreshHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置状态文字颜色
        self.stateLabel.textColor = [UIColor magentaColor];
        self.stateLabel.font = [UIFont systemFontOfSize:17];
        [self setTitle:@"下拉刷新~~" forState:MJRefreshStateIdle];
        [self setTitle:@"松开🐴上刷新" forState:MJRefreshStatePulling];
        [self setTitle:@"稍等会儿...正在刷新" forState:MJRefreshStateRefreshing];
        self.backgroundColor = [UIColor whiteColor];
        // 隐藏时间
        self.lastUpdatedTimeLabel.hidden = NO;
        // 自动切换透明度
        self.automaticallyChangeAlpha = YES;
    }
    return self;
}

@end
