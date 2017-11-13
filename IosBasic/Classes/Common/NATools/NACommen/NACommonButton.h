//
//  NACommonButton.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/19.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NACommonButton : UIButton

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *indexTitle;
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, assign) NSInteger typeNum;
@property (nonatomic, strong) UIColor *selectedColor;  //被选中的背景色
@property (nonatomic, strong) UIColor *normalColor;    // 正常的背景色

@property (nonatomic, strong) UILabel *bagelable;
// 显示角标
- (void)addBagePointWithNumber:(NSNumber *)number;


@end
