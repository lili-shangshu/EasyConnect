//
//  NACommenCell.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/5.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPStarView.h"

@class NAImageView;

@interface NACommenCell : UITableViewCell

@property (nonatomic, strong) NSString *goodsUUID;

@property (nonatomic, strong) UIButton *selectionButton;
@property (nonatomic, strong) UILabel *topCellAcessoryLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UILabel *countingLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *selectionLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *stockLabel;
@property (nonatomic, strong) UILabel *buyNumberLabel;
@property (nonatomic, strong) UILabel *totalCountingLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *customLabel1;
@property (nonatomic, strong) UILabel *customLabel2;
@property (nonatomic, strong) UILabel *customLabel3;
@property (nonatomic, strong) NAImageView *itemImageView;
@property (nonatomic, strong) NAImageView *itemImageView2;
@property (nonatomic, strong) UIImageView *customImageView;

@property (nonatomic, strong) SPStarView *starView;

@property (nonatomic, strong) UIScrollView *customScrollView;

@property (nonatomic, strong) UIButton *customButton1;
@property (nonatomic, strong) UIButton *customButton2;
@property (nonatomic, strong) UIButton *customButton3;
@property (nonatomic, strong) UIButton *customButton4;
@property (nonatomic, strong) UIButton *customButton5;

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, assign) CGFloat deaultPadding;
@property (nonatomic, assign) CGFloat minWidth;

@property (nonatomic, strong) UIScrollView *mainScrollView;

/////// 物流界面
@property (nonatomic, strong) UIView *lineView;

// A Cover
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger currentSection;

@property (nonatomic, strong) UIView *customView1;
@property (nonatomic, strong) UIView *customView2;

// 倒计时用得
@property (nonatomic, strong) id customObject;

@end
