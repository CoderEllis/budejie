//
//  ELEssenceViewController.m
//  budejie
//
//  Created by Soul Ai on 20/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//
/*
 名字叫attributes并且是NSDictionary *类型的参数，它的key一般都有以下规律
 1.iOS7开始
 1> 所有的key都来源于： NSAttributedString.h
 2> 格式基本都是：NS***AttributeName
 
 2.iOS7之前
 1> 所有的key都来源于： UIStringDrawing.h
 2> 格式基本都是：UITextAttribute***
 */

#import "ELEssenceViewController.h"
#import "ELTitleButton.h"
#import "ELAllViewController.h"
#import "ELVideoViewController.h"
#import "ELVoiceViewController.h"
#import "ELPictureViewController.h"
#import "ELWordViewController.h"

// UIBarButtonItem:描述按钮具体的内容 (导航条上面的)
// UINavigationItem:设置导航条上内容(左边,右边,中间)
// tabBarItem: 设置tabBar上按钮内容(tabBarButton)
@interface ELEssenceViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak)UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;
/** 上一次点击的标题按钮 */
@property (nonatomic, weak) ELTitleButton *previousClickedTitleButton;
/** 标题下划线 */
@property (nonatomic, weak) UIView *titleUnderline;
@end

@implementation ELEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化子控制器
    [self setupAllChildVcs];
    // 设置导航条
    [self setupNavBar];
    //scrollview
    [self setupScrollview];
    //标题栏
    [self setupTitlesView];
    
    // 默认线加载第一次 view
    [self addChildViewIntoScrollView:0];
    
}

- (void)setupAllChildVcs {
    [self addChildViewController:[[ELAllViewController alloc] init]];
    [self addChildViewController:[[ELVideoViewController alloc] init]];
    [self addChildViewController:[[ELVoiceViewController alloc] init]];
    [self addChildViewController:[[ELPictureViewController alloc] init]];
    [self addChildViewController:[[ELWordViewController alloc] init]];
    
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


//Scrollview
- (void)setupScrollview {
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    //删除scrollview的滚动条
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;//分页
    scrollView.scrollsToTop = NO;// 点击状态栏的时候，这个scrollView不会滚动到最顶部
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    NSUInteger count = self.childViewControllers.count;
    CGFloat scrollViewW = scrollView.el_width;
    
//    CGFloat scrollViewH = scrollView.el_height; //这是一次性添加 VC
//    
//    for (NSUInteger i = 0; i < 5 ; i++) {
//        UIView *childVcView = self.childViewControllers[i].view;
//        childVcView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
//        [scrollView addSubview:childVcView];
//    }
    
    scrollView.contentSize = CGSizeMake(scrollViewW *count, 0);
}

//标题栏
- (void)setupTitlesView {
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    titleView.frame = CGRectMake(0, StatusNavBarHeight, self.view.frame.size.width, ELTitleViewH);
    [self.view addSubview:titleView];
    self.titlesView = titleView;
    //标题栏按钮
    [self setupTitleButtons];
    // 标题下划线
    [self setupTitleUnderline];
}

//标题栏按钮
- (void)setupTitleButtons {
    NSArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    NSUInteger count = titles.count;
    // 标题按钮的尺寸
    CGFloat titleButtonW = self.titlesView.el_width / count;
    CGFloat titleButtonH = self.titlesView.el_height;
    // 创建5个标题按钮
    for (NSInteger i = 0; i < 5 ; i++) {
        ELTitleButton *titleButton = [[ELTitleButton alloc] init];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titleButton];
        //frame
        titleButton.frame = CGRectMake(i *titleButtonW, 0, titleButtonW, titleButtonH);
        //文字
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
//        titleButton.backgroundColor = ELRandomColor;
//        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    }
    
}


// 标题下划线
- (void)setupTitleUnderline {
    ELTitleButton *firstTitleButton = self.titlesView.subviews.firstObject;
    
    //下划线
    UIView *titleUnderline = [[UIView alloc] init];
    titleUnderline.el_height = 2;
    titleUnderline.el_y = self.titlesView.el_height - titleUnderline.el_height;
//    titleUnderline.el_width = 50;
    titleUnderline.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    [self.titlesView addSubview:titleUnderline];
    self.titleUnderline = titleUnderline;
    
    //进来就显示下划线
    firstTitleButton.selected = YES;
    self.previousClickedTitleButton = firstTitleButton;
    [firstTitleButton.titleLabel sizeToFit]; // 让label根据文字内容计算尺寸
    self.titleUnderline.el_width = firstTitleButton.titleLabel.el_width + ELMarin;
    self.titleUnderline.el_centerX = firstTitleButton.el_centerX;
}

#pragma mark -监听
//点击标题按钮
- (IBAction)titleButtonClick:(ELTitleButton *)titleButton {
    // 重复点击了标题按钮 发通知给 VC 做出相关响应
    if (self.previousClickedTitleButton == titleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ELTitleButtonDidRepeatClickNotification object:nil];
    }
    
    [self dealtitleButtonClick:titleButton];
}

