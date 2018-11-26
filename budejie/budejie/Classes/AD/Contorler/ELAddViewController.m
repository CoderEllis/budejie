
//
//  ELAddViewController.m
//  budejie
//
//  Created by Soul Ai on 21/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELAddViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "ELADItem.h"
#import "MJExtension/MJExtension.h"
#import <UIImageView+WebCache.h>
#import "ELTabBarController.h"


/*
 1.广告业务逻辑
 2.占位视图思想:有个控件不确定尺寸,但是层次结构已经确定,就可以使用占位视图思想
 3.屏幕适配.通过屏幕高度判断
 */
#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"
@interface ELAddViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UIView *addContainView;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;

@property (weak, nonatomic) UIImageView *adView;
@property (strong, nonatomic)ELADItem *item;
@property (weak, nonatomic) NSTimer *timer;

@end

@implementation ELAddViewController


- (IBAction)clickJumo:(id)sender {
    ELTabBarController *tabBarVc = [[ELTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
    [_timer invalidate];// 干掉定时器
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置启动图片
    [self setupLaunchImage];
    
    // 加载广告数据 => 拿到活时间 => 服务器 => 查看接口文档 1.判断接口对不对 2.解析数据(w_picurl,ori_curl:跳转到广告界面,w,h) => 请求数据(AFN)
    [self loadAdDat];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
}


//广告的 View
- (UIImageView *)adView {
    if (_adView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.addContainView addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES; //打开图片交互
        _adView = imageView;
    }
    return _adView;
}

- (void)tap {
    NSURL *url = [NSURL URLWithString:_item.ori_curl];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
}


- (void)timeChange {
    //倒计时  static 全局都
    static int i = 3;
    if (i == 0) {
        //销毁广告,进入主界面
        [self clickJumo:nil];
    }
    i --;
    // 设置跳转按钮文字
    [_jumpBtn setTitle:[NSString stringWithFormat:@"跳过 (%d)",i] forState:UIControlStateNormal];
    
}

#pragma mark - 加载广告数据
- (void)loadAdDat {
    // unacceptable content-type: text/html"  manager -> 添加响应头
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code2;
    [mgr GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [responseObject writeToFile:@"/Users/soulai/Desktop/ad.plist" atomically:YES];
        // 获取字典/Users/soulai/Desktop/123.plist
        NSDictionary *addDict = [responseObject [@"ad"] lastObject];
        //字典转模型
        self->_item = [ELADItem mj_objectWithKeyValues:addDict];
        
        // 创建UIImageView展示图片
        if (addDict) {
            CGFloat h = ScreenWidth / self->_item.w * self->_item.h;
            self.adView.frame = CGRectMake(0, 0, ScreenWidth, h);
        }return
        // 加载广告网页
        [self.adView sd_setImageWithURL:[NSURL URLWithString:self->_item.w_picurl]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ELLog(@"%@",error);
    }];
    
    
}




- (void)setupLaunchImage {
    // 6p:LaunchImage-800-Portrait-736h@3x.png
    // 6:LaunchImage-800-667h@2x.png
    // 5:LaunchImage-568h@2x.png
    // 4s:LaunchImage@2x.png
    //    if (iphone6P) {//6P
    self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    //        ELFunc;
    //    }else if (iphone6) {//6
    //        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    //        ELFunc;
    //    }else if (iphone5){//5
    //        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-568h"];
    //        ELFunc;
    //    }else if (iphone4){//4
    //        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-700"];
    //        ELFunc;
    //    }
}



@end
