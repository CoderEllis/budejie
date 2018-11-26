//
//  UIBarButtonItem+Item.m
//  budejie
//
//  Created by Soul Ai on 21/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)

+ (UIBarButtonItem *)itemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(nullable id)target action:(nullable SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];//9.0 之后可以不用包装成 uiview
//    [containView addSubview:btn];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)itemWithimage:(UIImage *)image selImage:(UIImage *)selImage target:(nullable id)target action:(nullable SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)backItemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(nullable id)target ation:(nullable SEL)action title:(NSString *)title {
    UIButton *backImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [backImage setTitle:title forState:UIControlStateNormal];
    [backImage setImage:image forState:UIControlStateNormal];
    [backImage setImage:highImage forState:UIControlStateHighlighted];
    [backImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backImage setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backImage sizeToFit];
    [backImage setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backImage addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:backImage];
}

@end
