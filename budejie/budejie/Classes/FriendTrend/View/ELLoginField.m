//
//  ELLoginField.m
//  budejie
//
//  Created by Soul Ai on 25/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELLoginField.h"
#import "UITextField+Placeholder.h"

@implementation ELLoginField

- (void)awakeFromNib {
    [super awakeFromNib];
    // 监听文本框编辑: 1.代理 2.通知 3.target
    // 原则:不要自己成为自己代理
    
    // 设置光标的颜色为白色
    self.textColor = [UIColor purpleColor];
    self.tintColor = [UIColor whiteColor];
    //开始编辑  颜色
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    
    //结束编辑  颜色
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    //方法一
    //    NSMutableDictionary  *attrs = [NSMutableDictionary dictionary];
    //    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    //    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    
    //方法二
    //断点调试类 拿到 key设置
    //    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    //    placeholderLabel.textColor = [UIColor redColor];
    
    
    // 获取占位文字控件
    self.placeholderColor = [UIColor redColor];
    // 快速设置占位文字颜色 => 文本框占位文字可能是label => 验证占位文字是label => 拿到label => 查看label属性名(1.runtime 2.断点)
    
}


- (void)textBegin {
    self.placeholderColor = [UIColor yellowColor];
}

- (void)textEnd {
    self.placeholderColor = [UIColor redColor];
}


@end
