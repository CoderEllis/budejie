//
//  ELSubTagCell.m
//  budejie
//
//  Created by Soul Ai on 23/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELSubTagCell.h"
#import "ELSubTagItem.h"
#import "UIImageView+WebCache.h"

@interface ELSubTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *numView;

@end


@implementation ELSubTagCell

-(void)setFrame:(CGRect)frame {
//    ELLog(@"%@",NSStringFromCGRect(frame)); 把 cell 高度-1 做分割线
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (void)setItem:(ELSubTagItem *) item {
    _item = item;
    _nameView.text = item.theme_name;
    [self resolveNum];
    
//    [_iconView  sd_setImageWithURL:[NSURL URLWithString:item.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] options:SDWebImageFromCacheOnly completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        [path addClip];
        [image drawAtPoint:CGPointZero];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self->_iconView.image = image;
    }];
    
    
    
}

// 处理订阅数字
- (void)resolveNum {
    NSString *numStr = [NSString stringWithFormat:@"%@人订阅", _item.sub_number];
    NSInteger num = _item.sub_number.integerValue;
    if (num > 10000) {
        CGFloat numf = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万人订阅",numf];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];//去除整数万后面的.0
    }
    _numView.text = numStr;
}

// 处理头像
- (void)resolveNum1 {
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
//    self.layoutMargins = UIEdgeInsetsZero; //设置cell分割线
    
    //方法1 头像圆形
//    _iconView.layer.cornerRadius = 30;
//    _iconView.layer.masksToBounds = YES;
    // 方法2 .shoryboard 设置 layer.masksToBounds  layer.cornerRadius->number
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
