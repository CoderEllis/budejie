//
//  UIView+Frame.h
//  budejie
//
//  Created by Soul Ai on 21/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*
 写分类:避免跟其他开发者产生冲突,加前缀
 */

@interface UIView (Frame)

+ (instancetype)el_viewFromXib;
@property CGFloat el_width;
@property CGFloat el_height;
@property CGFloat el_x;
@property CGFloat el_y;
@property CGFloat el_centerX;
@property CGFloat el_centerY;

@end

NS_ASSUME_NONNULL_END
