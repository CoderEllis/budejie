//
//  ELTopicVideoView.m
//  budejie
//
//  Created by Soul Ai on 29/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELTopicVideoView.h"
#import "ELTopic.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>

@interface ELTopicVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UILabel *playcontLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@end

@implementation ELTopicVideoView
/*
 一般情况下，以下这些view的autoresizingMask默认就是18（UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth）
 1.从xib里面创建出来的默认控件
 2.控制器的view
 
 如果不希望控件拥有autoresizingMask的自动伸缩功能，应该设置为none
 autoresizingMask 跟随父控件伸缩
 blueView.autoresizingMask = UIViewAutoresizingNone;
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(ELTopic *)topic {
    _topic = topic;
    
    self.placeholderView.hidden = NO;
    
    [self.imageView el_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) return;
        
        self.placeholderView.hidden = YES;
    }];
    
    
     //播放数量
    if (topic.playcount >= 10000) {
        self.playcontLabel.text = [NSString stringWithFormat:@"%.1f万播放", topic.playcount / 10000.0];
    } else {
        self.playcontLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    }  
    
    // %04d : 占据4位，多余的空位用0填补
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",topic.videotime / 60, topic.videotime % 60];
}




@end
