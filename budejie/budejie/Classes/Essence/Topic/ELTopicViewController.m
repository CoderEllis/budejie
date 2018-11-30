//
//  ELTopicViewController.m
//  budejie
//
//  Created by Soul Ai on 28/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELTopicViewController.h"
#import <MJExtension.h>
#import "ELTopic.h"
#import "ELTopicCell.h"
#import <SVProgressHUD.h>
#import <SDImageCache.h>
#import <MJRefresh.h>
#import "ELRefreshHeader.h"
//#import "ELDIYHeader.h"
#import "ELHTTPSessionManager.h"
@interface ELTopicViewController ()<UITableViewDelegate>


/** 所有的帖子数据 */
@property (nonatomic,strong)NSMutableArray<ELTopic *> *topics; //泛型 <class *> 
/** 当前最后一条帖子数据的描述信息，专门用来加载下一页数据*/
@property (nonatomic, strong)NSString *maxtime;
/** 请求管理者 */
@property (nonatomic, strong) ELHTTPSessionManager *manager;



@end

@implementation ELTopicViewController

/** 在这里实现type方法，仅仅是为了消除警告 */
- (ELTopicType)type {return 0;}

/* cell的重用标识 */
static NSString * const ELTopicCellId = @"ELTopicCellId";



- (ELHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [ELHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.view.backgroundColor = ELGrayColor(206);
    //处理滚动条 标题内边距
    self.tableView.contentInset = UIEdgeInsetsMake(ELTitleViewH, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;//滚动线
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;//cell分割线
    
    //    self.tableView.rowHeight = 300;
    // 设置cell的估算高度（每一行大约都是estimatedRowHeight）
    //    self.tableView.estimatedRowHeight = 100;
    
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:ELTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:ELTitleButtonDidRepeatClickNotification object:nil];
    // 注册cell
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ELTopicCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ELTopicCellId];
    
    [self setupRefresh];
}




-(void)setupRefresh {
    //广告
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    searchBar.placeholder = @"0_0";
    [searchBar setShowsSearchResultsButton:YES];
    self.tableView.tableHeaderView = searchBar;
    
    //下拉刷新
    self.tableView.mj_header = [ELRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
    // 自动切换透明度automaticallyChangeAlpha
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];  //进来自动刷新数据
    
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
}



#pragma mark - 监听
/**
 *  监听tabBarButton重复点击
 */
