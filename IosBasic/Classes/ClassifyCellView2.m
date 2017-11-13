//
//  ClassifyCellView2.m
//  IosBasic
//
//  Created by li jun on 17/4/28.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "ClassifyCellView2.h"
#define padding 10.f
#define textSize 15.f

@interface ClassifyCellView2()

@property(strong,nonatomic)UIView *whitBGView;

@end


@implementation ClassifyCellView2

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *redBGView = [[UIView alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, 40)];
        redBGView.backgroundColor = [UIColor red2];
        [self addSubview:redBGView];
        
        UIView *whiteBG = [[UIView alloc]initWithFrame:CGRectMake(padding, redBGView.bottom, NAScreenWidth-2*padding, 10)];
        whiteBG.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteBG];
        
        UIImageView *cateImage = [[UIImageView alloc]initWithFrame:CGRectMake(padding, padding, 20, 20)];
        _categoryImageView = cateImage;
        [redBGView addSubview:cateImage];
        
        UILabel *cateNameLable = [[UILabel alloc]initWithFrame:CGRectMake(cateImage.right+padding, 5, redBGView.width-cateImage.right-20, 30)];
        [cateNameLable setLabelWith:@"" color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:textSize+1] aliment:NSTextAlignmentLeft];
        _catagoryTitleLable = cateNameLable;
        
        cateNameLable.userInteractionEnabled = YES;
        UIButton *button = [[UIButton alloc]initWithFrame:cateNameLable.bounds];
        [button addTarget:self action:@selector(clickGoodsButton:) forControlEvents:UIControlEventTouchUpInside];
        [cateNameLable addSubview:button];
        
        
        [redBGView addSubview:cateNameLable];
        
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(padding, whiteBG.bottom, redBGView.width, 150)];
        bgview.backgroundColor = [UIColor whiteColor];
        bgview.userInteractionEnabled = YES;
        self.whitBGView = bgview;
        [self addSubview:bgview];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
// 每行3个，以此排列 每个大小  UIVIEW 90 * 90 image的大小，20*90
+ (CGFloat)ViewHeightproductArray:(NSArray *)goodsArray{
    float Lalbeheight = 10+5+30+5+10;
    float cellheight  = 0;
    
    float height = (NAScreenWidth-2*padding-4*padding)/3/4+10;
//    height+=height/4;
    
    if (goodsArray.count%3 == 0) {
        cellheight = Lalbeheight+(goodsArray.count/3)*height;
    }else{
        cellheight = Lalbeheight+(goodsArray.count/3+1)*height;
    }
    
    return cellheight;
}
- (void)UpdateViewWithProduct:(ECClassifyGoodsObject *)classGoodsobj withproductArray:(NSArray *)goodsArray{
    self.goodsArray = goodsArray;
    self.catagoryTitleLable.text = classGoodsobj.name;
//    self.categoryImageView.image = [UIImage imageNamed:@"ic_cate"];
    [self.categoryImageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:classGoodsobj.imageUrl3]];
    
    float height = (NAScreenWidth-2*padding-4*padding)/3;
    float cellheight  = height/4+10;
    if (goodsArray.count%3 == 0) {
        cellheight = (goodsArray.count/3)*cellheight;
    }else{
        cellheight = (goodsArray.count/3+1)*cellheight;
    }
    
    self.whitBGView.height = cellheight;
    self.height = self.whitBGView.bottom;
    
    [self.whitBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<goodsArray.count; i++) {
        int leftt =  i%3;//  0 1 2
        ECClassifyGoodsObject *goodsObj = goodsArray[i];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(leftt*(height+10)+10, (i/3)*(height/4+10), height, height/4)];
        [button addTarget:self action:@selector(clickGoodsButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [[UIColor spBackgroundColor] CGColor];
        button.layer.borderWidth = 1;
        [self.whitBGView addSubview:button];
        
        UILabel *cateNameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, button.width, button.height)];
        [cateNameLable setLabelWith:goodsObj.name color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:textSize-1] aliment:NSTextAlignmentCenter];
        [button addSubview:cateNameLable];
    }
    
}
- (void)clickGoodsButton:(UIButton *)button{
    
    NSLog(@"%@",@"点击了");
    ECClassifyGoodsObject *objec = self.goodsArray[button.tag];
    [self.delegate clickedCategoods:objec];
    
}
@end
