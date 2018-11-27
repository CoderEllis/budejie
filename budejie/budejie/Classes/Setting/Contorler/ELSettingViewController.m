//
//  ELSettingViewController.m
//  budejie
//
//  Created by Soul Ai on 21/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELSettingViewController.h"
#import <SDImageCache.h>
#import "ELFileTool.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface ELSettingViewController ()
@property (nonatomic, assign) NSInteger totalSize;
@end

@implementation ELSettingViewController

static NSString * const ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"jump" style:0 target:self action:@selector(jump)];
    
    //注册 cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    
    [SVProgressHUD showWithStatus:@"正在计算缓存尺寸...."];
    [ELFileTool getFileSize:CachePath completion:^(NSInteger totalSize) {
        //        NSLog(@"%@",[NSThread currentThread]); //打印线程
        self->_totalSize = totalSize;
        //刷新表格
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        
    }];
    
    
}

- (void)jump {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 计算缓存数据,计算整个应用程序缓存数据 => 沙盒(Cache) => 获取cache文件夹尺寸
    // 获取缓存尺寸字符串
    cell.textLabel.text = [self sizeStr];
    return cell;
}


//点击 cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 清空缓存
    // 获取文件管理者
    [ELFileTool removeDirectoryPath:CachePath];
    _totalSize = 0;
    [self.tableView reloadData];
}



- (NSString *)sizeStr {
    // 获取Caches文件夹路径
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSInteger totalSize = _totalSize;
    NSString *sizeStr = @"清除缓存";
    //     MB KB B
    if (totalSize > 1000 * 1000) {
        CGFloat sizeF = totalSize /1000.0 / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fMB)",sizeStr,sizeF];
    } else if (totalSize > 1000) {
        //KB
        CGFloat sizeF = totalSize / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fKB)",sizeStr,sizeF];
    } else if (totalSize > 0) {
        // B
        sizeStr = [NSString stringWithFormat:@"%@(%.ldB)",sizeStr,totalSize];
    }
    return sizeStr;
}


@end
