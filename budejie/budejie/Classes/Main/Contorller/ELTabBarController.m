//
//  ELTabBarController.m
//  budejie
//
//  Created by Soul Ai on 21/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELTabBarController.h"
#import "ELEssenceViewController.h"
#import "ELNewViewController.h"
#import "ELPublishViewController.h"
#import "ELFriendTrendViewController.h"
#import "ELMeViewController.h"
#import "ELNavigationController.h"
#import "UIImage+image.h"
#import "ELTabBar.h"


@interface ELTabBarController ()

@end

@implementation ELTabBarController

// 只会调用一次
+ (void)load {
    //appearance只能在显示之前调用
//    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    // 创建一个描述文本属性的字典 设置按钮选中标题的颜色:富文本:描述一个文字颜色,字体,阴影,空心,图文混排
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
//    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];

    // 设置字体尺寸:只有设置正常状态下,才会有效果
//    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
//    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:14];
//    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
    
    //9.0 后写法2
        [[UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor magentaColor]} forState:UIControlStateSelected];
        [[UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
}



#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAllChildViewController];
    [self setupAllTitleButton];
    [self setupTabBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}


#pragma mark - 自定义tabBar
- (void)setupTabBar {
    ELTabBar *tabBar = [[ELTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
}

#pragma mark - 添加所有控制器
- (void)setupAllChildViewController {
    //精华
    ELEssenceViewController *essenceVc = [[ELEssenceViewController alloc] init];
    ELNavigationController *nav = [[ELNavigationController alloc] initWithRootViewController:essenceVc];
    [self addChildViewController:nav];
    
    
    //新帖
    ELNewViewController *newVc = [[ELNewViewController alloc] init];
    ELNavigationController *nav1 = [[ELNavigationController alloc] initWithRootViewController:newVc];
    [self addChildViewController:nav1];
    
    //发布
//    ELPublishViewController *publishVc = [[ELPublishViewController alloc] init];
//    [self addChildViewController:publishVc];
    
    //关注
    ELFriendTrendViewController *friendVc = [[ELFriendTrendViewController alloc] init];
    ELNavigationController *nav3 = [[ELNavigationController alloc] initWithRootViewController:friendVc];
    [self addChildViewController:nav3];
    
    //我
    ELMeViewController *meVc = [[ELMeViewController alloc] init];
    ELNavigationController *nav4 = [[ELNavigationController alloc] initWithRootViewController:meVc];
    [self addChildViewController:nav4];
}


//设置tabBar上所有按钮内容
- (void)setupAllTitleButton {
    //k精华
    UINavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"精华";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    //不让图片被系统渲染方法1: 点图片 Render as 选择 Original
//    UIImage * image = [UIImage imageNamed:@"tabBar_essence_click_icon"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [UIImage imageOriginalwhitName:@"tabBar_essence_click_icon"];
    
    //新帖
    UINavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"新帖";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalwhitName:@"tabBar_new_click_icon"];
    
    //发布
//    UIViewController *nav2 = self.childViewControllers[2];
//    nav2.tabBarItem.image = [UIImage imageNamed:@"tabBar_publish_icon"];
//    nav2.tabBarItem.selectedImage = [UIImage imageOriginalwhitName:@"tabBar_publish_click_icon"];
    
    //关注
    UINavigationController *nav3 = self.childViewControllers[2];
    nav3.tabBarItem.title = @"关注";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalwhitName:@"tabBar_friendTrends_click_icon"];
    
    //我
    UINavigationController *nav4 = self.childViewControllers[3];
    nav4.tabBarItem.title = @"我";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav4.tabBarItem.selectedImage = [UIImage imageOriginalwhitName:@"tabBar_me_click_icon"];
    
}





@end
