//
//  UILabel+NATools.m
//  MyCollections
//
//  Created by Nathan on 14-11-3.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import "UILabel+NATools.h"

@implementation UILabel (NATools)

- (instancetype)setLabelWith:(NSString *)text color:(UIColor *)color font:(UIFont *)font aliment:(NSTextAlignment)textAlignment
{
    if (text) self.text = text;
    self.textColor = color;
    self.font = font;
    self.textAlignment = textAlignment;
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (CGSize)contentSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    CGRect contentFrame = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : self.font } context:nil];
    
    return contentFrame.size;
}

- (BOOL)isTruncated
{
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    
    return (size.height > self.frame.size.height);
}

@end
