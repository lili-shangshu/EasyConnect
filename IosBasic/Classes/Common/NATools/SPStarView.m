//
//  SPStarView.m
//  IosBasic
//
//  Created by Nathan Ou on 15/4/15.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "SPStarView.h"

@interface SPStarView ()

@property (nonatomic, strong) NSMutableArray *starsArray;

@end

@implementation SPStarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        CGFloat padding = 3.f;
        CGFloat topPadding = 0;
        
        for (int i = 0; i < 5; i ++) {
            UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
            starButton.userInteractionEnabled = NO;
            UIImage *starImage = [UIImage imageNamed:@"star_yellow"];
            [starButton setImage:starImage forState:UIControlStateNormal];
            [starButton setImage:[UIImage imageNamed:@"star_gray"] forState:UIControlStateDisabled];
            starButton.size = starImage.size;
            starButton.left = (starButton.size.width+padding)*i;
            starButton.top = topPadding;
            
            [self addSubview:starButton];
            if (i == 5-1) {
                self.height = starButton.height+topPadding*2;
                self.width = starButton.right;
            }
            [self.starsArray addObject:starButton];
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

- (void)setStarViewWithNumber:(NSNumber *)number
{
    for (int i = 0; i < self.starsArray.count; i ++ ) {
        UIButton *button = self.starsArray[i];
        button.enabled = i < number.integerValue;
    }
}

@end
