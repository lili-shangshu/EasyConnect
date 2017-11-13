//
//  NAUIPageControl.m
//  IosBasic
//
//  Created by junshi on 15/12/25.
//  Copyright © 2015年 CRZ. All rights reserved.
//

#import "NAUIPageControl.h"
#import "UIImage+NATools.h"

@implementation NAUIPageControl


//- (void) setCurrentPage:(NSInteger)page {
//    [super setCurrentPage:page];
//    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
//        UIView* subview = [self.subviews objectAtIndex:subviewIndex];
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
//        imgView.image = [UIImage imageNamed:@"icon_circle_selected2"];
//        
//        [subview addSubview:imgView];
//        
////        CGSize size;
////        size.height = 10;
////        size.width = 10;
////        subview.layer.cornerRadius = subview.width/2;
////        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
////                                     size.width,size.height)];
//       
//    }
//}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

- (id)initWithFrame:(CGRect)frame { // 初始化
    self = [super initWithFrame:frame];
    return self;
}

- (void)setImagePageStateNormal:(UIImage *)image {  // 设置正常状态点按钮的图片
    imagePageStateNormal = image;
    [self updateDots];
}

- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    imagePageStateHighlighted = image;
    [self updateDots];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

- (void)updateDots { // 更新显示所有的点按钮
    
    if (imagePageStateNormal || imagePageStateHighlighted)
    {
        NSArray *subview = self.subviews;  // 获取所有子视图
        for (NSInteger i = 0; i < [subview count]; i++)
        {
            UIImageView *dot = (UIImageView *)[subview objectAtIndex:i];  // 以下不解释, 看了基本明白
            
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//            imgView.image = self.currentPage == i ? imagePageStateHighlighted : imagePageStateNormal;;
//            
//            [dot addSubview:imgView];
//            
//            CGSize size;
//            size.height = 25;
//            size.width = 25;
//            dot.layer.cornerRadius = dot.width/2;
//            [dot setFrame:CGRectMake(dot.frame.origin.x + 10, dot.frame.origin.y,
//                                         size.width,size.height)];
            
            
            [dot setImage: self.currentPage == i ? imagePageStateNormal : imagePageStateHighlighted ];
        }
    }
}



@end
