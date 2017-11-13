//
//  DropDownButton.h
//  IosBasic
//
//  Created by junshi on 16/1/26.
//  Copyright © 2016年 CRZ. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol showMenuDelegate <NSObject>

- (void) showMenu:(UIButton *)selectedButton;
- (void) hideMenu;

@end


@interface DropDownButton : UIView{
    NSInteger _count;
    NSInteger _lastTap;
    NSString *_lastTapObj;
    UIImage *_image;
    BOOL _isButton;
}

@property (nonatomic,strong) UIImageView *buttonImageView;
@property (nonatomic,assign) id<showMenuDelegate> delegate;


- (id)initDropDownButtonWithTitles:(NSArray *)titles;

@end
