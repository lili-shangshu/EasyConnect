//
//  MemberController.m
//  IosBasic
//
//  Created by junshi on 2017/5/11.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "MemberController.h"

@interface MemberController ()
@property (weak, nonatomic) IBOutlet UILabel *levelLbl;
@property (weak, nonatomic) IBOutlet UILabel *pointsLbl;

@end

@implementation MemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor gray5];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self addBackButton];
    self.title = @"我的会员";
    _levelLbl.text = self.currentMember.levelStr;
    _pointsLbl.text = [self.currentMember.points stringValue];
}


@end

