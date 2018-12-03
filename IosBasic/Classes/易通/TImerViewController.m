//
//  TImerViewController.m
//  IosBasic
//
//  Created by Star on 2017/11/13.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#define kUpdateTime 60

#define kUpdateLogin 100


#import "TImerViewController.h"
#import "SetViewController.h"
#import "ChatController.h"
#import "LoginViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <Corelocation/CLLocationManagerDelegate.h>

@interface TImerViewController ()<CLLocationManagerDelegate>

@property(nonatomic,strong)NSTimer *nowTimer;
@property(nonatomic)NSInteger updateLocationNumber;
@property(nonatomic)NSInteger testLoginNumber;


@property(nonatomic,strong)NSDate *starDate;
//@property(nonatomic,strong)NSDate *endDate;

@property(nonatomic)NSInteger buttonClickedNum;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *myLocation;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *lattitude;


@end

@implementation TImerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 放到viewWillAppear 里面
    
    self.nowDateLabel.text = [NSString backDateString:[NSDate date]];
    _nowTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateNowTime) userInfo:nil repeats:YES];
    
    // 登录后，刷新页面，如果在登录，则获取首页信息，否则 重置页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged) name:kSPLoginStatusChanged object:nil];
    [self loginStatusChanged];
    
//    [self check];
    
    //创建定位管理器，
    _locationManager = [[CLLocationManager alloc] init];
    //定位精确度
    _locationManager.desiredAccuracy = 20;
    //设置每隔100米更新位置
    _locationManager.distanceFilter = 100;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
//    _locationManager.allowsBackgroundLocationUpdates = YES;
    
    // 5.iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        _locationManager.allowsBackgroundLocationUpdates = YES;
    }
    
    
    [_locationManager setDelegate:self];
    
    // 必须启动定位使用授权才能定位
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
      //  如果需要在前后台定位
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //开始定位服务
    [_locationManager startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChatVC) name:kSisTime object:nil];
    
}

- (void)showChatVC{
    [self chatButtonClicked:nil];
}


- (void)updateNowTime{
    
    _updateLocationNumber ++;
    _testLoginNumber ++;
//    NSLog(@"定时器在走");
    
    if (_buttonClickedNum%3==2) {
        // 上传定位----60秒传一次
        [self.locationManager startUpdatingLocation];
        if (_updateLocationNumber==kUpdateTime) {
            _updateLocationNumber = 0;
            // 调用上传位置的方法
            if (self.currentMember) {
                [self updateLocation];
            }
        }
    }else{
        [self.locationManager stopUpdatingLocation];
    }
    
    if (_testLoginNumber==kUpdateLogin) {
        _testLoginNumber = 0;
        if (self.currentMember) {
               [self checkLogin];
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dataStr =[dateFormatter stringFromDate:[NSDate date]];
    self.nowTimeLable.text = dataStr;
    if (_buttonClickedNum%3==1) {
        self.statTimeLable.text = dataStr;
    }else if (_buttonClickedNum%3==2){
        self.finishTImelable.text = dataStr;
    }
}

- (void)updateLocation{
    if ([self.lattitude integerValue]!=0) {
        if ([NADefaults sharedDefaults].currentMemberId2) {
            NSDictionary *dci = @{m_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell,@"lat":_lattitude,@"lng":_longitude,@"working_id":[NADefaults sharedDefaults].currentMemberId2};
            [[SPNetworkManager sharedClient] postUpdateLocationWithParams:dci completion:^(BOOL succeeded, id responseObject, NSError *error) {
                if (succeeded) {
                    NSLog(@"上传成功");
                }
            }];
        }
    }
}
- (void)checkLogin{
    NSDictionary *dci = @{m_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell};
    [[SPNetworkManager sharedClient] postcheckLoginWithParams:dci completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            NSString *dateStr= responseObject;
                if (![dateStr isEqualToString:NAGetUDID()]) {
                    // 不同了
                     [NADefaults sharedDefaults].currentMemberId = nil;
                     [self loginStatusChanged];
                }
        }
    }];
}

