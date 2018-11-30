//
//  ELConst.m
//  budejie
//
//  Created by Soul Ai on 23/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.


//常量
#import <UIKit/UIKit.h>


/** 标题栏的高度 */
CGFloat const ELTitleViewH = 35;

/** 全局 cell 统一间距 */
CGFloat const ELMarin = 10;

/** 统一的一个请求路径 */
NSString * const ELCommonURL = @"http://api.budejie.com/api/api_open.php";

/** TabBarButton被重复点击的通知 */
NSString * const ELTabBarButtonDidRepeatClickNotification = @"ELTabBarButtonDidRepeatClickNotification";

/** TitleButton被重复点击的通知 */
NSString * const ELTitleButtonDidRepeatClickNotification = @"ELTitleButtonDidRepeatClickNotification";
