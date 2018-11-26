//
//  ELLoginRegisterView.m
//  budejie
//
//  Created by Soul Ai on 24/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELLoginRegisterView.h"

@interface ELLoginRegisterView ()

@property (weak, nonatomic) IBOutlet UIButton *loginRegisterButton;
@end

@implementation ELLoginRegisterView

// 越复杂的界面,封装 有特殊效果界面,也需要封装
//instancetype 实例化
+ (instancetype)loginView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+ (instancetype)registerView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *image = _loginRegisterButton.currentBackgroundImage;
    image = [image stretchableImageWithLeftCapWidth:image.size.width *0.5 topCapHeight:image.size.height *0.5];
    // 让按钮背景图片不要被拉伸
    [_loginRegisterButton setBackgroundImage:image forState:UIControlStateNormal];
}


@end
