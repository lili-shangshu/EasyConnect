//
//  AgentApplyController.m
//  IosBasic
//
//  Created by junshi on 2017/5/11.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "AgentApplyController.h"
#import "SPNetworkManager.h"
#import <PSPDFActionSheet.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

#import <CTAssetsPickerController.h>
#import "NACTPageViewController.h"
#import "NAEmotionsView.h"
#import <Reachability.h>
#import "OTAvatarImagePicker.h"
#import "HcdDateTimePickerView.h"

@interface AgentApplyController ()<OTAvatarImagePickerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIButton *birthButton;
@property (weak, nonatomic) IBOutlet UIButton *idCardUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *idCardBackBtn;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic, strong) UIImage *positiveImg,*inverseImg;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic,strong) NSString *birthDay;
@property(strong,nonatomic)HcdDateTimePickerView *dateTimePickerView;

@property (nonatomic,strong) UIView *dataPickerView;
@property (nonatomic,retain) UIDatePicker *datePicker;

@end

@implementation AgentApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor gray5];
    _idCardUpBtn.tag = 1;
    _idCardBackBtn.tag = 2;
    
     [self addBackgroundTapAction];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self addBackButton];

}


- (IBAction)idCardUpAction:(id)sender {
    
    _selectBtn = (UIButton *)sender;
    
    PSPDFActionSheet *sheet = [[PSPDFActionSheet alloc] init];
    
    [sheet addButtonWithTitle:@"使用照相机拍照" block:^(NSInteger index){
        [self cameraButtonAction];
        
    }];
    
    [sheet addButtonWithTitle:@"从相册中选择图片" block:^(NSInteger index){
        [self albumButtonAction];
    }];
    
    [sheet setCancelButtonWithTitle:@"取消" block:^(NSInteger index){}];
    
    //    [sheet showFromRect:self.mainWindow.frame inView:self.mainWindow animated:YES];
    [sheet showInView:self.mainWindow];


    
}
- (IBAction)idCardBackAction:(id)sender {
     _selectBtn = (UIButton *)sender;
    
    PSPDFActionSheet *sheet = [[PSPDFActionSheet alloc] init];
    
    [sheet addButtonWithTitle:@"使用照相机拍照" block:^(NSInteger index){
        [self cameraButtonAction];
        
    }];
    
    [sheet addButtonWithTitle:@"从相册中选择图片" block:^(NSInteger index){
        [self albumButtonAction];
    }];
    
    [sheet setCancelButtonWithTitle:@"取消" block:^(NSInteger index){}];
    
    //    [sheet showFromRect:self.mainWindow.frame inView:self.mainWindow animated:YES];
    [sheet showInView:self.mainWindow];

}


- (IBAction)birthAction:(id)sender {
//    
//    _dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY"];
//    NSString *currentDateStr = @"";
//    NSDate *date =[NSDate date];
//    currentDateStr = [dateFormatter stringFromDate:date];
//    NSInteger year = [currentDateStr integerValue];
//    
//    [_dateTimePickerView setMinYear:year];
//    [_dateTimePickerView setMaxYear:year+2];
//    
//    _dateTimePickerView.title = @" ";
//    _dateTimePickerView.titleColor = [UIColor blueA2];
//    
//    _dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
//        NSLog(@"%@", datetimeStr);
//        _birthDay = datetimeStr;
//        [_birthButton setTitle:datetimeStr forState:UIControlStateNormal];
//        
//    };
//    _dateTimePickerView.clickedCancleBtn = ^(NSString *str){
//        
//    };
//    
//    if (_dateTimePickerView) {
//        
//        
//        _dateTimePickerView.frame =CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height);
//        [self.view addSubview:_dateTimePickerView];
//
//        
//        [_dateTimePickerView showHcdDateTimePicker];
//    }
    
    if(!self.dataPickerView){
        
        NSDate *currentTime = [NSDate date];
        
        UIDatePicker *date=[[UIDatePicker alloc]init];
        date.datePickerMode=UIDatePickerModeDate;
        [date setDate:currentTime animated:YES];
        [date setMaximumDate:currentTime];
        
        date.width = self.view.width;
        self.datePicker = date;
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 35)];
        titleView.backgroundColor = [UIColor blueA2];
        
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width/4, 35)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:cancelButton];
        
        UIButton *oKButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width*3/4, 0, self.view.width/4, 35)];
        [oKButton setTitle:@"确定" forState:UIControlStateNormal];
        [oKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [oKButton addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:oKButton];
        
        
        UIView *dataPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-date.height-cancelButton.height, self.view.width, date.height+cancelButton.height)];
        self.dataPickerView = dataPickerView;
        
        dataPickerView.backgroundColor = [UIColor whiteColor];;
        date.top = cancelButton.bottom;
        // 竖直分界线
