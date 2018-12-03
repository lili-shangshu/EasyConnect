//
//  UIColor+Additions.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/2.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

// 将颜色处理成图片
- (UIImage *)image
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - DefautlsColor
////////////////////////////////////////////////////////////////////////////////////

+ (instancetype)spLineColor
{
    return [UIColor colorWithWhite:0.850 alpha:1.000];
}

+ (instancetype)spThemeColor
{
    unsigned result = 0;
    //从plist配置文件中读取主题颜色
    NSScanner *scanner = [NSScanner scannerWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"MainThemeColor"]];
    //去除‘＃’号
    [scanner setScanLocation:1]; // bypass '#' character
    //将十六进制数据转换为十进制
    [scanner scanHexInt:&result];
    return [UIColor colorFromARGB:result];

}

+ (instancetype)spBackgroundColor
{
    return [UIColor colorWithRed:245.f/255.f green:242.f/255.f blue:242/255.f alpha:1.000];
}

+ (instancetype)spDefaultTextColor
{
    return [UIColor colorWithRed:128.f/255.f green:128.f/255.f blue:128.f/255.f alpha:1.000];
}

+ (instancetype)spYongJinColor
{
    return [UIColor spPriceColor];
}

+ (instancetype)colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"])
    cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
    cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
    return [UIColor clearColor];
    
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (instancetype)spCommentUserNameColor
{
    return [UIColor colorWithRed:0.275 green:0.341 blue:0.514 alpha:1.000];
}

+ (instancetype)spSeparatorColor
{
    return [UIColor colorWithWhite:0.880 alpha:1.000];
}

+ (instancetype)spDeleteButtonColor
{
    return [UIColor colorWithRed:86.f/255.f green:178.f/255.f blue:1 alpha:1];
}

+ (instancetype)spBlankColor{
    return [UIColor colorWithRed:232/255.0 green:231/255.0 blue:231/255.0 alpha:1];
}

+ (instancetype)cancelButton
{
    return [UIColor NA_ColorWithR:229 g:70 b:46];
}

+ (instancetype)managerNavgationBarColor
{
    return [UIColor colorWithWhite:0.976 alpha:1.000];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - May be Will
////////////////////////////////////////////////////////////////////////////////////

+ (instancetype)spPriceColor
{
    return [UIColor NA_ColorWithR:229 g:70 b:46];
}

+ (instancetype)tabBackGroundColor
{
    return [UIColor colorWithR:38 g:27 b:24];
}

+ (instancetype)slideMenuBackGroundColor
{
    return [UIColor colorWithR:26 g:19 b:18];
}

+ (instancetype)slideMenuSelectedColor
{
    return [UIColor colorWithR:21 g:15 b:14];
}

+ (instancetype)slideMenuTextColor
{
    return [UIColor colorWithR:93 g:93 b:93];
    
}

+ (instancetype)searchBackGroundColor{
    
    return [UIColor colorWithR:31 g:21 b:18];
    
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - FGColor
////////////////////////////////////////////////////////////////////////////////////

+ (instancetype)defaultThinGrayColor
{
    return [UIColor colorWithR:153.f g:153.f b:153.f];
}

+ (instancetype)defaultSubTitleColor
{
    return [self defaultThinGrayColor];
}

+ (instancetype)defaultGrayColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:0.388 green:0.396 blue:0.408 alpha:alpha];;
}

+ (instancetype)defaultGrayColor
{
    return [UIColor defaultGrayColorWithAlpha:1.0];
}

+ (instancetype)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue
{
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1];
}

+ (instancetype)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

+ (instancetype)defaultLineColor
{
    return [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
}

+ (instancetype)defaultlightGrayColor
{
    return [UIColor colorWithR:240 g:240 b:240];
}

+ (instancetype)facebookColor{
    return [UIColor colorWithR:59 g:88 b:156];
}

+ (instancetype)textFieldBorderColor{
    return [UIColor colorWithR:183 g:183 b:183];
}

+ (instancetype)searchBarColor{
    return [UIColor colorWithR:239 g:183 b:14];
}

+ (instancetype)moreChooseButtonColor{
    return [UIColor colorWithR:60 g:44 b:39];
}

+ (instancetype)pink{
    return [UIColor colorWithR:242 g:90 b:90 ];
}


+ (instancetype)NA_ColorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue
{
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1];
}

