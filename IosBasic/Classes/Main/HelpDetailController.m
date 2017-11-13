//
//  HelpDetailController.m
//  IosBasic
//
//  Created by li jun on 16/12/27.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "HelpDetailController.h"

#define  herizon_padding 20
#define  vertical_padding 30

@interface HelpDetailController ()

@property(nonatomic,strong)UILabel *titlelable;
@property(nonatomic,strong)UILabel *timelable;
@property(nonatomic,strong)UILabel *detaillable;


@end

@implementation HelpDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(herizon_padding, 10, NAScreenWidth-herizon_padding*2, 30)];
   [titleLbl setText:self.titleStr];
    [titleLbl setTextColor:[UIColor black2]];
    [titleLbl setFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:18]];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    _titlelable = titleLbl;
    [self.view addSubview:titleLbl];
    
    
    UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(herizon_padding, titleLbl.bottom+10, NAScreenWidth-herizon_padding*2, 15)];
    [timeLbl setText:self.time];
    [timeLbl setTextColor:[UIColor gray2]];
    [timeLbl setFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:14]];
    timeLbl.textAlignment = NSTextAlignmentCenter;
    _timelable = timeLbl;
    [self.view addSubview:timeLbl];
    
//    UILabel *subTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(herizon_padding, timeLbl.bottom+10, (NAScreenWidth-herizon_padding*2), NAScreenHeight-kNavigationHeight-titleLbl.bottom-10)];
//    [subTitleLbl setTextColor:[UIColor gray2]];
//    [subTitleLbl setFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:15]];
////    subTitleLbl.lineBreakMode = UILineBreakModeWordWrap;
//    //注意这里UILabel的numberoflines(即最大行数限制)设置成0，即不做行数限制。
//    subTitleLbl.numberOfLines = 0;
////    [subTitleLbl sizeToFit];
//    _detaillable = subTitleLbl;
//    [self.view addSubview:subTitleLbl];
    
    UIWebView *contentView = [[UIWebView alloc] initWithFrame:CGRectMake(0, timeLbl.bottom+10, NAScreenWidth, NAScreenHeight-timeLbl.bottom-10)];
    [contentView loadHTMLString:self.contentHtml baseURL:nil];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addBackButton];
    self.title = _titleStr;
    self.navigationController.navigationBarHidden = NO;
    
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
