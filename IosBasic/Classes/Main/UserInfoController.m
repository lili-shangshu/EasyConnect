//
//  UserInfoController.m
//  IosBasic
//
//  Created by li jun on 16/10/10.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "UserInfoController.h"
#import "NAAccesorryView.h"
#import "FGNickNameEditorController.h"
#import "SPModifyPwController.h"
#import "OTAvatarImagePicker.h"
#import "UIView+TYAlertView.h"

#define k_image  @"更改头像"
#define k_nickname  @"姓名"
#define k_phone  @"手机号"
#define k_email  @"邮 箱 "
#define k_sex  @"性 别"
#define k_birth @"生 日"
#define k_city  @"居住地"



@interface UserInfoController ()<UITableViewDelegate,UITableViewDataSource,OTAvatarImagePickerDelegate>
@property(strong,nonatomic)NSArray *titles;
@property(strong,nonatomic)UIImageView *avatarimageView;
@property(strong,nonatomic)UILabel *nikcLable;
@property(strong,nonatomic)UILabel *phoneLable;
@property(strong,nonatomic)UILabel *emailLable;
@property(strong,nonatomic)UILabel *sexLable;
@property(strong,nonatomic)UILabel *birthdayLable;
@property(strong,nonatomic)UILabel *cityLable;

@end

@implementation UserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor gray5];
    self.titles = @[k_image,k_nickname,k_phone,k_email,k_sex];
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.height = self.view.height - kTransulatInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView hideExtraCellHide];
    [self.tableView tableviewSetZeroInsets];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self addBackButton];
    self.title = @"个人资料";
    self.navigationController.navigationBarHidden = NO;

}
#pragma mark - TableView Delegate & DataSource
////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.titles[indexPath.row];
    if ([str isEqualToString:k_image]) {
        return kDefautCellHeight+20;
    }
    return kDefautCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"No need To Reuse"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NAAccesorryView *accessoryView = [[NAAccesorryView alloc] initWithFrame:CGRectMake(0, 0, 200, kDefautCellHeight)];
    accessoryView.accessoryImage = [UIImage imageNamed:@"arrowImage"];
    cell.accessoryView = accessoryView;
    
    NSString *title = [self.titles objectAtIndex:indexPath.row];
    cell.textLabel.textColor =  [UIColor NA_ColorWithR:160 g:160 b:160];
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont defaultTextFontWithSize:14];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, kDefautCellHeight-1, self.view.width-20, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0.2;
    [cell.contentView addSubview:lineView];
    
    if ([title isEqualToString:k_image])
    {
        UIImage *image = [UIImage imageNamed:@"avatar"];
        UIImageView *imageV = [[UIImageView alloc]initWithImage:image];
       if (![self.currentMember.avatar isEqualToString:@"http://warehouse.legenddigital.com.au/data/upload/data/upload/no-avatar.png"]) {
            NSString *picUrl = self.currentMember.avatar;
            [imageV setImageWithFadingAnimationWithURL:[NSURL URLWithString:picUrl]];
        }
        imageV.width = 55.f;
        imageV.height = 55.f;
        imageV.layer.masksToBounds = YES;
        imageV.layer.cornerRadius = imageV.height/2;
        imageV.layer.masksToBounds = YES;
        accessoryView.leftImageView = imageV;
        self.avatarimageView = accessoryView.leftImageView;
        lineView.top+=20;
    }
    if ([title isEqualToString:k_nickname]) {
        NSString *nickName = (self.currentMember.nickName && [self.currentMember.nickName isKindOfClass:[NSString class]] && ![self.currentMember.nickName isEqualToString:@""])? self.currentMember.nickName : kDefaultUsername;
        accessoryView.textLabel.text = nickName;
        accessoryView.textLabel.font = [UIFont defaultTextFontWithSize:12];
        self.nikcLable = accessoryView.textLabel;
    }
    if ([title isEqualToString:k_phone]) {
    
        NAAccesorryView *accessoryView2 = [[NAAccesorryView alloc] initWithFrame:CGRectMake(0, 0, 200, kDefautCellHeight)];
        accessoryView2.textLabel.text = [NSString stringWithFormat:@"+%@",self.currentMember.phone];
        accessoryView2.textLabel.font = [UIFont defaultTextFontWithSize:12];
        self.phoneLable = accessoryView2.textLabel;
        cell.accessoryView = accessoryView2;
        
    }
    
    if ([title isEqualToString:k_email]) {
        
        NSString *nickName = (self.currentMember.email && [self.currentMember.email isKindOfClass:[NSString class]] && ![self.currentMember.email isEqualToString:@""])? self.currentMember.email : kDefaultUsername;
        accessoryView.textLabel.text = nickName;
        accessoryView.textLabel.font = [UIFont defaultTextFontWithSize:12];
        self.emailLable = accessoryView.textLabel;
        
    }
    
    if ([title isEqualToString:k_sex]) {
        accessoryView.textLabel.text = genderStringFrom([self.currentMember.gender intValue]);
        accessoryView.textLabel.font = [UIFont defaultTextFontWithSize:12];
        self.sexLable = accessoryView.textLabel;
        
    }

    
    
    [cell setInsetWithX:15.f];
    
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.titles[indexPath.row];
    
    if ([title isEqualToString:k_image]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *cameralAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"拍照");
            [self cameraButtonAction];
        }];
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"相册");
            [self albumButtonAction];
        }];
        [alertC addAction:cancelAction];
        [alertC addAction:cameralAction];
        [alertC addAction:albumAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    
    if ([title isEqualToString:k_nickname]) {
        
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"修改姓名" message:nil];
        alertView.buttonHeight = 40.f;
        alertView.textFeildHeight = 40.f;
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
            NSLog(@"%@",action.title);
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
            
            for (UITextField *textF in alertView.textFeilds) {
                
                [self updateNameToServer:textF.text];
            }
        }]];
        [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入姓名";
        }];
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
//    if ([title isEqualToString:k_phone]) {
//        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"修改手机号" message:nil];
//        alertView.buttonHeight = 40.f;
//        alertView.textFeildHeight = 40.f;
//        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
//            NSLog(@"%@",action.title);
//        }]];
//        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
//            
//            for (UITextField *textF in alertView.textFeilds) {
//               
//                [self updatePhoneToServer:textF.text];
//            }
//        }]];
//        [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = @"请输入电话号码";
//        }];
//        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
    
    
    if ([title isEqualToString:k_email]) {
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"修改邮箱" message:nil];
        alertView.buttonHeight = 40.f;
        alertView.textFeildHeight = 40.f;
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
            NSLog(@"%@",action.title);
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
            
            for (UITextField *textF in alertView.textFeilds) {
                
                [self updateEmailToServer:textF.text];
            }
        }]];
        [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入邮箱地址";
        }];
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NAAccesorryView *accessoryView = (NAAccesorryView *)cell.accessoryView;
    
    if ([title isEqualToString:k_sex]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"男");
            [self updateGenderToServer:@(1)];
            accessoryView.textLabel.text = @"男";
        }];
        UIAlertAction *womamAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"女");
            [self updateGenderToServer:@(2)];
            accessoryView.textLabel.text = @"女";
        }];
        [alertC addAction:cancelAction];
        [alertC addAction:manAction];
        [alertC addAction:womamAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
   
    
}
- (void)updateGenderToServer:(NSNumber *)gender{
    
    NSDictionary *dic = @{mC_id:self.currentMember.id,
                          m_member_user_shell:self.currentMember.memberShell,
                          @"gender":gender,
                          m_editType:@"gender"};
    
    [[SPNetworkManager sharedClient] changUserInfoWithParams:dic completion:^(BOOL succeeded, id responseObject ,NSError *error){
        if (succeeded) {
            self.currentMember.gender = gender;
            MR_SaveToPersitent_For_CurrentThread;
            //      NAPostNotification(kSPUpdateMemberInfo, nil);
             [SVProgressHUD showInfoWithStatus:@"修改成功"];
        }
    }];
    
}

