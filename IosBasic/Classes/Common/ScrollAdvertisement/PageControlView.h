//
//  PageControlView.h
//  IosBasic
//
//  Created by junshi on 16/2/17.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageControlView : UIView

@property (nonatomic,assign) int numberOfPages;
@property (nonatomic,assign) int currentPage;
@property (nonatomic, strong) UIImage *imagePageStateNormal;
@property (nonatomic, strong) UIImage *imagePageStateHighlighted;

- (instancetype)initWithNumberOfPages : (int) numberOfPages height:(int)height width:(int)width imageStateNormal:(UIImage *)imageNormal imageStateHighlighted:(UIImage *)imagelighted;
- (void)setCurrentPage:(int) currentPage;

@end
