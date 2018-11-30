//
//  ELTopicVoiceView.m
//  budejie
//
//  Created by Soul Ai on 29/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELTopicVoiceView.h"
#import "ELTopic.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>


@interface ELTopicVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@end
@implementation ELTopicVoiceView

- (void)awakeFromNib
{
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
    
    if (topic.playcount >= 10000) {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万播放",topic.playcount / 10000.0];
    } else {
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    }
    
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",topic.voicetime / 60, topic.voicetime % 60];
}

@end
