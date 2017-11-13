//
//  NANumberView.m
//  IosBasic
//
//  Created by junshi on 16/1/18.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NANumberView.h"

@interface NANumberView()

@end

@implementation NANumberView

- (instancetype)initWithFrame:(CGRect)frame withOutColor:(UIColor *)outColor withInColor:(UIColor *)inColor{
    self = [super initWithFrame:frame];
    if(self){
       
       UIView *outView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
      
       outView.layer.cornerRadius = outView.width/2;
       outView.backgroundColor = outColor;
       
       UIView *inView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, outView.width-2, outView.height-2)];
       inView.layer.cornerRadius = inView.width/2;
       inView.backgroundColor = inColor;
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, inView.width, inView.height)];
        _numberLabel.font = [UIFont systemFontOfSize:9];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.textAlignment = UITextAlignmentCenter;
        [inView addSubview:_numberLabel];
        
        [outView addSubview:inView];
        [self addSubview:outView];

    }
    return self;
}

@end