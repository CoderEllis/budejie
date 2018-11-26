//
//  UIImage+image.m
//  budejie
//
//  Created by Soul Ai on 21/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "UIImage+image.h"

@implementation UIImage (image)
+ (UIImage *)imageOriginalwhitName:(NSString *)imageName {
    UIImage * image = [UIImage imageNamed:imageName];
    return   [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
