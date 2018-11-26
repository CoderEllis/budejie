//
//  ELADItem.h
//  budejie
//
//  Created by Soul Ai on 23/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELADItem : NSObject

/** 广告地址 */
@property (nonatomic, strong) NSString *w_picurl;
/** 点击广告跳转的界面 */
@property (nonatomic, strong) NSString *ori_curl;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;


@end

NS_ASSUME_NONNULL_END
