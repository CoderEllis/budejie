//
//  UITextField+Placeholder.m
//  budejie
//
//  Created by Soul Ai on 25/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "UITextField+Placeholder.h"
#import <objc/message.h>//runtime

@implementation UITextField (Placeholder)

+ (void)load {//runtime 交换方法一次
    // setPlaceholder
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setEL_PlaceholderMethod = class_getInstanceMethod(self, @selector(setEL_Placeholder:));
    method_exchangeImplementations(setPlaceholderMethod, setEL_PlaceholderMethod);
}


//实现 占位文字颜色  //set
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    // 给成员属性赋值 runtime给系统的类添加成员属性
    // 添加成员属性
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
}

//get方法.
- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, @"placeholderColor");
}


// 设置占位文字&颜色
- (void)setEL_Placeholder:(NSString *)placeholder {
    [self setEL_Placeholder:placeholder];
//    self.placeholder = placeholder;
    self.placeholderColor = self.placeholderColor;
}



@end
