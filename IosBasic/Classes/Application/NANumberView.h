//
//  NANumberView.h
//  IosBasic
//
//  Created by junshi on 16/1/18.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#

@interface NANumberView : UIView

@property(nonatomic,strong) UILabel *numberLabel;

- (instancetype)initWithFrame:(CGRect)frame withOutColor:(UIColor *)outColor withInColor:(UIColor *)inColor;

@end