/**
 *  处理标题按钮点击
 */
- (void)dealtitleButtonClick:(ELTitleButton *)titleButton {
//    self.previousClickedTitleButton.enabled = YES;
//    titleButton.enabled = NO;
//    self.previousClickedTitleButton = titleButton;
    
    
    self.previousClickedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.previousClickedTitleButton = titleButton;
    NSUInteger index = titleButton.tag;
    
    //处理下划线
    [UIView animateWithDuration:0.25 animations:^{
        //        ELLog(@"%@", [titleButton titleForState:UIControlStateNormal])//打印按钮的文字
        //        self.titleUnderline.el_width = [titleButton.currentTitle sizeWithFont:titleButton.titleLabel.font].width; //7 过期
        //        self.titleUnderline.el_width = [titleButton.currentTitle sizeWithAttributes:@{NSFontAttributeName :titleButton.titleLabel.font}].width;
        
        self.titleUnderline.el_width = titleButton.titleLabel.el_width + ELMarin;
        self.titleUnderline.el_centerX = titleButton.el_centerX;
        
        CGFloat offsetX = self.scrollView.el_width *index;
        //contentOffset偏移量
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        // 添加子控制器的view
        [self addChildViewIntoScrollView:index];
    }];
    
    // 设置index位置对应的tableView.scrollsToTop = YES， 其他都设置为NO
    //点击状态栏顶端 scrollvc滚动到顶部
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        // 如果view还没有被创建，就不用去处理
        if (!childVc.isViewLoaded) continue;
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        // 是标题按钮对应的子控制器
//        if (i == index) {
//            scrollView.scrollsToTop = YES;
//        } else {
//            scrollView.scrollsToTop = NO;
//        }
        scrollView.scrollsToTop = (i == index);
    }
    
    
    
}

//- (void)titleButtonClick:(ELTitleButton *)titleButton {
//    self.previousClickedTitleButton.enabled = YES;
//    titleButton.enabled = NO;
//    self.previousClickedTitleButton = titleButton;
//}

//- (void)titleButtonClick:(ELTitleButton *)titleButton {
//    [self.previousClickedTitleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    self.previousClickedTitleButton = titleButton;
//}


#pragma mark - <UIScrollViewDelegate>
/**
 *  当用户松开scrollView并且滑动结束时调用这个代理方法（scrollView停止滚动的时候）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / scrollView.el_width;
    ELTitleButton *titleButton = self.titlesView.subviews[index];
//    ELTitleButton *titleButton = [self.titlesView viewWithTag:index];//这个会递归遍历    
    [self dealtitleButtonClick:titleButton];
}
/**
 *  当用户松开scrollView时调用这个代理方法（结束拖拽的时候）
 */
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//}

#pragma mark - 其他
/**
 *  添加第index个子控制器的view到scrollView中
 */
- (void)addChildViewIntoScrollView:(NSInteger)index {
    UIViewController *childVc = self.childViewControllers[index];
    //如果VC过返回
    if (childVc.isViewLoaded) return;
    UIView *childView = childVc.view;// 取出index位置对应的子控制器view
    // 设置子控制器view的frame
    CGFloat scrollViewW = self.scrollView.el_width;
    childView.frame = CGRectMake(index *scrollViewW, 0, scrollViewW, self.scrollView.el_height);
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childView];
    
}




/*
 -[UIView setSelected:]: unrecognized selector sent to instance 0x7fbcba35ab10
 
 -[Person length]: unrecognized selector sent to instance 0x7fbcba35ab10
 将Person当做NSString来使用
 
 - (void)test:(NSString *)string
 {
 string.length;
 }
 id str = [[Person alloc] init];
 [self test:str];
 
 -[Person count]: unrecognized selector sent to instance 0x7fbcba35ab10
 将Person当做NSArray或者NSDictionary来使用
 
 -[Person setObject:forKeyedSubscript:]: unrecognized selector sent to instance 0x7fbcba35ab10
 名字中带有Subscript的方法，一般都是集合的方法，比如NSMutableDictionary\NSMutableArray的方法
 将PersonNSMutableDictionary来使用
 */

/*
 A
 -D1  0
 -E1 10
 -E2 0
 -D2 10
 -F1 0
 -F2 0
 -D3 0
 
 [A viewWithTag:10]; // 返回E1
 */

/*
 @implementation UIView
 
 - (UIView *)viewWithTag:(NSInteger)tag
 {
 // 如果自己的tag符合要求，就返回自己
 if (self.tag == tag) return self;
 
 // 遍历子控件（也包括子控件的子控件...），直到找到符合条件的子控件为止
 for (UIView *subview in self.subviews) {
 //        if (subview.tag == tag) return subview;
 UIView *resultView = [subview viewWithTag:tag];
 if (resultView) return resultView;
 }
 
 return nil;
 }
 
 @end
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //处理可以重新创建的任何资源
}
@end
