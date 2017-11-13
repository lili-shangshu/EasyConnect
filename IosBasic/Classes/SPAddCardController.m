//
//  SPAddCardController.m
//  IosBasic
//
//  Created by junshi on 2017/5/22.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "SPAddCardController.h"
#import "SVProgressHUD.h"
#import "SPNetworkManager.h"

#define cell_height 205.f
#define herizon_padding 20.f
#define vertical_padding 10.f

#define label_font_size 15
#define field_font_size 14

@interface SPAddCardController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cardNameFld;
@property (weak, nonatomic) IBOutlet UITextField *cardNumFld;
@property (weak, nonatomic) IBOutlet UITextField *expiredFld;
@property (weak, nonatomic) IBOutlet UITextField *cvcFld;
@property (weak, nonatomic) IBOutlet UILabel *cardLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;

@end

@implementation SPAddCardController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.cardNameFld.delegate = self;
    self.cardNumFld.delegate = self;
    self.expiredFld.delegate = self;
    self.cvcFld.delegate = self;
    
    self.cardLbl.text = @"信用卡";
    self.descLbl.text = @"该支付方式只会在您使用App时使用";
    self.cardNameFld.placeholder = @"输入持卡人";
    self.cardNumFld.placeholder = @"输入卡号";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem NA_BarButtonWithtitile:@"取消" titleColor:[UIColor whiteColor] target:self action:@selector(backButtonAction:)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem NA_BarButtonWithtitile:@"保存" titleColor:[UIColor whiteColor] target:self action:@selector(saveButtonAction:)];
    
    [self addBackgroundTapAction];
    
}

- (void)backButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //  self.title = NSLocalizedString(@"my_address", "");
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

// Backgroung Tap
- (void)addBackgroundTapAction
{
    if (!self.backgroundTap) {
        self.backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapAction:)];
        [self.view addGestureRecognizer:self.backgroundTap];
    }
}

- (void)backgroundTapAction:(id)sender{
   
    [self hideKeyBoard];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 64;    // navigationBar ＋ statusBar 高度 ＝ 64
        self.view.frame = frame;
    }];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    CGFloat offset = self.view.frame.size.height - (textField.bottom+252);
    //view 整体上移
    if(offset<=0){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self recoveryStatus];
    
    return YES;
}

- (void) recoveryStatus{
    
    [self hideKeyBoard];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 64;    // navigationBar ＋ statusBar 高度 ＝ 64
        self.view.frame = frame;
    }];
    
}



- (void)saveButtonAction:(id)sender{
    
    if ([self.cardNameFld.text isEmptyString]) {
        [iToast showToastWithText:@"输入持卡人" position:iToastGravityCenter];
        return;
    }
    
    if ([self.cardNumFld.text isEmptyString]) {
        [iToast showToastWithText:@"输入卡号" position:iToastGravityCenter];
        return;
    }
    
    if ([self.expiredFld.text isEmptyString]) {
        [iToast showToastWithText:@"输入卡的有效期" position:iToastGravityCenter];
        return;
    }
    
    if ([self.cvcFld.text isEmptyString]) {
        [iToast showToastWithText:@"输入cvv" position:iToastGravityCenter];
        return;
    }
    
    NSDictionary *paramsDict = @{@"userId" : self.currentMember.id,
                                 @"number":self.cardNumFld.text,
                                 @"expirationDate":self.expiredFld.text,
                                 @"name":self.cardNameFld.text,
                                 @"cvv" : self.cvcFld.text,
                                 m_member_user_shell:[NADefaults sharedDefaults].memberUserShell
                                 };
    NSLog(@"%@",paramsDict);
    [self.navigationController popViewControllerAnimated:YES];
    
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//    [[SPNetworkManager sharedClient] postAddCardWithParams:paramsDict completion:^(BOOL succeeded, id responseObject ,NSError *error){
//            if (succeeded) {
//                [SVProgressHUD showSuccessWithStatus:CustomLocalizedString(@"card_add_succ", nil)];
//                [self.navigationController popViewControllerAnimated:YES];
//                NAPostNotification(kSPCardUpdate, nil);
//            }
//     }];
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


@end
