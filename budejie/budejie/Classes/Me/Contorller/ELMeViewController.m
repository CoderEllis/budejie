
//
//  ELMeViewController.m
//  budejie
//
//  Created by Soul Ai on 20/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELMeViewController.h"
#import "ELSettingViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "ELSquareCell.h"
#import "ELSquareItem.h"
#import <MJExtension/MJExtension.h>
#import "ELWebViewController.h"

static NSString * const ID = @"cell";
static NSInteger const cols = 4;
static CGFloat const margin = 1;
#define ithemH (ScreenWidth - (cols -1) *margin) /cols


@interface ELMeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic)NSMutableArray *squareItems;
@property (strong, nonatomic)UICollectionView *collectionView;


@end

@implementation ELMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];//导航
    [self setupFootView];//底部 view
    [self loadDate];//数据请求
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:ELTabBarButtonDidRepeatClickNotification object:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ELLog(@"%@",NSStringFromCGRect(cell.frame));
}

#pragma mark - 设置导航条
- (void)setupNavBar {
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
    
    self.navigationItem.title = @"我的";
}

- (void)setting {
    ELSettingViewController *settingVc = [[ELSettingViewController alloc] init];
    // 必须要在跳转之前设置
    settingVc.hidesBottomBarWhenPushed = YES;//TabBar的隐藏
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)night:(UIButton *)button {
    button.selected = !button.selected;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听
/**
 *  监听tabBarButton重复点击
 */
- (void)tabBarButtonDidRepeatClick {
    if (self.view.window == nil) return;
    ELFunc;
}



#pragma mark - 设置tableView底部视图
- (void)setupFootView {
    // 1.初始化要设置流水布局  2.cell必须要注册 3.cell必须自定义
    // 创建布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    NSInteger cols = 4;
    //    CGFloat margin = 1;
    //    CGFloat itemH = (ELScreenW - (cols -1) * margin )/cols;
    layout.itemSize = CGSizeMake(ithemH, ithemH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    _collectionView = collectionView;
    
    collectionView.backgroundColor = self.tableView.backgroundColor;
    self.tableView.tableFooterView = collectionView;
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    collectionView.scrollEnabled = NO;
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"ELSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    
    
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 跳转界面 push 展示网页
    /*
     1.Safari openURL :自带很多功能(进度条,刷新,前进,倒退等等功能),必须要跳出当前应用
     2.UIWebView (没有功能) ,在当前应用打开网页,并且有safari,自己实现,UIWebView不能实现进度条
     3.SFSafariViewController:专门用来展示网页 需求:即想要在当前应用展示网页,又想要safari功能 iOS9才能使用
     4.WKWebView
     1.导入#import <SafariServices/SafariServices.h>
     */
    // 创建网页控制器
    ELSquareItem *item = self.squareItems[indexPath.row];
    if (![item.url containsString:@"http"]) return;
    ELWebViewController *webView = [[ELWebViewController alloc] init];
    webView.url = [NSURL URLWithString:item.url];
    webView.hidesBottomBarWhenPushed = YES;//TabBar的隐藏
    [self.navigationController pushViewController:webView animated:YES];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.squareItems.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ELSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.item = self.squareItems[indexPath.row];
    return cell;
}


#pragma mark - 请求数据
- (void)loadDate {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    [mgr GET:ELCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [responseObject writeToFile:@"/Users/soulai/Desktop/1.plist" atomically:YES];
        
        NSArray *dictArr = responseObject[@"square_list"];
        // 数据处理，排除掉非ELSquareItem 的数据 空数据
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *obj in dictArr) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [array addObject:obj];
            }
        }

        dictArr = [array mutableCopy];
        // 字典数组转换成模型数组
        self->_squareItems = [ELSquareItem mj_objectArrayWithKeyValuesArray:dictArr];
        
        [self resloveData];
        // 设置collectionView 计算collectionView高度 = rows * itemWH
        // Rows = (count - 1) / cols + 1      3 cols4       万能计算公式(总数+1)/列数 +1
        NSInteger count = self.squareItems.count;
        NSInteger rows = (count -1) /cols +1;
        self.collectionView.el_height = rows *ithemH + rows *margin;
        
        // 设置tableView滚动范围:自己计算
        self.tableView.tableFooterView = self.collectionView;
        [self.collectionView reloadData];//刷新表格
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ELLog(@"请求失败");
    }];    
    
}

#pragma mark - 处理请求完成数据
- (void)resloveData {
    // 判断下缺几个
    // 3 % 4 = 3 cols - 3 = 1
    // 5 % 4 = 1 cols - 1 = 3
    NSInteger count = self.squareItems.count;
    NSInteger exter = count % cols;
    if (exter) {
        exter = cols - exter;
        for (int i = 0; i < exter; i++) {
            ELSquareItem *item = [[ELSquareItem alloc] init];
            [self.squareItems addObject:item];
        }
    }
    
    
}

@end
