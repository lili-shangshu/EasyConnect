//
//  OrdersController.m
//  IosBasic
//
//  Created by li jun on 16/10/10.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "OrdersController.h"
#import "SCNavTabBarController.h"
#import "OrdersManagerController.h"

#define  kAll @"全部"
#define kPay  @"待付款"
#define kCommit @"待评价"
#define kSend @"待发货"
#define kAccept @"待收货"

@interface OrdersManagerController ()

@property (nonatomic, strong) SCNavTabBarController *scorllVC;

@end

@implementation OrdersManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    OrdersController *order1 = [[OrdersController alloc]init];
    order1.title = @"全部";
    order1.typeIndex = 1;

    OrdersController *order2 = [[OrdersController alloc]init];
    order2.title = @"待付款";
    order2.typeIndex = 2;
    
    OrdersController *order3 = [[OrdersController alloc]init];
    order3.title = @"待发货";
    order3.typeIndex = 3;
    
    OrdersController *order4 = [[OrdersController alloc]init];
    order4.title = @"待收货";
    order4.typeIndex = 4;
    
    OrdersController *order5 = [[OrdersController alloc]init];
    order5.title = @"已完成";
    order5.typeIndex = 5;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[order1,order2,order3,order4,order5];
//  navTabBarController.subViewControllers = @[order1,order3,order4,order5];
    
    if (self.selectNum) {
         navTabBarController.selectedIndex = [self.selectNum integerValue]+1;
    }else{
         navTabBarController.selectedIndex = 0;
    }
    navTabBarController.view.height = self.view.height;
    navTabBarController.view.backgroundColor = [UIColor whiteColor];
    [navTabBarController addParentController:self];
    self.scorllVC = navTabBarController;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [self addBackButton];
    if (self.selectNum) {
        self.title = [self indexStringByNum:self.selectNum];
    }else{
        self.title = @"我的订单";
    }
    self.navigationController.navigationBarHidden = NO;
}
- (void)backBarButtonPressed:(id)backBarButtonPressed{
    if (self.nofromMy) {
        // 需要跳转到我的页面
//        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.mainTabBarController setSelectedIndex:3];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)indexStringByNum:(NSNumber *)number{
    int num = [number intValue];
    switch (num) {
        case 0:
            return kPay;
            break;
        case 1:
            return kSend;
            break;
        case 2:
            return kAccept;
            break;
        case 3:
            return kCommit;
            break;
        default:
            return @"我的订单";
            break;
    }
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
