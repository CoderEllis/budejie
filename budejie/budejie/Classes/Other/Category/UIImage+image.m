//
//  UIImage+image.m
//  budejie
//
//  Created by Soul Ai on 21/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "UIImage+image.h"

@implementation UIImage (image)

/** 返回原图 */
+ (instancetype)imageOriginalwhitName:(NSString *)imageName {
    UIImage * image = [UIImage imageNamed:imageName];
    return   [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/** 返回一张圆形图 */
- (instancetype)el_circleImage {
    // 1.开启图形上下文
    // 比例因素:当前点与像素比例c  opaque不透明的
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 2.描述裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置裁剪区域;
    [path addClip];
    //4.画图片
    [self drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图像上下文
    UIGraphicsEndImageContext();
    return image;
}

/** 返回一张圆形图 */
+ (instancetype)el_circleImageImageNamed:(NSString *)name {
    return [[self imageNamed:name] el_circleImage];
}

@end
