//
//  ELTopicCell.h
//  budejie
//
//  Created by Soul Ai on 29/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ELTopic;

@interface ELTopicCell : UITableViewCell
/** 模型数据 */
@property (strong, nonatomic) ELTopic *topic;
@end

NS_ASSUME_NONNULL_END