- (void)loginStatusChanged{
    if (self.currentMember) {
        
        if ([self.currentMember.start_time integerValue]!=0) {
            _buttonClickedNum = 2;
        }else{
            _buttonClickedNum = 4;
        }
        
//        _buttonClickedNum = 4;
        [self updateView];
        
    }else
    {
        LoginViewController *loginContoler = [[LoginViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginContoler];
        [self presentViewController:navController animated:YES completion:^{
              // 更新首页的信息
            
        }];
        
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"TIMER";
    
    UIBarButtonItem *rightbtn = [UIBarButtonItem NA_BarButtonWithImage:[UIImage imageNamed:@"ec_set"] width:30 height:30 target:self   action:@selector(rightBtnAction)];
    self.navigationItem.leftBarButtonItems = @[rightbtn];

}

- (void)rightBtnAction{
    NSLog(@"跳转到设置页面");
    SetViewController *setVC = [[SetViewController alloc]init];
    setVC.loginoutButtonClicked = ^(BOOL success) {
        if (success) {
            NAPostNotification(kSPLoginStatusChanged, nil);
            // 如果是有正在运行的任务，则结束他。
            if ([NADefaults sharedDefaults].currentMemberId2) {
                NSDictionary *dci = @{m_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell,@"working_id":[NADefaults sharedDefaults].currentMemberId2};
                [NADefaults sharedDefaults].currentMemberId = nil;
                [[SPNetworkManager sharedClient] postEndWorkWithParams:dci completion:^(BOOL succeeded, id responseObject, NSError *error) {
                    if (succeeded) {
                        [NADefaults sharedDefaults].currentMemberId2 = nil;
                    }
                }];
            }else{
                 [NADefaults sharedDefaults].currentMemberId = nil;
            }
        }
    };
    [self.navigationController pushViewController:setVC animated:YES];
}
- (IBAction)chatButtonClicked:(id)sender {
    
    ChatController *chatVC = [[ChatController alloc]init];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)typeButtonClicked:(UIButton *)sender {
    _buttonClickedNum ++;
    [self updateView];
}
- (void)updateView{
    if (_buttonClickedNum%3==1) {
        // 界面1----未开始
        [self.statAndFinishHeight setConstant:40];
        self.finishImg.hidden = YES;
        self.finishTital.hidden = YES;
        self.finishTImelable.hidden = YES;
        self.totalHoursView.hidden = YES;
        [self.StarButton setImage:[UIImage imageNamed:@"ec_star"] forState:UIControlStateNormal];
        self.buttonBottomLable.text = @"Please press when first pick up done";
        
    }else if(_buttonClickedNum%3==2){
        // 界面2-----已经开始了
        if (_buttonClickedNum ==2) {
            // 登录的，
            [self showStarWorkView];
        }else{
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            NSDictionary *dci = @{m_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell};
            [[SPNetworkManager sharedClient] postStartWorkWithParams:dci completion:^(BOOL succeeded, id responseObject, NSError *error) {
                if (succeeded) {
                    [SVProgressHUD dismiss];
                    [self showStarWorkView];
                }
            }];
        }
        
    }else{
        // 界面3-----已经结束
       
         if ([NADefaults sharedDefaults].currentMemberId2) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
             // 修复bugly 日志
            NSDictionary *dci = @{m_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell,@"working_id":[NADefaults sharedDefaults].currentMemberId2};
            [[SPNetworkManager sharedClient] postEndWorkWithParams:dci completion:^(BOOL succeeded, id responseObject, NSError *error) {
                if (succeeded) {
                    [SVProgressHUD dismiss];
                    [NADefaults sharedDefaults].currentMemberId2 = nil;
                    [self showFinishWorkView];
                }
            }];
         }
        
        
    }
}
- (void)showStarWorkView{
    _starDate = [NSDate date];
    if (_buttonClickedNum == 2) {
        // 是登录后显示
        _starDate = [NSDate dateWithTimeIntervalSince1970:[self.currentMember.start_time integerValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *dataStr =[dateFormatter stringFromDate:_starDate];
        self.statTimeLable.text = dataStr;
    }
    
    [self.statAndFinishHeight setConstant:80];
    self.finishImg.hidden = NO;
    self.finishTital.hidden = NO;
    self.finishTImelable.hidden = NO;
    self.totalHoursView.hidden = YES;
    [self.StarButton setImage:[UIImage imageNamed:@"ec_finish"] forState:UIControlStateNormal];
    self.buttonBottomLable.text = @"Please press when last delivery done";
    
    // 获取定位发出请求
    [self updateLocation];
}
- (void)showFinishWorkView{
    [self.statAndFinishHeight setConstant:80];
    self.finishImg.hidden = NO;
    self.finishTital.hidden = NO;
    self.finishTImelable.hidden = NO;
    self.totalHoursView.hidden = NO;
    [self.StarButton setImage:[UIImage imageNamed:@"ec_done"] forState:UIControlStateNormal];
    
//    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
//    NSInteger interval1 = [zone1 secondsFromGMTForDate:_starDate];
//    NSDate *localDate1 = [_starDate dateByAddingTimeInterval:interval1];
//
//    // 时间2
//    NSDate *date2 = [NSDate date];
//    NSTimeZone *zone2 = [NSTimeZone systemTimeZone];
//    NSInteger interval2 = [zone2 secondsFromGMTForDate:date2];
//    NSDate *localDate2 = [date2 dateByAddingTimeInterval:interval2];
//
//
//
//    // 时间2与时间1之间的时间差（秒）
//    double intervalTime = [localDate2 timeIntervalSinceReferenceDate] - [localDate1 timeIntervalSinceReferenceDate];
    
    double intervalTime =[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue] - [[NSNumber numberWithDouble:[_starDate timeIntervalSince1970]] integerValue];;
    NSInteger lTime = (NSInteger)intervalTime;
    
    NSString *hhStr = [NSString stringWithFormat:@"%li",(lTime / 3600)];
    NSString *mmStr = [NSString stringWithFormat:@"%li",((lTime / 60) % 60)];
    NSString *ssStr = [NSString stringWithFormat:@"%li",(lTime % 60)];
    
   
    if ([hhStr intValue]>0) {
        self.totalTImeLable.text = [NSString stringWithFormat:@"%d HRS %d MINS",[hhStr intValue],[mmStr intValue]];
    }else{
        self.totalTImeLable.text = [NSString stringWithFormat:@"%d MINS",[mmStr intValue]];
    }
    
    if (hhStr.length == 1) {
        hhStr = [NSString stringWithFormat:@"0%@",hhStr];
    }
    if (mmStr.length == 1) {
        mmStr = [NSString stringWithFormat:@"0%@",mmStr];
    }
    if (ssStr.length == 1) {
        ssStr = [NSString stringWithFormat:@"0%@",ssStr];
    }
    
    self.buttonBottomLable.text = [NSString stringWithFormat:@"%@:%@:%@",hhStr,mmStr,ssStr];
    
}

- (void)stopLocatingUser
{
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager  didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    // 计算距离
    CLLocationDistance meters = 0;
    if(self.myLocation){
        meters=[newLocation distanceFromLocation:self.myLocation];
    }
    
    if(!self.myLocation||meters>50){
        self.myLocation = newLocation;
        _longitude= [NSString stringWithFormat:@"%.8f", newLocation.coordinate.longitude];
        _lattitude = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.latitude];
//        NSLog(@"经纬度  %@  %@ ",_lattitude,_longitude);
    }
    
    
    //   [self getAddressByLatLng:newLocation withFromMyLocation:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 测试接口
// 结束任务------- OK
//- (void)postendWorkWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
//// 上传坐标----- OK
//- (void)postUpdateLocationWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
//// 获取聊天-----
//- (void)getChatListWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
//// 发送聊天-----
//- (void)postSendMessageListWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
//// 获取聊天短语-----
//- (void)getMessageListWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
////发送手机 token ，用于推送
//- (void)postTokenWithParams:(NSDictionary *)params completion:(SPCommonResultBlock)block;
//// 版本号
//- (void)getAppVersion:(NSDictionary *)params completion:(SPCommonResultBlock)block;

- (void)check{
    NSDictionary *dci = @{m_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell,@"limits":@4,@"page":@1};
    [[SPNetworkManager sharedClient] getChatListWithParams:dci completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        }
    }];
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
