//
//  UIColor+Additions.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/2.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)


- (UIImage *)image;

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - DefautlsColor
////////////////////////////////////////////////////////////////////////////////////

+ (instancetype)spLineColor;
+ (instancetype)spThemeColor;
+ (instancetype)spBackgroundColor;
+ (instancetype)spDefaultTextColor;
+ (instancetype)spYongJinColor;
+ (instancetype)spCommentUserNameColor;
+ (instancetype)spSeparatorColor;
+ (instancetype)spDeleteButtonColor;
+ (instancetype)spBlankColor;

+ (instancetype)spPriceColor;
+ (instancetype)cancelButton;
+ (instancetype)managerNavgationBarColor;

///////
+ (instancetype)defaultThinGrayColor;
+ (instancetype)defaultSubTitleColor;
+ (instancetype)defaultGrayColor;
+ (instancetype)defaultGrayColorWithAlpha:(CGFloat)alpha;
+ (instancetype)defaultLineColor;
+ (instancetype)defaultlightGrayColor;

+ (instancetype)tabBackGroundColor;
+ (instancetype)slideMenuBackGroundColor;
+ (instancetype)slideMenuSelectedColor;
+ (instancetype)slideMenuTextColor;
+ (instancetype)searchBackGroundColor;

+ (instancetype)facebookColor;
+ (instancetype)textFieldBorderColor;

+ (instancetype)searchBarColor;
+ (instancetype)moreChooseButtonColor;

+ (instancetype)pink;

+ (instancetype)NA_ColorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue;
+ (instancetype)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha;
+ (instancetype)blueIOSColor;
+ (instancetype)colorFromARGB:(int)argb;

+ (instancetype)spBrightRedColor;
+ (instancetype)spDarkRedColor;
+ (instancetype)spLightRedColor;
+ (instancetype)spBigRedColor;
//+ (instancetype)spDarkRedColor;

+ (instancetype)spDarkYellowColor;
+ (instancetype)spLightGreenColor;
+ (instancetype)spLightPurpleColor;
+ (instancetype)spPinkColor;
+ (instancetype)spBrownColor;
+ (instancetype)spBigBrownColor;
+ (instancetype)spLightGrayColor;
+ (instancetype)spSilverGrayColor;
+ (instancetype)spLightWhriteColor;
+ (instancetype)spBrightGreenColor;

+ (instancetype)black1;
+ (instancetype)black2;
+ (instancetype)black3;
+ (instancetype)black4;

+ (instancetype)blue1;
+ (instancetype)blue2;

+ (instancetype)blueA2;
+ (instancetype)blueA1;
+ (instancetype)grayA3;
+ (instancetype)gray1;
+ (instancetype)gray2;
+ (instancetype)gray5;

+ (instancetype)red2;
+ (instancetype)red3;

+ (instancetype)splashV1;
+ (instancetype)splashV2;
+ (instancetype)splashV3;
+ (instancetype)splashV4;

@end
