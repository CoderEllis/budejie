
//
//  ELMeViewController.m
//  budejie
//
//  Created by Soul Ai on 20/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELMeViewController.h"
#import "ELSettingViewController.h"
@interface ELMeViewController ()

@end

@implementation ELMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self setupNavBar];
}


#pragma mark - 设置导航条
- (void)setupNavBar {
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"mine-moon-icon"] highImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night)];
    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
    
    self.navigationItem.title = @"我的";
}

- (void)setting {
    ELSettingViewController *settingVc = [[ELSettingViewController alloc] init];
    // 必须要在跳转之前设置
    settingVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)night {
    ELFunc;
}

@end
