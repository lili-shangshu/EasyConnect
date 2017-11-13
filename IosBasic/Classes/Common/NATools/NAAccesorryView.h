//
//  NAAccesorryView.h
//  FlyGift
//
//  Created by Nathan Ou on 14/12/21.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLastAccesorryPadding 0.f
#define kPaddingBetweentLabelAccessory 15.f

@interface NAAccesorryView : UIView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImage *accessoryImage;

@end
