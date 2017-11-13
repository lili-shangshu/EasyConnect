//
//  UITabBar+NATools.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/31.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (NATools)

- (void)showBagePont:(BOOL)show forIndex:(NSInteger)index;

- (void)showBagePont:(BOOL)show withNum:(NSInteger)number forIndex:(NSInteger)index;
@end
