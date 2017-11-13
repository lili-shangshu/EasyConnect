//
//  MMMySetSubView.h
//  IosBasic
//
//  Created by Star on 2017/6/14.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMySetSubView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

-(void)initWithFrame:(CGRect)frame WithType:(NSInteger)typeNum;

@property (nonatomic, strong) void(^confirmButtonBlock)(NSString *text);

@end
