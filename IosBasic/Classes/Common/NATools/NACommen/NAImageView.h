//
//  FGImageView.h
//  FlyGift
//
//  Created by Nathan Ou on 15/1/10.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAImageView : UIImageView

@property (nonatomic, assign) BOOL animated;

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, assign) BOOL onlyFirstLoadWithFaddingAnimation;

- (void)setDefatulImage:(UIImage *)image;

@end
