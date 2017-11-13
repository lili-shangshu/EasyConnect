//
//  UIImage+NAAdditions.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/6.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NATools)

- (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)zipImageWithSize:(CGSize)size;
-(UIImage*)resizedImageToSize:(CGSize)dstSize;
@end
