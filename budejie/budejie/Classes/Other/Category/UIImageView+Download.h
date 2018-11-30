//
//  UIImageView+Download.h
//  budejie
//
//  Created by Soul Ai on 29/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Download)

- (void)el_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholder:(nullable UIImage *)placeholder completed:(nullable SDExternalCompletionBlock)completedBlock;


- (void)el_setHeader:(NSString *)headerUrl;
@end

NS_ASSUME_NONNULL_END
