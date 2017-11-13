//
//  ClassifyCellOne.h
//  IosBasic
//
//  Created by li jun on 16/10/19.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassifyCellViewOne : UIView

@property(strong,nonatomic) UIImageView * itemImageView ;
@property(strong,nonatomic) UILabel * titleLabel ;
@property(strong,nonatomic) UILabel * priceLabel ;
@property(strong,nonatomic) UILabel * goodCommentLabel ;
@property(strong,nonatomic) UILabel * buyNumberLabel ;

- (void)viewWithModel:(ECGoodsObject *)cellModel;

@end
