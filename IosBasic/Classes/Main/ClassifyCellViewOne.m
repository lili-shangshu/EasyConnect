//
//  ClassifyCellOne.m
//  IosBasic
//
//  Created by li jun on 16/10/19.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "ClassifyCellViewOne.h"

#define k_product_height 120.f
#define k_textfont 16.f


@implementation ClassifyCellViewOne



- (id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame: frame]) {
        
        float frameWid = frame.size.width;
        UIView *leftcontainView = [[UIView alloc]init];
        
        leftcontainView.frame = CGRectMake(0, 0, frameWid, k_product_height);
        
        NAImageView *itemImageView = [[NAImageView alloc] initWithFrame:CGRectMake(10.f, 10.f, k_product_height-20, k_product_height-20)];
        self.itemImageView = itemImageView;
        self.itemImageView.contentMode = UIViewContentModeScaleAspectFit;
        [leftcontainView addSubview:itemImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemImageView.right+10.f, itemImageView.top, frameWid-itemImageView.width-10.f*3, 50.f+15)];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [titleLabel setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:k_textfont] aliment:NSTextAlignmentLeft];
        titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel = titleLabel;
        [leftcontainView addSubview:titleLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+1.f, titleLabel.width, 30.f)];
        priceLabel.top = titleLabel.bottom+11;
        [priceLabel setLabelWith:@"" color:[UIColor red2] font:[UIFont boldSystemFontOfSize:k_textfont] aliment:NSTextAlignmentLeft];
        self.priceLabel = priceLabel;
        [leftcontainView addSubview:priceLabel];
        
        float lableWidth = (frameWid-itemImageView.width-40.f)/2;
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.left, priceLabel.bottom, lableWidth, 20.f)];
        [commentLabel setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:k_textfont-5] aliment:NSTextAlignmentLeft];
        self.goodCommentLabel = commentLabel;
//        [leftcontainView addSubview:commentLabel];
        
        UILabel *sellLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentLabel.right+10.f, priceLabel.bottom, lableWidth, 20)];
        [sellLabel setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:k_textfont-5] aliment:NSTextAlignmentLeft];
        self.buyNumberLabel = sellLabel;
//        [leftcontainView addSubview:sellLabel];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, k_product_height-1, frameWid, 1)];
        line2.backgroundColor = [UIColor spBackgroundColor];
        [leftcontainView addSubview:line2];
        
        [self addSubview:leftcontainView];
    }
    return self;
}

- (void)viewWithModel:(ECGoodsObject *)cellModel{
    
    [self.itemImageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:cellModel.imageUrl]];
    self.titleLabel.text = cellModel.name;
    
    self.priceLabel.text = [NSString stringWithFormat:@"$ %.2f", [cellModel.goodsPrice floatValue]];
//    self.goodCommentLabel.text = [NSString stringWithFormat:@"%d 好评",[cellModel.commentsNum intValue]];
//    self.buyNumberLabel.text = [NSString stringWithFormat:@"销量:%d",[cellModel.salesNum intValue]];
    
}
@end
