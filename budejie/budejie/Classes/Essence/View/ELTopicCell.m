//
//  ELTopicCell.m
//  budejie
//
//  Created by Soul Ai on 29/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELTopicCell.h"
#import "ELTopic.h"
#import <UIImageView+WebCache.h>

#import "ELTopicVideoView.h"
#import "ELTopicPictureView.h"
#import "ELTopicVoiceView.h"

@interface ELTopicCell()
// 控件的命名 -> 功能 + 控件类型
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;

@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;
@property (weak, nonatomic) IBOutlet UIButton *repostBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;

/* 中间控件 */
/** 图片控件 */
@property (nonatomic, weak) ELTopicPictureView *pictureView;
/** 声音控件 */
@property (nonatomic, weak) ELTopicVoiceView *voiceView;
/** 视频控件 */
@property (nonatomic, weak) ELTopicVideoView *videoView;
@end


@implementation ELTopicCell

#pragma mark - 懒加载
- (ELTopicPictureView *)pictureView {
    if (!_pictureView) {
        ELTopicPictureView *pictureView = [ELTopicPictureView el_viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (ELTopicVoiceView *)voiceView {
    if (!_voiceView) {
        ELTopicVoiceView *voiceView = [ELTopicVoiceView el_viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (ELTopicVideoView *)videoView {
    if (!_videoView) {
        ELTopicVideoView *videoView = [ELTopicVideoView el_viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
//    self.selectedBackgroundView   选中 cell 时的颜色
}


- (void)setTopic:(ELTopic *)topic {
    _topic = topic;
    // 顶部控件的数据
    [self.profileImageView el_setHeader:topic.profile_image];
    self.nameLabel.text = topic.name;
    self.passTimeLabel.text = topic.passtime;
    self.text_label.text = topic.text;
    
    // 底部按钮的文字
//        if (topic.ding >= 10000){
//            [self.dingButton setTitle:[NSString stringWithFormat:@"%.1f万",topic.ding /10000.0] forState:UIControlStateNormal];
//        }else if (topic.ding > 0){
//            [self.dingButton setTitle:[NSString stringWithFormat:@"%zd",topic.ding] forState:UIControlStateNormal];
//        }else{
//            [self.dingButton setTitle:@"顶" forState: UIControlStateNormal];
//        }
    [self setupButtonTitle:self.zanBtn number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiBtn number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostBtn number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentBtn number:topic.comment placeholder:@"评论"];

    // 最热评论
    if (topic.top_cmt.count) {
        self.topCmtView.hidden = NO;
        NSDictionary *cmt = topic.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) {
            content = @"语音评论";
        } 
        NSString *username = cmt[@"user"][@"username"];
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@", username,content];
    } else {
        self.topCmtView.hidden = YES;
    }
    
    // 中间的内容  不用这个 用懒加载
    /*
     //    if (topic.type ==ELTopicTypePicture) { //图片
     //        [self.contentView addSubview:[ELTopicPictureView el_viewForXib]];
     //    }else if (topic.type == ELTopicTypeVideo){ //视频
     //        [self.contentView addSubview:[ELTopicVideoView el_viewForXib]];
     //    }else if (topic.type == ELTopicTypeVoice){ //声音
     //        [self.contentView addSubview:[ELTopicVoiceView el_viewForXib]];
     //    }else if(topic.type == ELTopicTypeWord){//d段子
     //
     //    }
     */
    if (self.topic.type == ELTopicTypePicture) {//hidden 隐藏 view 防止循环利用
        self.pictureView.hidden = NO;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.topic = topic;
    } else if (self.topic.type == ELTopicTypeVideo) {
        self.pictureView.hidden = YES;
        self.videoView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.topic = topic;
    } else if (self.topic.type == ELTopicTypeVoice) {
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
    } else if (self.topic.type == ELTopicTypeWord) {
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }
    
    
    
}
//布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.topic.type == ELTopicTypePicture) {
        self.pictureView.frame = self.topic.middleFrame;
    } else if (self.topic.type == ELTopicTypeVideo) {
        self.videoView.frame = self.topic.middleFrame;
    } else if (self.topic.type == ELTopicTypeVoice) {
        self.voiceView.frame = self.topic.middleFrame;
    } else if (self.topic.type == ELTopicTypeWord) {
        
    }
}

/*
 [[XMGVideoViewController alloc] init]
 1.XMGVideoViewController.xib
 2.XMGVideoView.xib
 
 报错信息：-[UIViewController _loadViewFromNibNamed:bundle:] loaded the "XMGVideoView" nib but the view outlet was not set.
 错误原因：在使用xib创建控制器view时，并没有通过File's Owner设置控制器的view属性
 解决方案：通过File's Owner设置控制器的view属性为某一个view
 
 报错信息：-[UITableViewController loadView] loaded the "XMGVideoView" nib but didn't get a UITableView.
 错误原因：在使用xib创建UITableViewController的view时，并没有设置控制器的view为一个UITableView
 解决方案：通过File's Owner设置控制器的view属性为一个UITableView
 */

- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder {
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万",number /10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd",number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
} 

//cell 间距 设置
- (void)setFrame:(CGRect)frame {
    
    //    frame.origin.x +=ELMarin;
    //    frame.size.width -= 2 *ELMarin;
    frame.size.height -= 5;
    [super setFrame:frame];
}




@end
