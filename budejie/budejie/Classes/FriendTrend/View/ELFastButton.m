//
//  ELFastButton.m
//  budejie
//
//  Created by Soul Ai on 25/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELFastButton.h"

@implementation ELFastButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置图片位置
    self.imageView.el_y = 0;
    self.imageView.el_centerX = self.el_width * 0.5;
    
    //设置标题的位置
    self.titleLabel.el_y = self.el_height - self.titleLabel.el_height;
    
    // 计算文字宽度 , 设置label的宽度
    [self.titleLabel sizeToFit];
    
    self.titleLabel.el_centerX = self.el_width * 0.5;
    
}

@end
