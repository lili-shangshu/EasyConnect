//
//  PageControlView.m
//  IosBasic
//
//  Created by junshi on 16/2/17.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "PageControlView.h"

@interface PageControlView ()

@property (nonatomic, strong) NSMutableArray *starsArray;

@end

@implementation PageControlView

- (instancetype)initWithNumberOfPages : (int) numberOfPages height:(int)height width:(int)width imageStateNormal:(UIImage *)imageNormal imageStateHighlighted:(UIImage *)imagelighted
{
    self = [super init];
    _numberOfPages = numberOfPages;
    _imagePageStateNormal = imageNormal;
    _imagePageStateHighlighted = imagelighted;
    if (self) {
        
        CGFloat padding = 10.f;
        CGFloat topPadding = 0;
        
        for (int i = 0; i < _numberOfPages; i ++) {
            
            UIImageView *imgView = [[UIImageView alloc] init];
            if(i==0){
                imgView.image = imagelighted;
            }else{
                imgView.image = imageNormal;
            }
            imgView.height = height;
            imgView.width = width;
            imgView.left = (imgView.width + padding)*i;
            imgView.top = topPadding;
            imgView.layer.cornerRadius = imgView.width/2;
            [self addSubview:imgView];
            
            [self.starsArray addObject:imgView];
        }
    }
    return self;
}

- (NSMutableArray *)starsArray
{
    if (!_starsArray) {
        _starsArray =  [NSMutableArray array];
    }
    return _starsArray;
}

- (void)setCurrentPage:(int) currentPage
{
    _currentPage = currentPage;
    for (int i = 0; i < _numberOfPages; i ++ ) {
        UIImageView *imgView = self.starsArray[i];
        if(i==currentPage){
            imgView.image = _imagePageStateHighlighted;
        }else{
            imgView.image = _imagePageStateNormal;
        }
    }
}

@end

