//
//  TImerViewController.h
//  IosBasic
//
//  Created by Star on 2017/11/13.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface TImerViewController : NARootController

@property (weak, nonatomic) IBOutlet UILabel *nowDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowTimeLable;

@property (weak, nonatomic) IBOutlet UIView *totalHoursView;
@property (weak, nonatomic) IBOutlet UILabel *totalTImeLable;

@property (weak, nonatomic) IBOutlet UIView *starAndFinishView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statAndFinishHeight;

@property (weak, nonatomic) IBOutlet UIImageView *finishImg;
@property (weak, nonatomic) IBOutlet UILabel *finishTital;
@property (weak, nonatomic) IBOutlet UILabel *finishTImelable;
@property (weak, nonatomic) IBOutlet UILabel *statTimeLable;

@property (weak, nonatomic) IBOutlet UIButton *StarButton;
@property (weak, nonatomic) IBOutlet UILabel *buttonBottomLable;

@end
