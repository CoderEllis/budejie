//
//  ELTopicPictureView.m
//  budejie
//
//  Created by Soul Ai on 29/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELTopicPictureView.h"
#import "ELTopic.h"
#import <UIImageView+WebCache.h>
#import "ELSeeBigPictureViewController.h"

@interface ELTopicPictureView()

@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureBtn;

@end

@implementation ELTopicPictureView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES; //启用用户交互
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}


/**
 *  查看大图
 */
- (void)seeBigPicture {
    ELSeeBigPictureViewController *vc = [[ELSeeBigPictureViewController alloc] init];
    vc.topic = self.topic;
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)setTopic:(ELTopic *)topic {
    _topic = topic;
    
    self.placeholderView.hidden = NO;
    [self.imageView el_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:[UIImage imageNamed:@"XIACenM"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) return;
        self.placeholderView.hidden = YES;
        // 处理超长图片的大小
        if (self.imageView.image) {
            CGFloat imageW = topic.middleFrame.size.width;
            CGFloat imageH = imageW *topic.height / topic.width;
            
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
        }
        
        
    }];
    // gif
    self.gifView.hidden = !topic.is_gif; //如果服务器有数据返回图片类型这么判断
    
//        if ([topic.image1.lowercaseString hasSuffix:@"gif"]) { //hasSuffix 后缀
//        if ([topic.image1.pathExtension.lowercaseString isEqualToString:@"gif"]) {
//            self.gifView.hidden = NO;
//        } else {
//            self.gifView.hidden = YES;
//          }
//        }
    
    // 点击查看大图
    if (topic.isBigPicture) {
        self.seeBigPictureBtn.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;//内容模式
        self.imageView.clipsToBounds = YES;
    } else {
        self.seeBigPictureBtn.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
    
    
}



@end
