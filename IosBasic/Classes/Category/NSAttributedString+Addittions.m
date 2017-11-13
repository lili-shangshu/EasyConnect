//
//  NSAttributedString+Addittions.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/10.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "NSAttributedString+Addittions.h"

@implementation NSAttributedString (Addittions)

+ (NSAttributedString *)commentWithName:(NSString *)name content:(NSString *)content fontSize:(CGFloat)fontSize
{
    NSMutableAttributedString *attributedText;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
    
    NSDictionary *attDic = @{NSForegroundColorAttributeName : [UIColor blueColor],
                             NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                             NSParagraphStyleAttributeName:paragraphStyle};
    attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：",name] attributes:attDic];
    
    attDic = @{NSForegroundColorAttributeName : [UIColor blackColor],
               NSFontAttributeName:[UIFont defaultTextFontWithSize:fontSize]};
    NSMutableAttributedString *attributedText2 = [[NSMutableAttributedString alloc] initWithString:content attributes:attDic];
    [attributedText appendAttributedString:attributedText2];
    
    return attributedText;
}

@end
