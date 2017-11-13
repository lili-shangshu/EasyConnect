//
//  RegisterController.m
//  IosBasic
//
//  Created by li jun on 16/11/1.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "RegisterController.h"

#import "RegisterTwoController.h"
#import "RegisterOneController.h"
#import "SCNavTabBarController.h"

@interface RegisterController ()

@property (nonatomic, strong) SCNavTabBarController *scorllVC;
@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RegisterOneController *oneVC = [[RegisterOneController alloc]init];
    if (self.isfind) {
        oneVC.isfind = YES;
    }
    oneVC.title = @"手机号";

    RegisterTwoController *twoVC = [[RegisterTwoController alloc]init];
    if (self.isfind) {
        twoVC.isfind = YES;
    }
    twoVC.title = @"邮箱";
    
    self.view.backgroundColor = [UIColor whiteColor];
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[oneVC,twoVC];
   
    navTabBarController.selectedIndex = 0;

    navTabBarController.view.height = self.view.height;
    navTabBarController.view.backgroundColor = [UIColor whiteColor];
    [navTabBarController addParentController:self];
    self.scorllVC = navTabBarController;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addBackButton];
    if (self.isfind) {
        self.title = @"找回密码";
    }else{
       self.title = @"快速注册";
    }
    self.view.backgroundColor = [UIColor spBackgroundColor];
    
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
