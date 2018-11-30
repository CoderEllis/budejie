//
//  ELTopicViewController.h
//  budejie
//
//  Created by Soul Ai on 28/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELTopic.h"

NS_ASSUME_NONNULL_BEGIN

@interface ELTopicViewController : UITableViewController
/** 帖子的类型 */
//@property (nonatomic, assign, readonly) ELTopicType type;
- (ELTopicType)type;
@end

NS_ASSUME_NONNULL_END
