//
//  NAUIPageController.h
//  IosBasic
//
//  Created by junshi on 15/12/25.
//  Copyright © 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAUIPageControl : UIPageControl

{
    UIImage *imagePageStateNormal;
    UIImage *imagePageStateHighlighted;
}
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, strong) UIImage *imagePageStateNormal;
@property (nonatomic, strong) UIImage *imagePageStateHighlighted;

@end
