//
//  ShopCartCellView.h
//  IosBasic
//
//  Created by li jun on 16/10/14.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopCartCellDelegate <NSObject>


- (void)clickIndex:(int)index isAdd :(BOOL)isAdd isSelect:(BOOL)isSelect;
- (void)selectByIndex:(int)buttonTag isSlect:(BOOL)isSelct;
- (void)deleteButtonClicked:(int)index;
@optional
- (void)clickIndex:(int)index andFlag :(int)flag;
@end


@interface ShopCartCellView : UIView

@property (nonatomic,strong) NAImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subtitleLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UIButton *selectButton;

@property (nonatomic,strong) NAImageView *selectimgView;

@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *minusBtn;

// 是否在确认订单中显示 + - 符号  没有用啊
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) id<ShopCartCellDelegate> delegate;
@property (nonatomic,assign) NSInteger index;


- (id)initWithCirleFrame:(CGRect)frame;

- (void)changePriceLableAndNumLableFrame;
@end
