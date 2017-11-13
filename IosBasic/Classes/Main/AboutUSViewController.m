//
//  AboutUSViewController.m
//  IosBasic
//
//  Created by li jun on 17/4/13.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "AboutUSViewController.h"

@interface AboutUSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *companyInfo;

@end

@implementation AboutUSViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self addBackButton];
    self.view.backgroundColor = [UIColor spBackgroundColor];
    self.companyInfo.backgroundColor = [UIColor clearColor];
    self.companyInfo.textColor = [UIColor blue2];
    self.title = @"联系我们";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
