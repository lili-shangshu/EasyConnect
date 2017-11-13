//
//  ClassifyCellView2.h
//  IosBasic
//
//  Created by li jun on 17/4/28.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassifyCellView2Delegate <NSObject>

- (void)clickedCategoods:(ECClassifyGoodsObject *)goodsObj;

@end



@interface ClassifyCellView2 : UIView

@property(nonatomic,weak)id<ClassifyCellView2Delegate>delegate;
@property(nonatomic,strong)UILabel *catagoryTitleLable;
@property(nonatomic,strong)UIImageView *categoryImageView;
@property(nonatomic,strong)NSArray *goodsArray;

- (void)UpdateViewWithProduct:(ECClassifyGoodsObject *)classGoodsobj withproductArray:(NSArray *)goodsArray;
+ (CGFloat)ViewHeightproductArray:(NSArray *)goodsArray;

@end
