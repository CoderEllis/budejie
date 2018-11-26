
//
//  ELFastLoginView.m
//  budejie
//
//  Created by Soul Ai on 24/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELFastLoginView.h"

@interface ELFastLoginView ()

@end

@implementation ELFastLoginView

+ (instancetype)fastLoginView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}


@end