- (void)tabBarButtonDidRepeatClick {
    //    if (重复点击的不是精华按钮) return;
    if (self.view.window == nil) return;
    //    if (显示在正中间的不是AllViewController) return;]
    if (self.tableView.scrollsToTop == NO) return; 
    //进入刷新
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  监听titleButton重复点击
 */
- (void)titleButtonDidRepeatClick {
    [self tabBarButtonDidRepeatClick];
}


//销毁监听通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  发送请求给服务器，下拉刷新数据
 */
#pragma mark - 数据处理
- (void)loadNewTopics {
    
    // 取消所有的请求，并且关闭session（注意：一旦关闭了session，这个manager再也无法发送任何请求）
    //    [self.manager invalidateSessionCancelingTasks:YES];
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
//    parameters[@"type"] = @"1";  // 这里发送@1也是可行
    parameters[@"type"] = @(self.type);
    
    [self.manager GET:ELCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        ELAFNWriteToPlist(new_topics)
        
        // 字典数组 -> 模型数据
        self.topics = [ELTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //        NSMutableArray *newTopics = [XMGTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //        if (self.topics) {
        //            [self.topics insertObjects:newTopics atIndexes:[NSIndexSet indexSetWithIndex:0]];
        //        } else {
        //            self.topics = newTopics;
        //        }
        //刷新g表格
        [self.tableView reloadData];
        // 结束刷新状态
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        // 结束刷新状态
        [self.tableView.mj_header endRefreshing];
    }];
}
/*
 取消任务
 Error Domain=NSURLErrorDomain Code=-999 "cancelled" UserInfo={NSErrorFailingURLKey=http://api.budejie.com/api/api_open.php?a=list&c=data&mintime=5345345&type=31, NSLocalizedDescription=cancelled, NSErrorFailingURLStringKey=http://api.budejie.com/api/api_open.php?a=list&c=data&mintime=5345345&type=31}
 
 请求路径有问题（找不到对应的服务器）
 Error Domain=NSURLErrorDomain Code=-1003 "A server with the specified hostname could not be found." UserInfo={NSUnderlyingError=0x7fbc71fd02a0 {Error Domain=kCFErrorDomainCFNetwork Code=-1003 "(null)" UserInfo={_kCFStreamErrorCodeKey=8, _kCFStreamErrorDomainKey=12}}, NSErrorFailingURLStringKey=http://api.budejie.c/?a=list&c=data&mintime=5345345&type=31, NSErrorFailingURLKey=http://api.budejie.c/?a=list&c=data&mintime=5345345&type=31, _kCFStreamErrorDomainKey=12, _kCFStreamErrorCodeKey=8, NSLocalizedDescription=A server with the specified hostname could not be found.}
 */

/**
 *  发送请求给服务器，上拉刷新数据
 */
- (void)loadMoreTopics {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
//    parameters[@"type"] = @"1";  // 这里发送@1也是可行
    parameters[@"type"] = @(self.type);
    parameters[@"maxtime"] = self.maxtime;
    
    [self.manager GET:ELCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        ELAFNWriteToPlist(more_topics)
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        NSArray *moreTopics = [ELTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 累加到旧数组的后面
        [self.topics addObjectsFromArray:moreTopics];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        //        if (self.topics.count >= 60) {
        //            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        //        } else {
        //            [self.tableView.mj_footer endRefreshing];
        //        }
        // 结束刷新状态
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        // 结束刷新状态
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 根据数据量显示或者隐藏footer
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    //    ELLog(@"%zd--------",self.dataCount);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ELTopicCellId];
    
    cell.topic = self.topics[indexPath.row];
    //    ELLog(@"%@ @%@" , NSStringFromCGRect(cell.bounds), NSStringFromCGRect(cell.contentView.bounds));
//    cell.textLabel.text = [NSString stringWithFormat:@"%@-%zd", self.class, indexPath.row];
    return cell;
}

// 所有cell的高度 -> contentSize.height -> 滚动条长度
// 1000 * 20 -> contentSize.height -> 滚动条长度
// contentSize.height -> 200 * 20 -> 16800
/*
 使用estimatedRowHeight的优缺点
 1.优点
 1> 可以降低tableView:heightForRowAtIndexPath:方法的调用频率
 2> 将【计算cell高度的操作】延迟执行了（相当于cell高度的计算是懒加载的）
 
 2.缺点
 1> 滚动条长度不准确、不稳定，甚至有卡顿效果（如果不使用estimatedRowHeight，滚动条的长度就是准确的）
 */

/**
 这个方法的特点：
 1.默认情况下(没有设置estimatedRowHeight的情况下)
 1> 每次刷新表格时，有多少数据，这个方法就一次性调用多少次（比如有100条数据，每次reloadData时，这个方法就会一次性调用100次）
 2> 每当有cell进入屏幕范围内，就会调用一次这个方法
 
 2.设置estimatedRowHeight的情况下
 1> 用到了（显示了）哪个cell，才会调用这个方法计算那个cell的高度（方法调用频率降低了）
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    ELTopic *topic = self.topics[indexPath.row];
    //    return topic.cellHeight;
    
    //    return [self.topics[indexPath.row].cellHeight];  //从数据去除的模型是 id 类型 不能使用 点 语法
    return self.topics[indexPath.row].cellHeight;  //改用 泛型
}


//方法2 利用字典缓存高度
/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 ELTopic *topic = self.topics[indexPath.row];
 // topic -> @"0xff54354354" -> @(cellHeight)
 // topic -> @"0x4534546546" -> @(cellHeight)
 //    NSString *key = [NSString stringWithFormat:@"%p", topic];
 NSString *key = topic.description;
 
 CGFloat cellHeight = [self.cellHeightDict[key] doubleValue];
 if (cellHeight == 0) { // 这个模型对应的cell高度还没有计算过
 
 // 文字的Y值
 cellHeight += 55;
 
 // 文字的高度
 CGSize textMaxSize = CGSizeMake(ELScreenW - 2 * ELMarin, MAXFLOAT);
 cellHeight += [topic.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + ELMarin;
 
 // 工具条
 cellHeight += 35 + ELMarin;
 
 // 存储高度
 self.cellHeightDict[key] = @(cellHeight);
 //        [self.cellHeightDict setObject:@(cellHeight) forKey:key];
 
 ELLog(@"%zd %f", indexPath.row, cellHeight)
 }
 
 return cellHeight;
 }
 */


// 这2个方法只适合计算单行文字的宽高
//    [topic.text sizeWithFont:[UIFont systemFontOfSize:15]].width;
//    [UIFont systemFontOfSize:15].lineHeight;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //处理缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
    // 设置缓存时长为1个月
    //    [SDImageCache sharedImageCache].maxCacheAge = 30 * 24 * 60 * 60;
    
    // 清除沙盒中所有使用SD缓存的过期图片（缓存时长 > 一个星期）
//        [[SDImageCache sharedImageCache] cleanDisk];
    
    
    // 清除沙盒中所有使用SD缓存的图片
    //    [[SDImageCache sharedImageCache] clearDisk];
}


@end
