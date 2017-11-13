//
//  UIImageView+Additions.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/5.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface UIImageView (Additions)

- (void)setImageWithURL:(NSURL *)url completion:(void (^)(UIImage *))block;
- (void)setImageWithFadingAnimationWithURL:(NSURL *)url;
- (void)setImageWithFadingAnimationWithURL:(NSURL *)url reload:(BOOL)reload;
- (void)setImageWIthIgnoringCacheWithURL:(NSURL *)url;

@end
