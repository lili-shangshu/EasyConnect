//
//  NACommonButton.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/19.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "NACommonButton.h"

@implementation NACommonButton


- (void)setNormalColor:(UIColor *)normalColor
{
    self.backgroundColor = normalColor;
    _normalColor = normalColor;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.backgroundColor = _selectedColor;
    }else
        self.backgroundColor = _normalColor;
}
-(UILabel *)bagelable{
    if (!_bagelable) {
       UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(self.width*0.65, self.height*0.25, 12.f, 12.f)];
        lable.font = [UIFont defaultTextFontWithSize:9];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor redColor];
        lable.layer.cornerRadius = lable.width/2.f;
        lable.layer.masksToBounds = YES;
        lable.layer.borderColor = [[UIColor redColor] CGColor];
        lable.layer.borderWidth = 1.f;
        lable.clipsToBounds = YES;
        _bagelable = lable;
        _bagelable.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bagelable];
    }
    return _bagelable;
}
- (void)addBagePointWithNumber:(NSNumber *)number{
   
    self.bagelable.text = [NSString stringWithFormat:@"%d",[number intValue]];
    if ([number intValue] == 0||!number) {
        self.bagelable.hidden = YES;
    }
}
@end
