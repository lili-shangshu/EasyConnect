//
//  UILabel+NATools.h
//  MyCollections
//
//  Created by Nathan on 14-11-3.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (NATools)

- (instancetype)setLabelWith:(NSString *)text color:(UIColor *)color font:(UIFont *)font aliment:(NSTextAlignment)textAlignment;

- (CGSize)contentSize;
- (BOOL)isTruncated;

@end