- (void)updateNameToServer:(NSString *)name{
    
    NSDictionary *dic = @{mC_id:self.currentMember.id,
                          m_member_user_shell:self.currentMember.memberShell,
                          @"newname":name,
                          m_editType:@"newname"};
    
    [[SPNetworkManager sharedClient] changUserInfoWithParams:dic completion:^(BOOL succeeded, id responseObject ,NSError *error){
        if (succeeded) {
            self.currentMember.nickName = name;
            MR_SaveToPersitent_For_CurrentThread;
            self.nikcLable.text = name;
             [SVProgressHUD showInfoWithStatus:@"修改成功"];
            //      NAPostNotification(kSPUpdateMemberInfo, nil);
        }
    }];
    
}

- (void)updateEmailToServer:(NSString *)email{
    
    NSDictionary *dic = @{mC_id:self.currentMember.id,
                          m_member_user_shell:self.currentMember.memberShell,
                          @"email":email,
                          m_editType:@"email"};
    
    [[SPNetworkManager sharedClient] changUserInfoWithParams:dic completion:^(BOOL succeeded, id responseObject ,NSError *error){
        if (succeeded) {
            self.currentMember.email = email;
            self.emailLable.text = email;
            MR_SaveToPersitent_For_CurrentThread;
             [SVProgressHUD showInfoWithStatus:@"修改成功"];
            //      NAPostNotification(kSPUpdateMemberInfo, nil);
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.avatarimageView.image = image;
    UIImage *zipedImage = [image zipImageWithSize:(CGSize){500,500}];
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    // 参数分别 id  文件名    图片
    
   [[SPNetworkManager sharedClient] uploadDataWith:self.currentMember.id memberShell:self.currentMember.memberShell name:[NSString stringWithFormat:@"file%ld.jpg",(long)index] image:zipedImage avatar:YES completion:^(BOOL succeeded, id responseObject, NSError *error) {
           if (succeeded) {
               if ([responseObject checkObjectForKey:m_avatar]){
                   self.currentMember.avatar = responseObject[m_avatar];
                   MR_SaveToPersitent_For_CurrentThread;
                   NAPostNotification(kSPLoginStatusChanged, nil);
                   [SVProgressHUD showInfoWithStatus:@"修改成功"];
               }
               self.avatarimageView.image = zipedImage;
               NALog(@"-------> Upload avatar Succeed!!==%@",self.currentMember.avatar);
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
