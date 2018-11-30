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


@interface ELSeeBigPictureViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *imageView;


/** 当前App对应的自定义相册 */
- (PHAssetCollection *)createdCollection;
/** 返回刚才保存到【相机胶卷】的图片 */
- (PHFetchResult<PHAsset *> *)createdAssets;


@end

@implementation ELSeeBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.frame = self.view.bounds;
//    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;    
    scrollView.frame = [UIScreen mainScreen].bounds;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [self.view insertSubview:scrollView atIndex:0];
    self.scrollView = scrollView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) return ;
        self.saveBtn.enabled = YES;
    }];
    imageView.el_width = scrollView.el_width;
    imageView.el_height = imageView.el_width * self.topic.height / self.topic.width;
    imageView.el_x = 0;
    if (imageView.el_height > ScreenHeight) {
        imageView.el_y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.el_height);
    } else {
        imageView.el_centerY = scrollView.el_height * 0.5;
    }
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 图片缩放
    CGFloat maxScale = self.topic.width / imageView.el_width;
    if (maxScale > 1) {
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
    }
    
    
}

#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - 获得当前App对应的自定义相册
- (PHAssetCollection *)createdCollection {
    // 获得软件名字
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    
     // 抓取所有的自定义相册 
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 查找当前App对应的自定义相册
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    
    /** 当前App对应的自定义相册没有被创建过 **/
    // 创建一个【自定义相册】
    NSError *error = nil;
    __block NSString *createdCollectionID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"创建相册失败!"];
    }
    
    // 根据唯一标识获得刚才创建的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionID] options:nil].firstObject;
}

- (PHFetchResult<PHAsset *> *)createdAssets {
    NSError *error = nil;
    __block NSString *assetID = nil;
    // 保存图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    if (error) return nil;
    
    // 获取刚才保存的相片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}

#pragma mark - 监听点击
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save {
    
    /** 相册权限 */
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    // 请求\检查访问权限 :
    // 如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后，才会调用block
    // 如果之前已经做过选择，会直接执行block
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{  //async 异步主线程
            if (status == PHAuthorizationStatusDenied) {  // 用户拒绝当前App访问相册
                if (oldStatus != PHAuthorizationStatusNotDetermined) {
                    ELLog(@"提醒用户打开开关权限");
                }
            } else if (status == PHAuthorizationStatusAuthorized) {// 用户允许当前App访问相册
                [self saveImageIntoAlbum];
            } else if (status == PHAuthorizationStatusRestricted) {// 无法访问相册
                [SVProgressHUD showErrorWithStatus:@"因系统原因，无法访问相册！"];
            }
        });
    }];
    
    
}

/**
 *  保存图片到相册
 */
- (void)saveImageIntoAlbum {
    // 获得相片
    PHFetchResult<PHAsset *> *createdAssets = self.createdAssets;
    if (createdAssets == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
        return;
    }
    
    // 获得相册
    PHAssetCollection *createdCollection = self.createdCollection;
    if (createdCollection == nil) {
        [SVProgressHUD showErrorWithStatus:@"创建或者获取相册失败！"];
        return;
    }
    
    // 添加刚才保存的图片到【自定义相册】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    // 最后的判断
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败!"];
        return;
    } else {
         [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
    
}

/*
 一、保存图片到【自定义相册】
 1.保存图片到【相机胶卷】
 1> C语言函数UIImageWriteToSavedPhotosAlbum
 2> AssetsLibrary框架
 3> Photos框架
 
 2.拥有一个【自定义相册】
 1> AssetsLibrary框架
 2> Photos框架
 
 3.添加刚才保存的图片到【自定义相册】
 1> AssetsLibrary框架
 2> Photos框架
 
 二、Photos框架须知
 1.PHAsset : 一个PHAsset对象就代表相册中的一张图片或者一个视频
 1> 查 : [PHAsset fetchAssets...]
 2> 增删改 : PHAssetChangeRequest(包括图片\视频相关的所有改动操作)
 
 2.PHAssetCollection : 一个PHAssetCollection对象就代表一个相册
 1> 查 : [PHAssetCollection fetchAssetCollections...]
 2> 增删改 : PHAssetCollectionChangeRequest(包括相册相关的所有改动操作)
 
 3.对相片\相册的任何【增删改】操作，都必须放到以下方法的block中执行
 -[PHPhotoLibrary performChanges:completionHandler:]
 -[PHPhotoLibrary performChangesAndWait:error:]
 */

/*
 Foundation和Core Foundation的数据类型可以互相转换，比如NSString *和CFStringRef
 NSString *string = (__bridge NSString *)kCFBundleNameKey;
 CFStringRef string = (__bridge CFStringRef)@"test";
 
 获得相机胶卷相册
 [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil]
 */

/*
 错误信息：This method can only be called from inside of -[PHPhotoLibrary performChanges:completionHandler:] or -[PHPhotoLibrary performChangesAndWait:error:]
 // 异步执行修改操作
 [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
 [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
 } completionHandler:^(BOOL success, NSError * _Nullable error) {
 if (error) {
 [SVProgressHUD showErrorWithStatus:@"保存失败！"];
 } else {
 [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
 }
 }];
 
 // 同步执行修改操作
 NSError *error = nil;
 [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
 [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
 } error:&error];
 if (error) {
 [SVProgressHUD showErrorWithStatus:@"保存失败！"];
 } else {
 [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
 }
 
 */

/*
 [UIView animateWithDuration:2.0 animations:^{
 self.view.frame = CGRectMake(0, 0, 100, 100);
 } completion:^(BOOL finished) {
 
 }];
 
 [UIView beginAnimations:nil context:nil];
 [UIView setAnimationDuration:2.0];
 [UIView setAnimationDelegate:self];
 [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
 self.view.frame = CGRectMake(0, 0, 100, 100);
 [UIView commitAnimations];
 
 - (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
 {
 
 }*/

//  UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(a:b:c:), nil);
//- (void)a:(UIImage *)image b:(NSError *)error c:(void *)contextInfo
//{
//    if (error) {
//        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
//    } else {
//        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
//    }
//}

//- (void)done
//{
//    ELFunc
//}

/*
 错误信息：-[NSInvocation setArgument:atIndex:]: index (2) out of bounds [-1, 1]
 错误解释：参数越界错误，方法的参数个数和实际传递的参数个数不一致
 */

//- (UIScrollView *)scrollView
//{
//    if (!_scrollView) {
//        UIScrollView *scrollView = [[UIScrollView alloc] init];
//        scrollView.backgroundColor = [UIColor redColor];
//        [self.view insertSubview:scrollView atIndex:0];
//        _scrollView = scrollView;
//    }
//    return _scrollView;
//}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//
//    self.scrollView.frame = self.view.bounds;
//}

//C函数保存图片
/*
 UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image: didFinishSavingWithError:contextInfo:), nil);
 
 - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
 */

@end