+ (instancetype)blueIOSColor
{
    return [UIColor colorWithRed:0.047 green:0.373 blue:0.996 alpha:1.000];
}

+ (instancetype)colorFromARGB:(int)argb
{
    int blue = argb & 0xff;
    int green = argb >> 8 & 0xff;
    int red = argb >> 16 & 0xff;
    CGFloat alpha = argb >> 24 & 0xff;
    
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

+ (instancetype)spBrightRedColor{
    return [UIColor colorWithR:191 g:18 b:34];
}
+ (instancetype)spDarkRedColor{
    return [UIColor colorWithR:148 g:32 b:31];
}
+ (instancetype)spLightRedColor{
    return [UIColor colorWithR:195 g:55 b:53];
}
+ (instancetype)spBigRedColor{
    return [UIColor colorWithR:166 g:2 b:2];
}

//+ (instancetype)spDarkRedColor{
//    return [UIColor colorWithR:166 g:26 b:25];
//}

+ (instancetype)spDarkYellowColor{
    return [UIColor colorWithR:231 g:213 b:192];
}
+ (instancetype)spLightGreenColor{
    return [UIColor colorWithR:195 g:216 b:144];
}
+ (instancetype)spLightPurpleColor{
    return [UIColor colorWithR:202 g:150 b:209];
}
+ (instancetype)spPinkColor{
    return [UIColor colorWithR:223 g:164 b:137];
}
+ (instancetype)spBrownColor{
    return [UIColor colorWithR:170 g:153 b:132];
}
+ (instancetype)spBigBrownColor{
    return [UIColor colorWithR:134 g:103 b:64];
}
+ (instancetype)spLightGrayColor{
    return [UIColor colorWithR:191 g:177 b:159];
}
+ (instancetype)spSilverGrayColor{
    return [UIColor colorWithR:236 g:233 b:229];
}

+ (instancetype)spLightWhriteColor{
    return [UIColor colorWithR:250 g:243 b:235];
}

+ (instancetype)spBrightGreenColor{
    return [UIColor colorWithR:104 g:171 b:30];
}

// 一修改为
+ (instancetype)black1{
    return [UIColor colorWithR:180 g:180 b:180];
}

+ (instancetype)black2{
    return [UIColor colorWithR:31 g:31 b:31];
}

+ (instancetype)black3{
    return [UIColor colorWithR:24 g:24 b:24];
}
// 文字的黑色
+ (instancetype)black4{
    return [UIColor colorWithR:65 g:65 b:65];
}

+ (instancetype)blueA2{
    return [UIColor colorWithR:57 g:173 b:210];
}

+ (instancetype)blueA1{
    return [UIColor colorWithR:49 g:140 b:255 a:0];
}

+ (instancetype)blue1{
    return [UIColor colorWithR:49 g:140 b:255];
}

// 背景色
+ (instancetype)blue2{
    return [UIColor colorWithR:57 g:174 b:211];
}

+ (instancetype)grayA3{
    return [UIColor colorWithR:100 g:100 b:100];
}

+ (instancetype)gray1{
    return [UIColor colorWithR:179 g:179 b:179];
}

+ (instancetype)gray2{
    return [UIColor colorWithR:232 g:232 b:232];
}

+ (instancetype)gray5{
    return [UIColor colorWithR:249 g:249 b:249];
}

// 一修改
+ (instancetype)red2{
    return [UIColor colorWithR:238 g:98 b:85];
}

+ (instancetype)red3{
    return [UIColor colorWithR:240 g:81 b:111];
}

+ (instancetype)splashV1{
    return [UIColor colorWithR:18 g:30 b:48];
}

+ (instancetype)splashV2{
    return [UIColor colorWithR:23 g:49 b:92];
}

+ (instancetype)splashV3{
    return [UIColor colorWithR:27 g:65 b:129];
}

+ (instancetype)splashV4{
    return [UIColor colorWithR:70 g:81 b:111];
}


@end
