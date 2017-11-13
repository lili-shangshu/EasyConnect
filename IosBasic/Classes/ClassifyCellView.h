//
//  ClassifyCellView.h
//  IosBasic
//
//  Created by Apple on 17/4/16.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPNetworkManager.h"

@protocol ClassifyCellViewDelegate <NSObject>

- (void)clickedCategoods:(ECClassifyGoodsObject *)goodsObj;

@end

@interface ClassifyCellView : UIView
@property(nonatomic,weak)id<ClassifyCellViewDelegate>delegate;
@property(nonatomic,strong)UILabel *catagoryTitleLable;
@property(nonatomic,strong)UIImageView *categoryImageView;
@property(nonatomic,strong)NSArray *goodsArray;

- (void)UpdateViewWithProduct:(ECClassifyGoodsObject *)classGoodsobj withproductArray:(NSArray *)goodsArray;
+ (CGFloat)ViewHeightproductArray:(NSArray *)goodsArray;
@end
