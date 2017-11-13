//
//  BrandCellView.h
//  IosBasic
//
//  Created by junshi on 2017/5/11.
//  Copyright © 2017年 CRZ. All rights reserved.
//

@interface BrandCellView : UIView

@property(strong,nonatomic) UIImageView * itemImageView ;
@property(strong,nonatomic) UILabel * titleLabel ;

- (void)viewWithModel:(ECBrandObject *)cellModel;

@end
