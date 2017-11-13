//
//  ShopCartCellView.m
//  IosBasic
//
//  Created by li jun on 16/10/14.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "ShopCartCellView.h"

#define herizon_padding 20.f
#define padding 10.f
#define text_font  15.f
#define lable_height  25.f

@implementation ShopCartCellView

// 总共是130  10 10  3*25   25
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, 130-10)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
//        _selectButton = [[UIButton alloc]initWithFrame:CGRectMake(10, frame.size.height/2-10, 20, 20)];
//        [_selectButton setBackgroundImage:[UIImage imageNamed:@"circle_selected"] forState:UIControlStateSelected];
//        [_selectButton setBackgroundImage:[UIImage imageNamed:@"circle_unselected"] forState:UIControlStateNormal];
//        [_selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [bgView addSubview:_selectButton];
        
        _selectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, frame.size.height)];
        [_selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_selectButton];
        
        _selectimgView = [[NAImageView alloc]initWithFrame:CGRectMake(10, _selectButton.height/2-10, 20, 20)];
        _selectimgView.image = [UIImage imageNamed:@"circle_unselected"];
        [_selectButton addSubview:_selectimgView];
        
        _imgView = [[NAImageView alloc] initWithFrame:CGRectMake(_selectButton.right, padding, frame.size.height-padding*2, frame.size.height-padding*2)];
        _imgView.contentMode = UIViewContentModeScaleToFill;
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 2.f;
        [bgView addSubview:_imgView];
        
        // 名称的
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.right +padding, _imgView.top,bgView.width-_imgView.right-herizon_padding, 50)];
        _titleLabel.textColor = [UIColor black4];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize: text_font];
        [bgView addSubview:_titleLabel];
        
        // 价格
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom , _titleLabel.width/2, lable_height)];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.textColor = [UIColor spThemeColor];
        _priceLabel.font = [UIFont systemFontOfSize:text_font+2];
        [bgView addSubview:_priceLabel];
        
        // 积分的
        _subtitleLabel= [[UILabel alloc] initWithFrame:CGRectMake(_priceLabel.right, _titleLabel.bottom,self.width-_imgView.right-herizon_padding, lable_height)];
        _subtitleLabel.textColor = [UIColor spDefaultTextColor];
        _subtitleLabel.textAlignment = NSTextAlignmentLeft;
        _subtitleLabel.font = [UIFont systemFontOfSize: text_font-2];
//        [bgView addSubview:_subtitleLabel];

        _minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(_priceLabel.left, _priceLabel.bottom+5, 20, 20)];
        [_minusBtn setImage:[UIImage imageNamed:@"icon_minus"] forState:UIControlStateNormal];
        _minusBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        _minusBtn.backgroundColor = [UIColor spThemeColor];
        _minusBtn.tag = 11;
        [_minusBtn addTarget:self action:@selector(minusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_minusBtn];

        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_minusBtn.right, _minusBtn.top, 40, 20)];
        _numLabel.textColor = [UIColor black4];
        _numLabel.backgroundColor = [UIColor spBackgroundColor];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = [UIFont systemFontOfSize:text_font-2];
        [bgView addSubview:_numLabel];
        
        
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(_numLabel.right, _numLabel.top, 20, 20)];
        [_addBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        _addBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        _addBtn.backgroundColor = [UIColor spThemeColor];
        _addBtn.tag = 12;
        [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_addBtn];
        
        _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, _addBtn.top, 15, 20)];
        _deleteButton.right = bgView.width-padding;
        [_deleteButton setImage:[UIImage imageNamed:@"rubbish-red"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_deleteButton];
        
        if (self.isSelected) {
            _numLabel.left = self.frame.size.width - herizon_padding-33;
            [_minusBtn removeFromSuperview];
            [_addBtn removeFromSuperview];
        }
    }
    return self;

}

- (void)changePriceLableAndNumLableFrame{
    _priceLabel.bottom = _numLabel.bottom;
    _numLabel.right = NAScreenWidth-20;
}

- (void)deleteButtonClicked:(UIButton *)button{
    [self.delegate deleteButtonClicked:_index];
}
- (void)selectButtonClicked:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
         _selectimgView.image = [UIImage imageNamed:@"circle_selected"];
        [self.delegate selectByIndex:_index isSlect:YES];
    }else{
         _selectimgView.image = [UIImage imageNamed:@"circle_unselected"];
        [self.delegate selectByIndex:_index isSlect:NO];
    }
}
- (void)minusBtnAction:(UIButton *)button{
    
  [self.delegate clickIndex:_index isAdd:NO isSelect:_selectButton.selected];
//  [self.delegate clickIndex:_index andFlag:button.tag];
}

- (void)addBtnAction:(UIButton *)button{
  [self.delegate clickIndex:_index isAdd:YES isSelect:_selectButton.selected];
//  [self.delegate clickIndex:_index andFlag:button.tag];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
