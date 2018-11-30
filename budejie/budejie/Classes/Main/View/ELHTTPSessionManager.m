//
//  ELHTTPSessionManager.m
//  budejie
//
//  Created by Soul Ai on 29/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELHTTPSessionManager.h"

@implementation ELHTTPSessionManager
//子类化  把服务器要的信息 放到请求头发送
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        [self.requestSerializer setValue:[UIDevice currentDevice].model forHTTPHeaderField:@"Phone"];
        [self.requestSerializer setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"OS"];
    }
    return self;
}

@end
