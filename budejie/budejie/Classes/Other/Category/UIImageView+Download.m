//
//  UIImageView+Download.m
//  budejie
//
//  Created by Soul Ai on 29/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "UIImageView+Download.h"
#import <AFNetworkReachabilityManager.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>


@implementation UIImageView (Download)

- (void)el_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholder:(nullable UIImage *)placeholder completed:(nullable SDExternalCompletionBlock)completedBlock {
    
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 根据网络状态来加载图片
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originImageURL];
    if (originImage) {// 原图已经被下载过
        [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completedBlock];
    }else{// 原图并未下载过
        if (mgr.isReachableViaWiFi){
            [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completedBlock];
        }else if(mgr.isReachableViaWWAN){
            // #warning downloadOriginImageWhen3GOr4G配置项的值需要从沙盒里面获取
            // 3G\4G网络下时候要下载原图
            BOOL downloadOriginImageWhen3GOr4G = YES;
            if (downloadOriginImageWhen3GOr4G) {
                [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completedBlock];
            }else{
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL]placeholderImage:placeholder completed:completedBlock];
            }
            
        }else { // 没有可用网络
            UIImage *thumbnailImage  = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageURL];
            if (thumbnailImage) { // 缩略图已经被下载过
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder completed:completedBlock];
            }else{ // 没有下载过任何图片
                // 占位图片;
                [self sd_setImageWithURL:nil placeholderImage:placeholder completed:completedBlock];
            }
        }
    }
    
    
}




/** 设置圆形头像 */
- (void)el_setHeader:(NSString *)headerUrl {
    UIImage *placeholder = [UIImage el_circleImageImageNamed:@"defaultUserIcons"];//处理下载失败的默认图片
    [self sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:placeholder options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // 图片下载失败，直接返回，         options:SDWebImageCacheMemoryOnly  这个缓存到内存中  不会写到沙盒
        if (!image) return;
        self.image = [image el_circleImage];
    }];
    
}
@end
