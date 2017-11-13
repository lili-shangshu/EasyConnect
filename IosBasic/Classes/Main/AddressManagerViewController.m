//
//  AddressManagerViewController.m
//  IosBasic
//
//  Created by Star on 2017/11/1.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "AddressManagerViewController.h"

#import "AdressViewController.h"
#import "SCNavTabBarController.h"


@interface AddressManagerViewController ()

@end

@implementation AddressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AdressViewController *chinaVC = [[AdressViewController alloc]init];
    chinaVC.isChange = @"1";
    chinaVC.isFromMine = YES;
    chinaVC.title = @"中国";
    
    AdressViewController *auiVC = [[AdressViewController alloc]init];
    auiVC.isChange = @"2";
    auiVC.title = @"澳大利亚";
    auiVC.isFromMine = YES;
//    self.view.backgroundColor = [UIColor whiteColor];
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[chinaVC,auiVC];
    navTabBarController.view.height = self.view.height;
    navTabBarController.view.backgroundColor = [UIColor whiteColor];
    [navTabBarController addParentController:self];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addBackButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
