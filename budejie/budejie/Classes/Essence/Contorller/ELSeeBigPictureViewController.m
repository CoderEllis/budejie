//
//  ELSeeBigPictureViewController.m
//  budejie
//
//  Created by Soul Ai on 29/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//
/*
 一种很常见的开发思路
 1.在viewDidLoad方法中添加初始化子控件
 2.在viewDidLayoutSubviews方法中布局子控件（设置子控件的位置和尺寸）
 
 另一种常见的开发思路
 1.控件弄成懒加载
 2.在viewDidLayoutSubviews方法中布局子控件（设置子控件的位置和尺寸）
 */

#import "ELSeeBigPictureViewController.h"
#import "ELTopic.h"
#import <SVProgressHUD.h>
#import <Photos/Photos.h>


@interface ELSeeBigPictureViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@end

@implementation ELSeeBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)back {
    
}

- (IBAction)save {
}


@end
