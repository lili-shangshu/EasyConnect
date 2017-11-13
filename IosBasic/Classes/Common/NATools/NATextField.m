//
//  NATextField.m
//  IosBasic
//
//  Created by junshi on 2017/5/9.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "NATextField.h"

@interface NATextField ()

@end


@implementation NATextField


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, NAScreenWidth,44)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(NAScreenWidth - 60, 7,50, 30)];
    [button setTitle:@"完成"forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blue1] forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor blue1].CGColor;
    button.layer.borderWidth =1;
    button.layer.cornerRadius =3;
    [bar addSubview:button];
    self.inputAccessoryView = bar;
    
    [button addTarget:self action:@selector(print)forControlEvents:UIControlEventTouchUpInside];
}

- (void) print {
    NSLog(@"button click");
    
    if(self.tag == 100){
    // 操作积分
    NAPostNotification(kSPOperationPoints, nil);
    }
    
    
        //统一收起键盘
    NAPostNotification(kSPHideKeyboard, nil);
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
