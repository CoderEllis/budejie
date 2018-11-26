//
//  ELEssenceViewController.m
//  budejie
//
//  Created by Soul Ai on 20/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELEssenceViewController.h"


@interface ELEssenceViewController ()

@end

@implementation ELEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self setupNavBar];
}

#pragma mark - 设置导航条
- (void)setupNavBar {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:nil action:nil];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
}

- (void)game
{
    ELFunc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //处理可以重新创建的任何资源
}
@end
