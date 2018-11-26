
//
//  ELNewViewController.m
//  budejie
//
//  Created by Soul Ai on 20/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELNewViewController.h"
#import "ELSubTagViewController.h"

@interface ELNewViewController ()

@end

@implementation ELNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
}

#pragma mark - 设置导航条
- (void)setupNavBar {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(tagClick)];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
}

- (void)tagClick {
    ELSubTagViewController *subTag = [[ELSubTagViewController alloc] init];
    [self.navigationController pushViewController:subTag animated:YES];
}

@end