//        UIView *middleLine = [UIView lineWithHeight:cancelButton.height xPoint:cancelButton.right withColor:[UIColor spLineColor]];

        [dataPickerView addSubview:date];
        [dataPickerView addSubview:titleView];
        [self.view addSubview:dataPickerView];
    }else{
        self.dataPickerView.hidden = NO;
    }
    
}

- (void)cancelButtonAction:(id)sender{
    
    //隐藏动画
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.7;
    [self.dataPickerView.layer addAnimation:animation forKey:nil];
    self.dataPickerView.hidden = YES;
}

- (void)okButtonAction:(id)sender{
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *timestamp = [formatter stringFromDate:self.datePicker.date];
    _birthDay = timestamp;
    [_birthButton setTitle:timestamp forState:UIControlStateNormal];
    
    //隐藏动画
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.7;
    [self.dataPickerView.layer addAnimation:animation forKey:nil];
    self.dataPickerView.hidden = YES;
    
}


- (IBAction)registAction:(id)sender {
    
    //统一收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    
    if([_userNameField.text isEmptyString]){
        [SVProgressHUD showInfoWithStatus:@"真实姓名不能为空"];
        return;
    }
    if([_phoneField.text isEmptyString]){
        [SVProgressHUD showInfoWithStatus:@"固定电话不能为空"];
        return;
    }
    if(!_birthDay){
        [SVProgressHUD showInfoWithStatus:@"请选择出生日期"];
        return;
    }
    
    if(!_positiveImg){
        [SVProgressHUD showInfoWithStatus:@"请选择身份证号码正面"];
        return;
    }
    if(!_inverseImg){
        [SVProgressHUD showInfoWithStatus:@"请选择身份证号码反面"];
        return;
    }
    
    
    NSDictionary *params = @{@"ture_name":_userNameField.text,@"telephone":_phoneField.text,@"birthday":_birthDay, m_member_user_shell:self.currentMember.memberShell, m_id: self.currentMember.id};
    
    [SVProgressHUD show];
    [[SPNetworkManager sharedClient] applyAgentWithParams:params image:_positiveImg image2:_inverseImg completion:^(BOOL succeeded, id responseObject ,NSError *error){
        if (succeeded){
            
            [SVProgressHUD showInfoWithStatus:@"申请提交成功"];
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            
        }
    }];

    
    
}

- (void)backgroundTapAction:(id)sensor
{
    [self hideKeyBoard];
    
}

#pragma mark---UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect frame=[textField convertRect: textField.bounds toView:window];
    
    //    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    int offset = frame.origin.y + 38 - (self.view.frame.size.height - 252.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




#pragma mark ----xiangji
- (void)cameraButtonAction
{
    [[OTAvatarImagePicker sharedInstance] setDelegate:nil];
    [[OTAvatarImagePicker sharedInstance] setDelegate:self];
    [[OTAvatarImagePicker sharedInstance] getImageFromCameraInIphone:self];
}

- (void)albumButtonAction
{
    [[OTAvatarImagePicker sharedInstance] setDelegate:nil];
    [[OTAvatarImagePicker sharedInstance] setDelegate:self];
    [[OTAvatarImagePicker sharedInstance] getImageFromAlbumInIphone:self];
}

- (void)getImageFromWidget:(UIImage *)image
{
    NSInteger tag = _selectBtn.tag;
    if(tag == 1){
        [_idCardUpBtn setBackgroundImage:image forState:UIControlStateNormal];
        _positiveImg = image;
    }else{
        [_idCardBackBtn setBackgroundImage:image forState:UIControlStateNormal];
        _inverseImg = image;
    }
}


@end

