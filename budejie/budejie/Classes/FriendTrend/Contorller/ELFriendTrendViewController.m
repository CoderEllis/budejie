//
//  ELFriendTrendViewController.m
//  budejie
//
//  Created by Soul Ai on 20/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELFriendTrendViewController.h"
#import "ELLoginRegisterViewController.h"
#import "UITextField+Placeholder.h"

@interface ELFriendTrendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ELFriendTrendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    
    _textField.placeholderColor = [UIColor greenColor];
    _textField.placeholder = @"???测试";
    _textField.textColor = [UIColor yellowColor];
    
}
- (IBAction)clickLoginRegister:(id)sender {
    ELLoginRegisterViewController *loginVc = [[ELLoginRegisterViewController alloc] init];
    [self presentViewController:loginVc animated:YES completion:nil];
}

#pragma mark - 设置导航条
- (void)setupNavBar {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendsRecomment)];
    self.navigationItem.title = @"我的关注";
}

- (void)friendsRecomment
{
    ELFunc;
}

@end
