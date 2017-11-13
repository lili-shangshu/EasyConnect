//
//  BrandCellView.m
//  IosBasic
//
//  Created by junshi on 2017/5/11.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "BrandCellView.h"

#define two_cell_height 130.f
#define k_textfont 13.f

#define lable_height 30


@implementation BrandCellView



- (id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame: frame]) {
        UIView *leftcontainView = [[UIView alloc]init];
        leftcontainView.backgroundColor = [UIColor whiteColor];
        leftcontainView.frame = CGRectMake(10, 10, NAScreenWidth/2-20, two_cell_height-10);
        NAImageView *itemImageView = [[NAImageView alloc] initWithFrame:CGRectMake(0, 0, leftcontainView.width, 100)];
        itemImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.itemImageView = itemImageView;
        self.itemImageView.backgroundColor = [UIColor whiteColor];
        [leftcontainView addSubview:itemImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, itemImageView.bottom, leftcontainView.width, lable_height)];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [titleLabel setLabelWith:@"" color:[UIColor black1] font:[UIFont defaultTextFontWithSize:k_textfont] aliment:NSTextAlignmentCenter];
        titleLabel.backgroundColor = [UIColor gray2];
        self.titleLabel = titleLabel;
        [leftcontainView addSubview:titleLabel];
        
//        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, lable_height)];
//        [priceLabel setLabelWith:@"" color:[UIColor red2] font:[UIFont boldSystemFontOfSize:k_textfont] aliment:NSTextAlignmentCenter];
//        self.priceLabel = priceLabel;
//        [leftcontainView addSubview:priceLabel];
        
        //        float lableWidth = (leftcontainView.width-30.f)/2;
        //        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.left, priceLabel.bottom, lableWidth, lable_height)];
        //        [commentLabel setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:k_textfont-2] aliment:NSTextAlignmentLeft];
        //        self.goodCommentLabel = commentLabel;
        //        [leftcontainView addSubview:commentLabel];
        //
        //        UILabel *sellLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentLabel.right+10.f, priceLabel.bottom, lableWidth, lable_height)];
        //        [sellLabel setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:k_textfont-2] aliment:NSTextAlignmentLeft];
        //        self.buyNumberLabel = sellLabel;
        //        [leftcontainView addSubview:sellLabel];
        
        //两根黑线
        //        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(leftcontainView.width-1, 0, 1, leftcontainView.height)];
        //        line1.backgroundColor = [UIColor gray2];
        //        [leftcontainView addSubview:line1];
        //
        //        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, leftcontainView.height-1, leftcontainView.width, 1)];
        //        line2.backgroundColor = [UIColor gray2];
        //        [leftcontainView addSubview:line2];
        [self addSubview:leftcontainView];
    }
    return self;
}
- (void)viewWithModel:(ECBrandObject *)cellModel{
    
    [self.itemImageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:cellModel.avatar]];
    self.titleLabel.text = cellModel.name;
    
    
}

@end
