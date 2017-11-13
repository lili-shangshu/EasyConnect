//
//  MainSubView.m
//  IosBasic
//
//  Created by li jun on 16/11/24.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "MainSubView.h"

@implementation MainSubView
// 一半就为高的一半
-(id)initHotWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor spBackgroundColor];
    if (self) {
        float height = frame.size.height;
        // 4个小的
        for (int n = 0; n<2; n++) {
            for (int m = 0; m<2; m++) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(m*height/2, n*height/2, height/2-1, height/2-1)];
                imageView.userInteractionEnabled = YES;
                
                UIButton *button = [[UIButton alloc]initWithFrame:imageView.bounds];
                
                [button addTarget:self action:@selector(imageViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = m+n*2;
                [imageView addSubview:button];
                
                [self addSubview:imageView];
            }
        }
        
        // 一个大的
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(height, 0, NAScreenWidth-height, height)];      
        imageView.userInteractionEnabled = YES;
        
        UIButton *button = [[UIButton alloc]initWithFrame:imageView.bounds];
        
        [button addTarget:self action:@selector(imageViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 4;
        [imageView addSubview:button];
        
        [self addSubview:imageView];
        
    }
    
    return self;
}

//   2   3 组合
-(id)initNewWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
     self.backgroundColor = [UIColor spBackgroundColor];
    if (self) {
        float height = frame.size.height;
        
        //2个小的
        for (int i = 0; i<2; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*NAScreenWidth/2, 0, NAScreenWidth/2-1, height*2/3-1)];
            imageView.userInteractionEnabled = YES;
            
            UIButton *button = [[UIButton alloc]initWithFrame:imageView.bounds];
            
            [button addTarget:self action:@selector(imageViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [imageView addSubview:button];
            
            [self addSubview:imageView];
        }
        
        for (int i = 2; i<5; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i-2)*NAScreenWidth/3, height*2/3, NAScreenWidth/3-1, height/3)];
            imageView.userInteractionEnabled = YES;
            
            UIButton *button = [[UIButton alloc]initWithFrame:imageView.bounds];
            [button addTarget:self action:@selector(imageViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [imageView addSubview:button];
            
            [self addSubview:imageView];
        }
        
        
    }
    
    return self;
}
//4 3 
-(id)initOtherWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        float height = frame.size.height;
        self.backgroundColor = [UIColor spBackgroundColor];
//        上1
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth*5/12-1, height*3/5-1)];
        imageView.userInteractionEnabled = YES;
        
        UIButton *button = [[UIButton alloc]initWithFrame:imageView.bounds];
        [button addTarget:self action:@selector(imageViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 0;
        [imageView addSubview:button];
        [self addSubview:imageView];
        
//        上2
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(NAScreenWidth*5/12, 0, NAScreenWidth*7/12, height*3/10-1)];
        imageView2.userInteractionEnabled = YES;
        
        UIButton *button2 = [[UIButton alloc]initWithFrame:imageView.bounds];
        [button2 addTarget:self action:@selector(imageViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = 1;
        [imageView2 addSubview:button2];
        [self addSubview:imageView2];
        
        for (int i = 2; i<4; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(NAScreenWidth*5/12+(i-2)*NAScreenWidth*7/24, height*3/10, NAScreenWidth*7/24-1, height*3/10-1)];
            imageView.userInteractionEnabled = YES;
            
            UIButton *button = [[UIButton alloc]initWithFrame:imageView.bounds];
            
            [button addTarget:self action:@selector(imageViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [imageView addSubview:button];
            
            [self addSubview:imageView];
        }
        
        for (int i = 4; i<7; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i-4)*NAScreenWidth/3, height*3/5, NAScreenWidth/3-1, height*2/5-1)];
            imageView.userInteractionEnabled = YES;
            
            UIButton *button = [[UIButton alloc]initWithFrame:imageView.bounds];
            [button addTarget:self action:@selector(imageViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [imageView addSubview:button];
            
            [self addSubview:imageView];
        }
        
        
    }
    
    return self;
}
- (void)updataViewWithArray:(NSArray *)array{
    self.goodsArray = array;
    NSArray *imageArray = self.subviews;
    for (int i = 0; i<imageArray.count; i++) {
        UIImageView *imageView  = imageArray[i];
        ECGoodsObject *obj = array[i];
        [imageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:obj.imageUrl]];
    }
    
}
- (void)imageViewButtonClicked:(UIButton *)button{
     ECGoodsObject *obj = self.goodsArray[button.tag];
    [self.delegate clickedGoodsImage:[obj.idNumber integerValue ]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
