//
//  UIImageView+Additions.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/5.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UIImageView+Additions.h"

@implementation UIImageView (Additions)

- (void)setImageWithURL:(NSURL *)url completion:(void (^)(UIImage *))block
{
    [self setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        if (block) {
            block(image);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        if (block) {
            block(nil);
        }
    }];
}

- (void)setImageWithFadingAnimationWithURL:(NSURL *)url
{
    [self setImageWithFadingAnimationWithURL:url reload:YES];
}

- (void)setImageWithFadingAnimationWithURL:(NSURL *)url reload:(BOOL)reload
{
    __weak typeof(self) _weakSelf = self;
    if (reload) _weakSelf.image = nil;
    [self setImageWithURL:url completion:^(UIImage *image){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIImageView sharedImageCache] cacheImage:image forRequest:[NSURLRequest requestWithURL:url]];
        });
        _weakSelf.image = image;
    }];
}

- (void)setImageWIthIgnoringCacheWithURL:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [self setImageWithURLRequest:request placeholderImage:nil success:nil failure:nil];
}

//- (void)getAvatarWithURL:(NSURL *)url
//{
//    UIImage *image = [[FGFileManager shareManager] avatarStringWithMemberId:[FGMember currentMember].name];
//    if (image) {
//        self.image = image;
//    }else
//    {
//        [self setImageWithFadingAnimationWithURL:url];
//    }
//}

@end
