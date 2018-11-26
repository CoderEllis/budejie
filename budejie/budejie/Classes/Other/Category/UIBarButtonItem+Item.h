//
//  UIBarButtonItem+Item.h
//  budejie
//
//  Created by Soul Ai on 21/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Item)

+ (UIBarButtonItem *)itemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(nullable id)target action:(nullable SEL)action;

+ (UIBarButtonItem *)itemWithimage:(UIImage *)image selImage:(UIImage *)selImage target:(nullable id)target action:(nullable SEL)action;

+ (UIBarButtonItem *)backItemWithimage:(UIImage *)image highImage:(UIImage *)highImage  target:(nullable id)target ation:(nullable SEL)action title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
