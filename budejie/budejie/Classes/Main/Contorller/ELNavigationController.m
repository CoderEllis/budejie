//
//  ELNavigationController.m
//  budejie
//
//  Created by Soul Ai on 21/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELNavigationController.h"

@interface ELNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ELNavigationController


+ (void)load {
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navBar setTitleTextAttributes:attrs];
    // 设置导航条背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //全屏滑动返回
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:handler];
    
    // 控制手势什么时候触发,只有非根控制器才需要触发手势
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
    //禁止之前的手势
    self.interactivePopGestureRecognizer.enabled = NO;

}





#pragma mark - UIGestureRecognizerDelegate
 //决定是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.childViewControllers.count > 1;
}

///*
// UINavigationInteractiveTransition: 0x7f9c948302a0>:手势代理
//
// UIScreenEdgePanGestureRecognizer:导航滑动手势
// target=<_UINavigationInteractiveTransition 0x7fdc4a740440>)
// action=handleNavigationTransition:
//
// <UIScreenEdgePanGestureRecognizer: 0x7fdc4a740120; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7fdc4a73e690>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fdc4a740440>)>>
//
// */


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {  // 非根控制器
        // 恢复滑动返回功能 -> 分析:把系统的返回按钮覆盖 -> 1.手势失效(1.手势被清空 2.可能手势代理做了一些事情,导致手势失效)
//        viewController.hidesBottomBarWhenPushed = YES;//u隐藏 tabbar
        // 设置返回按钮,只有非根控制器
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self ation:@selector(back) title:@"返回"];

    }
    // 真正在跳转
    [super pushViewController:viewController animated:animated];

}

- (void)back {
    [self popViewControllerAnimated:YES];
}

/*
///配置全局侧滑返回手势
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 重新设置侧滑手势的代理
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weakSelf;
    }
    
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    //调用此方法禁用侧滑返回功能
//    //此方法将会把navigationController后边的所有ViewController侧滑手势禁用，所以我推荐在所有ViewController基类的viewDidLoad中开启全局的侧滑功能，然后在相应禁止侧滑的控制器中的viewDidAppear中禁止侧滑
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//}


// 开始接收到手势的代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 判断是否是侧滑相关的手势
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        // 如果当前展示的控制器是根控制器就不让其响应
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}

// 开始接收到手势的代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 判断是否是侧滑相关的手势
    if (gestureRecognizer == self.interactivePopGestureRecognizer && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        // 如果是侧滑相关的手势，并且手势的方向是侧滑的方向就让多个手势共存
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self.view];
        if (point.x > 0) {
            return YES;
        }
    }
    return NO;
}
*/

@end
