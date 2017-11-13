//
//  NANavigationController.m
//  IosBasic
//
//  Created by Nathan Ou on 15/4/6.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "NANavigationController.h"

@interface NANavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, weak) id PopDelegate;

@end

@implementation NANavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 自定义 leftbutton 后 让 手势效果依旧生效
    self.PopDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 自定义 leftbutton 后 让 手势效果依旧生效
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.PopDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end
