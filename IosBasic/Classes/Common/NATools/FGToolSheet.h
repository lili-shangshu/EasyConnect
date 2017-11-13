//
//  FGPhotoToolSheet.h
//  FlyGift
//
//  Created by Nathan Ou on 14/12/30.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGToolSheet : UIView

- (void)show;
- (void)showWithCompletion:(void(^)())block;
- (void)hide;
- (void)hideWithCompletion:(void(^)())block;

- (void)setLeftButtonImage:(UIImage *)image title:(NSString *)title action:(void(^)())block;
- (void)setRightButtonImage:(UIImage *)image title:(NSString *)title action:(void(^)())block;

@end
