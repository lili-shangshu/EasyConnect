//
//  PushMessageController.m
//  IosBasic
//
//  Created by junshi on 16/9/1.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "PushMessageController.h"


#define  herizon_padding 20
#define  vertical_padding 30
#define  label_height 65
#define  font_size 17
#define  percent 0.64
#define  title_width 100
#define  title_height 44
#define  title_font_size 17

@interface PushMessageController ()


@end

@implementation PushMessageController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor spBackgroundColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = _message;
    label.textColor = [UIColor spBrownColor];
    label.font = [UIFont systemFontOfSize:15];
//    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    
    label.left = 20.f;
    label.width = self.view.width - 40;
    label.top = 20 ;
    [label sizeToFit];
    [self.view addSubview:label];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, title_width, title_height)];
    
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, title_height-4, title_height-4)];
    circleView.layer.cornerRadius = circleView.width/2;
    circleView.layer.borderColor =  [[UIColor whiteColor] CGColor];
    circleView.layer.borderWidth = 1.f;
    circleView.alpha = 0.25;
    [titleView addSubview:circleView];
    
    UILabel *btLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, title_height-4, title_height-4)];
    [btLabel setText:@"BT"];
    [btLabel setTextAlignment:UITextAlignmentCenter];
    [btLabel setTextColor:[UIColor blue1]];
    [btLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:title_font_size]];
    [titleView addSubview:btLabel];
    
    UILabel *bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(circleView.right+10, 0, title_width, title_height)];
    [bankLabel setText:@"BANK"];
    [bankLabel setTextAlignment:UITextAlignmentLeft];
    [bankLabel setTextColor:[UIColor whiteColor]];
    [bankLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:title_font_size]];
    bankLabel.alpha = 0.3;
    [titleView addSubview:bankLabel];
    
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *backBtn = [UIBarButtonItem NA_BarButtonWithImage:[UIImage imageNamed:@"ic_arrow_left"] width:12 height:22 target:self   action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    
}

- (void)backBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
