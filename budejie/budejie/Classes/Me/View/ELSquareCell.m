//
//  ELSquareCell.m
//  budejie
//
//  Created by Soul Ai on 26/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELSquareCell.h"
#import <UIImageView+WebCache.h>
#import "ELSquareItem.h"


@interface ELSquareCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;

@end

@implementation ELSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setItem:(ELSquareItem *)item {
    _item = item;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    _nameView.text = item.name;
    
}




@end
