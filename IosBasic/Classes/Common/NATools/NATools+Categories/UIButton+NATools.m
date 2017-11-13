//
//  UIButton+NATools.m
//  MyCollections
//
//  Created by Nathan on 14-9-19.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import "UIButton+NATools.h"

@implementation UIButton (NATools)

+ (instancetype)NA_RoundRectButtonWithTitle:(NSString *)string backgroundColor:(UIColor *)color cornerRadius:(CGFloat)radius
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:string forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = color;
    button.layer.cornerRadius = radius;
    button.layer.masksToBounds = YES;
    return button;
}

- (void)xr_setButtonImageWithUrl:(NSString *)urlStr {
    
    NSURL * url = [NSURL URLWithString:urlStr];
    // 根据图片的url下载图片数据
    dispatch_queue_t xrQueue = dispatch_queue_create("loadImage", NULL); // 创建GCD线程队列
    dispatch_async(xrQueue, ^{
        // 异步下载图片
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        // 主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:img forState:UIControlStateNormal];
        });
    });
    
}
@end
