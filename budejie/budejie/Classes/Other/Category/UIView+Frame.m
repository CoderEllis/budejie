//
//  UIView+Frame.m
//  budejie
//
//  Created by Soul Ai on 21/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

+ (instancetype)el_viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


//set
- (void)setEl_width:(CGFloat)el_width {
    CGRect rect = self.frame;
    rect.size.width = el_width;
    self.frame = rect;
}
//get
- (CGFloat)el_width {
    return self.frame.size.width;
}

- (void)setEl_height:(CGFloat)el_height {
    CGRect rect = self.frame;
    rect.size.height = el_height;
    self.frame = rect;
}

- (CGFloat)el_height {
    return self.frame.size.height;
}

- (void)setEl_x:(CGFloat)el_x {
    CGRect rect = self.frame;
    rect.origin.x = el_x;
    self.frame =rect;
}

- (CGFloat)el_x {
    return self.frame.origin.x;
}

- (void)setEl_y:(CGFloat)el_y {
    CGRect rect = self.frame;
    rect.origin.y = el_y;
    self.frame = rect;
}

- (CGFloat)el_y {
    return self.frame.origin.y;
}

- (void)setEl_centerX:(CGFloat)el_centerX {
    CGPoint center = self.center;
    center.x = el_centerX;
    self.center = center;
}

- (CGFloat)el_centerX {
    return self.center.x;
}


- (void)setEl_centerY:(CGFloat)el_centerY {
    CGPoint center = self.center;
    center.y = el_centerY;
    self.center = center;
}

- (CGFloat)el_centerY {
    return self.center.y;
}

@end
