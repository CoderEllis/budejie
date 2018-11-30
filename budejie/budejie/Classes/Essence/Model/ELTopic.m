//
//  ELTopic.m
//  budejie
//
//  Created by Soul Ai on 29/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELTopic.h"

@implementation ELTopic

//计算 cell 的高度
- (CGFloat)cellHeight {
     // 如果已经计算过，就直接返回
    if (_cellHeight) return _cellHeight;
    // 文字的Y值
    _cellHeight += 55;
    
    CGSize textMaxsize = CGSizeMake(ScreenWidth - ELMarin *2, MAXFLOAT);
    // 文字的高度
    _cellHeight += [self.text boundingRectWithSize:textMaxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + ELMarin;
    
    //中间内容
    if (self.type != ELTopicTypeWord) {
        /*
         self.width     middleW  //将要显示的宽 和高
         ----------- == -------
         self.height    middleH
         
         self.width * middleH == middleW * self.height
         */
        CGFloat middleW = textMaxsize.width;
        CGFloat middleH = middleW * self.height / self.width;
        if (middleH >= ScreenWidth) {// 显示的图片高度超过一个屏幕，就是超长图片
            middleH = ScreenWidth - ELMarin *2;
            self.bigPicture = YES;
        }
        CGFloat middleY = _cellHeight;
        CGFloat middleX = ELMarin;
//        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);//按比例缩放
//        _cellHeight += middleH + ELMarin;
        
        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleW);
        _cellHeight += middleW + ELMarin;
    }
    // 最热评论
    if (self.top_cmt.count) {
        // 标题
        _cellHeight += 21;
        //内容
        NSDictionary *cmt = self.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        
        NSString *username = cmt[@"user"][@"username"];
        NSString *cmtText = [NSString stringWithFormat:@"%@ : %@",username, content];
        _cellHeight += [cmtText boundingRectWithSize:textMaxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height + ELMarin;
        
    }
    
    // 工具条
    _cellHeight  += 35 + ELMarin;
    
    return _cellHeight;
}


@end
