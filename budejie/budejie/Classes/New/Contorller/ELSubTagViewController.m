//
//  ELSubTagViewController.m
//  budejie
//
//  Created by Soul Ai on 23/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELSubTagViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "ELSubTagItem.h"
#import "MJExtension/MJExtension.h"
#import "ELSubTagCell.h"
#import "SVProgressHUD/SVProgressHUD.h"

static NSString * const ID = @"cell";

@interface ELSubTagViewController ()
@property (strong, nonatomic)NSArray *subTags;
//@property (strong, nonatomic)AFHTTPSessionManager *mgr;
@end

@implementation ELSubTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ELSubTagCell" bundle:nil] forCellReuseIdentifier:ID];
    // 处理cell分割线 1.自定义分割线 2.系统属性(iOS8才支持) 3.万能方式(重写cell的setFrame) 了解tableView底层实现了解 1.取消系统自带分割线 2.把tableView背景色设置为分割线的背景色 3.重写setFrame
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//取消系统自带分割线
    
    self.title = @"推荐标签";
    self.tableView.backgroundColor = ELColor(220, 220, 220);
    
    [SVProgressHUD  showWithStatus:@"正在加载ing....."];
    
//    [self setupRefresh];
}

// 界面即将消失调用
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}


- (void)setupRefresh {
    //header刷新
    
}

- (void)loadData {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    
    [mgr GET:ELCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
//        [responseObject writeToFile:@"/Users/soulai/Desktop/1.plist" atomically:YES];
        // 字典数组转换模型数组
        self->_subTags = [ELSubTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
    
    
    
    
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subTags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ELSubTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    ELSubTagItem *item = self.subTags[indexPath.row];
    cell.item = item;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
