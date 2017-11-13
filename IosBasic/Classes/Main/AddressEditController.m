//
//  AddressEditController.m
//  IosBasic
//
//  Created by li jun on 17/4/22.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "AddressEditController.h"

#import "SPNetworkManager.h"

#import "SVProgressHUD.h"
#import "FGAreaPicker.h"
#import "ChinaPlckerView.h"


#import <Reachability.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "NACTPageViewController.h"
#import <CTAssetsPickerController.h>
#import "OTAvatarImagePicker.h"
#import "UIButton+WebCache.h"
#import "UIButton+NATools.h"
#import "UIButton+AFNetworking.h"

#define kLableHeight 44.f
#define kNumberInRow 2

#define k_name @"收货人*"
#define k_phone @"手机号码*"
#define k_country @"所在国家*"
// 国内的地址
#define k_adress1 @"所在区域*"
#define k_adress @"详细地址*"  // 共用
#define k_num @"身份证号*"
#define k_ID @"上传身份证*"
// 澳洲地址
#define k_state @"洲*"     //
#define k_town @"城/镇*"
#define k_code @"邮政编码*"


#define k_set @"设为默认*"
#define k_b @"button"

@interface AddressEditController ()<UITextFieldDelegate,UITextViewDelegate,FGAreaPickerDelegate,ChinaPlckerViewDelegate,CTAssetsPickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,OTAvatarImagePickerDelegate>


@property(nonatomic,strong)UITextField *nameTextField;  // 收货人
@property(nonatomic,strong)UITextField *phoneTextField;  // 电话

@property(nonatomic,strong)UITextField *codeTextField;  // 电话
@property(nonatomic,strong)UITextField *townTextField;  // 电话

@property(nonatomic,strong)UITextField *IDTextField;
@property(nonatomic,strong)UITextView *addressTextView;
@property(nonatomic,strong)UIButton *setDefaultButton;

@property(nonatomic,strong)UIButton *areabutton;
@property(nonatomic,strong)UIButton *statebutton;

@property (nonatomic, strong) FGAreaPicker *areaPicker;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *county;

@property (nonatomic, strong) NSMutableString *addressString;

//
@property (strong, nonatomic) ALAssetsLibrary* library;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) UIView *imagesContainor;


@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,strong)UIButton *ausbutton;
@property(nonatomic,strong)UIImageView *ausImageV;
@property(nonatomic,strong)UIButton *chibutton;
@property(nonatomic,strong)UIImageView *chiImageV;

@property(nonatomic,strong)UIButton *IDbutton;
@property(nonatomic,strong)NSString *idImageStr;
@property(nonatomic,strong)UIButton *IDBackbutton;
@property(nonatomic,strong)NSString *idbackImageStr;

@property(nonatomic)BOOL isFirst;
@end

@implementation AddressEditController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.isEdit = YES;
//    self.titleArray =  @[@"收货人*",@"手机号码*",@"身份证号*",@"上传身份证*",@"所在地址*",@"详细地址*",@"设为默认"];
//    self.titleArray =  @[@"收货人*",@"手机号码*",k_country,k_adress,@"身份证号*",k_set,k_ID,k_b];
    
    self.isFirst = YES;
    
    if (_isEdit) {
        if ([self.editAddress.isChina isEqualToString:@"1"]) {
            // 国内
            self.province = self.editAddress.province;
            self.city = self.editAddress.city;
            self.county = self.editAddress.county;
            self.titleArray =  @[k_name,k_phone,k_country,k_adress1,k_adress,k_num,k_ID,k_b];
        }else{
            // 澳洲
            self.titleArray =  @[k_name,k_phone,k_country,k_state,k_town,k_code,k_adress,k_b];
        }
    }else{
        // 澳洲
       
        
        if (_isChina) {
             self.titleArray =  @[k_name,k_phone,k_country,k_adress1,k_adress,k_num,k_ID,k_b];
        }else{
             self.titleArray =  @[k_name,k_phone,k_country,k_state,k_town,k_code,k_adress,k_b];
        }
    }
    
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, NAScreenHeight-kNavigationHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    FGAreaPicker *areaPicker = [[FGAreaPicker alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, 216)];
    areaPicker.p_Deleate = self;
    self.areaPicker = areaPicker;
    self.areaPicker.isShown = NO;
    [self.view addSubview:areaPicker];
    
    [self addBackButton];
    [self addBackgroundTapAction];
    
}
- (void)backgroundTapAction:(id)sensor
{
    // 子类实现
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.IDTextField resignFirstResponder];
    
    [self.townTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.addressTextView resignFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  *titleStr = self.titleArray[indexPath.row];
    if ([titleStr isEqualToString:k_adress]) {
        return 2*kLableHeight;
    }else if([titleStr isEqualToString:k_ID]){
        return 4*kLableHeight;
    }else if([titleStr isEqualToString:k_b]){
        return 3*kLableHeight;
    }
    return kLableHeight;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NACommenCell *cell;
    float padding = 10.f;
    NSString *title = self.titleArray[indexPath.row];
    
    if ([title isEqualToString:k_name]||[title isEqualToString:k_phone]||[title isEqualToString:k_num]||[title isEqualToString:k_code]||[title isEqualToString:k_town]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:title];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 0, 100, kLableHeight-6)];
            [lable setLabelWith:title color:[UIColor black4] font:[UIFont defaultTextFontWithSize:15] aliment:NSTextAlignmentRight];
            [cell.contentView addSubview:lable];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lable.right+padding, lable.bottom+3, NAScreenWidth-lable.right-10-20, 1)];
            lineView.backgroundColor = [UIColor spBackgroundColor];
            [cell.contentView addSubview:lineView];
            
            UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(lable.right+padding, 0, self.view.width-lable.width-3*padding, kLableHeight-6)];
            textfield.tag = indexPath.row;
            [textfield setBorderStyle:UITextBorderStyleNone];
            textfield.autocorrectionType = UITextAutocorrectionTypeNo;
            textfield.font = [UIFont defaultTextFontWithSize:14];
            textfield.textColor = [UIColor spDefaultTextColor];
            textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
            textfield.delegate = self;
            if ([title isEqualToString:k_name]) {
                self.nameTextField = textfield;
            }else if ([title isEqualToString:k_phone]){
                 textfield.keyboardType = UIKeyboardTypeNumberPad;
                 self.phoneTextField = textfield;
            }else if ([title isEqualToString:k_town]){
                self.townTextField = textfield;
            }else if ([title isEqualToString:k_code]){
                textfield.keyboardType = UIKeyboardTypeNumberPad;
                self.codeTextField = textfield;
            }else{
                self.IDTextField = textfield;
            }
            [cell.contentView addSubview:textfield];
        }
        if (self.editAddress) {
            self.nameTextField.text  = self.editAddress.name;
            self.phoneTextField.text  =self.editAddress.phone_number;
            self.IDTextField.text  =self.editAddress.IDNumber;
            self.townTextField.text  =self.editAddress.suburb;
            self.codeTextField.text  =self.editAddress.postcode;
        }
    }
    
    if ([title isEqualToString:k_country]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_country];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_country];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // 标题
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 0, 100, kLableHeight-6)];
            [lable setLabelWith:title color:[UIColor black4] font:[UIFont defaultTextFontWithSize:15] aliment:NSTextAlignmentRight];
            [cell.contentView addSubview:lable];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lable.right+padding, lable.bottom+3, NAScreenWidth-lable.right-10-20, 1)];
            lineView.backgroundColor = [UIColor spBackgroundColor];
            [cell.contentView addSubview:lineView];
            
            // 澳洲的
            UIImageView *ausImg = [[UIImageView alloc]initWithFrame:CGRectMake(lable.right+padding, lable.top+10, 25, 25)];
            ausImg.image = [UIImage imageNamed:@"address-D"];
            self.ausImageV = ausImg;
            [cell.contentView addSubview:ausImg];
            
            UILabel *austLable = [[UILabel alloc]initWithFrame:CGRectMake(ausImg.right, lable.top+5, 60, 35)];
            [austLable setLabelWith:@"澳大利亚" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:14.f] aliment:NSTextAlignmentCenter];
            [cell.contentView addSubview:austLable];
            
            UIButton *Austbutton  = [[UIButton alloc]initWithFrame:CGRectMake(ausImg.left+padding, lable.top, ausImg.width+austLable.width, lable.height)];
            [Austbutton addTarget:self action:@selector(countryButtonClickd:) forControlEvents:UIControlEventTouchUpInside];
            self.ausbutton = Austbutton;
            Austbutton.tag = 10;
            [cell.contentView addSubview:Austbutton];
            
            // 国内的
            UIImageView *ausImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(Austbutton.right+padding, lable.top+10, 25, 25)];
            ausImg2.image = [UIImage imageNamed:@"address-D"];
            self.chiImageV = ausImg2;
            [cell.contentView addSubview:ausImg2];
            
            UILabel *austLable2 = [[UILabel alloc]initWithFrame:CGRectMake(ausImg2.right, lable.top+5, 40, 35)];
            [austLable2 setLabelWith:@"中 国" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:14.f] aliment:NSTextAlignmentCenter];
            [cell.contentView addSubview:austLable2];
            
            UIButton *Austbutton2  = [[UIButton alloc]initWithFrame:CGRectMake(ausImg2.left+padding, lable.top, ausImg2.width+austLable2.width, lable.height)];
            Austbutton2.tag = 20;
            self.chibutton = Austbutton2;
            [Austbutton2 addTarget:self action:@selector(countryButtonClickd:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:Austbutton2];
    
            
            
        }
        if (self.editAddress&&self.isFirst) {
            if ([self.editAddress.isChina isEqualToString:@"1"]) {
                // 国内
                self.ausbutton.selected = NO;
                self.ausImageV.image = [UIImage imageNamed:@"address-D"];
                self.chibutton.selected = YES;
                self.chiImageV.image = [UIImage imageNamed:@"address-D1"];
            }else{
                self.ausbutton.selected = YES;
                self.ausImageV.image = [UIImage imageNamed:@"address-D1"];
                self.chibutton.selected = NO;
                self.chiImageV.image = [UIImage imageNamed:@"address-D"];
            }
        }else{
            // 创建时，
//            self.chibutton.selected = _isChina;
//            self.ausbutton.selected = !_isChina;
            
            if (_isChina) {
                // 国内
                self.ausbutton.selected = NO;
                self.ausImageV.image = [UIImage imageNamed:@"address-D"];
                self.chibutton.selected = YES;
                self.chiImageV.image = [UIImage imageNamed:@"address-D1"];
            }else{
                self.ausbutton.selected = YES;
                self.ausImageV.image = [UIImage imageNamed:@"address-D1"];
                self.chibutton.selected = NO;
                self.chiImageV.image = [UIImage imageNamed:@"address-D"];

            }
        }
    }
    
    // 详细地址
    if ([title isEqualToString:k_adress]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_adress];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_adress];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 0, 100, kLableHeight-6)];
            [lable setLabelWith:title color:[UIColor black4] font:[UIFont defaultTextFontWithSize:15] aliment:NSTextAlignmentRight];
            [cell.contentView addSubview:lable];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lable.right+padding, lable.bottom+3, NAScreenWidth-lable.right-10-20, 1)];
            lineView.backgroundColor = [UIColor spBackgroundColor];
            [cell.contentView addSubview:lineView];
            
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(lable.right+padding,lable.top, self.view.width-3*padding-lable.width, 2*kLableHeight-6)];
            textView.textColor = [UIColor spDefaultTextColor];
            textView.font = [UIFont defaultTextFontWithSize:14];
            textView.autocorrectionType = UITextAutocorrectionTypeNo;
            textView.delegate = self;
            self.addressTextView = textView;
            [cell.contentView addSubview:textView];
            lineView.bottom = textView.bottom+3;
        }
        if (_editAddress) {
            self.addressTextView.text = _editAddress.addressDetail;
        }
    }
    
    // 区域选择---国内
    if ([title isEqualToString:k_adress1]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_adress1];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_adress1];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 0, 100, kLableHeight-6)];
            [lable setLabelWith:title color:[UIColor black4] font:[UIFont defaultTextFontWithSize:15] aliment:NSTextAlignmentRight];
            [cell.contentView addSubview:lable];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lable.right+padding, lable.bottom+3, NAScreenWidth-lable.right-10-20, 1)];
            lineView.backgroundColor = [UIColor spBackgroundColor];
            [cell.contentView addSubview:lineView];
            
            // 地区选择
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(lable.right+padding,lable.top, self.view.width-lable.width-3*padding, kLableHeight-6)];
            [button setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            UIImageView  *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowImage"]];
            imageView.frame = CGRectMake(button.width-kLableHeight/4-10, kLableHeight/4, kLableHeight/4, kLableHeight/2);
            
            [button addSubview:imageView];
            button.titleLabel.font = [UIFont defaultTextFontWithSize:14.f];
            [button addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            self.areabutton = button;
            [cell.contentView addSubview:button];
        }
        if (_editAddress) {
            [self.areabutton setTitle:_editAddress.areaInfo forState:UIControlStateNormal];
            self.province =_editAddress.province;
            self.city =_editAddress.city;
            self.county =_editAddress.county;
            self.addressString = [NSMutableString stringWithFormat:@"%@",_editAddress.areaInfo];
        }
    }
    
    // 洲选择
    if ([title isEqualToString:k_state]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_state];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_state];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 0, 100, kLableHeight-6)];
            [lable setLabelWith:title color:[UIColor black4] font:[UIFont defaultTextFontWithSize:15] aliment:NSTextAlignmentRight];
            [cell.contentView addSubview:lable];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lable.right+padding, lable.bottom+3, NAScreenWidth-lable.right-10-20, 1)];
            lineView.backgroundColor = [UIColor spBackgroundColor];
            [cell.contentView addSubview:lineView];
            
            // 地区选择
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(lable.right+padding,lable.top, self.view.width-lable.width-3*padding, kLableHeight-6)];
            [button setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            UIImageView  *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowImage"]];
            imageView.frame = CGRectMake(button.width-kLableHeight/4-10, kLableHeight/4, kLableHeight/4, kLableHeight/2);
            [button addSubview:imageView];
            button.titleLabel.font = [UIFont defaultTextFontWithSize:14.f];
            [button addTarget:self action:@selector(stateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            self.statebutton = button;
            [cell.contentView addSubview:button];
        }
        if (_editAddress) {
            [self.statebutton setTitle:_editAddress.state forState:UIControlStateNormal];
        }
    }
    
    if ([title isEqualToString:k_set]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_set];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_set];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 0, 100, kLableHeight-6)];
            [lable setLabelWith:title color:[UIColor black4] font:[UIFont defaultTextFontWithSize:15] aliment:NSTextAlignmentRight];
            [cell.contentView addSubview:lable];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lable.right+padding, lable.bottom+3, NAScreenWidth-lable.right-10-20, 1)];
            lineView.backgroundColor = [UIColor spBackgroundColor];
            [cell.contentView addSubview:lineView];
            UIButton *button  = [[UIButton alloc]initWithFrame:CGRectMake(lable.right+padding, lable.top+10, 25, 25)];
            [button setImage:[UIImage imageNamed:@"address-D"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"address-D1"] forState:UIControlStateSelected];
            button.selected = YES;
           _setDefaultButton = button;
            [button addTarget:self action:@selector(setDefaultButtonClickd:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_setDefaultButton];
        }
        if (_editAddress) {
            _setDefaultButton.selected = [_editAddress.isDefault integerValue]==1?YES:NO;
        }
    }
    
    
    if ([title isEqualToString:k_ID]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_ID];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_ID];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 0, 100, kLableHeight-6)];
            [lable setLabelWith:title color:[UIColor black4] font:[UIFont defaultTextFontWithSize:15] aliment:NSTextAlignmentRight];
            [cell.contentView addSubview:lable];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lable.right+padding, lable.bottom+3, NAScreenWidth-lable.right-10-20, 1)];
            lineView.backgroundColor = [UIColor spBackgroundColor];
            [cell.contentView addSubview:lineView];
            
            lineView.bottom = lable.bottom +3*kLableHeight+3;
    
            float buttonWidht =( NAScreenWidth - 60)/2;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20, lable.bottom, buttonWidht, kLableHeight*3-6);
            [button setBackgroundImage:[UIImage imageNamed:@"communityAdd"] forState:UIControlStateNormal];
            self.IDbutton = button;
            [button addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
    
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame = CGRectMake(button.right+20, lable.bottom, buttonWidht, kLableHeight*3-6);
            [button2 setBackgroundImage:[UIImage imageNamed:@"communityAdd"] forState:UIControlStateNormal];
            self.IDBackbutton = button2;
            button2.tag =100;
            [button2 addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button2];
            
        }
        // 添加身份证的信息
        if (self.editAddress&&self.isFirst) {
            [self.IDbutton sd_setImageWithURL:[NSURL URLWithString:self.editAddress.idImgA] forState:UIControlStateNormal];
            [self.IDBackbutton sd_setImageWithURL:[NSURL URLWithString:self.editAddress.idImgB] forState:UIControlStateNormal];
            self.idImageStr = self.editAddress.idImgA;
            self.idbackImageStr = self.editAddress.idImgB;
        }
    }
    
    
    if ([title isEqualToString:k_b]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_b];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_b];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NACommonButton *button = [NACommonButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 20, NAScreenWidth, 40);
            [button setTitle:@"保存" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor red2]];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [button addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
           
        }
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark---Uibutton
- (void)countryButtonClickd:(UIButton *)sender{
    self.isFirst = NO;
    self.addressTextView.text = nil;
    if (sender.tag==10) {
        // 澳洲的
        _isChina = NO;

        self.ausbutton.selected = YES;
        self.ausImageV.image = [UIImage imageNamed:@"address-D1"];
        self.chibutton.selected = NO;
        self.chiImageV.image = [UIImage imageNamed:@"address-D"];
        
        self.addressTextView.text = @"";
        self.titleArray =  @[k_name,k_phone,k_country,k_state,k_town,k_code,k_adress,k_b];
        [self.tableView reloadData];
    }else{
        _isChina = YES;
        self.ausbutton.selected = NO;
        self.ausImageV.image = [UIImage imageNamed:@"address-D"];
        self.chibutton.selected = YES;
        self.chiImageV.image = [UIImage imageNamed:@"address-D1"];
        
        self.titleArray =  @[k_name,k_phone,k_country,k_adress1,k_adress,k_num,k_ID,k_b];
        [self.tableView reloadData];
    }
    
}
- (void)setDefaultButtonClickd:(UIButton *)button{
    button.selected = !button.selected;
}

- (void)plusButtonAction:(UIButton *)sender{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *cameralAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"拍照");
        if (sender.tag == 100) {
            [self cameraButtonActionWith:YES];
        }else{
             [self cameraButtonActionWith:NO];
        }
       
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"相册");
        if (sender.tag == 100) {
            [self albumButtonActionWith:YES];
        }else{
            [self albumButtonActionWith:NO];
        }
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:cameralAction];
    [alertC addAction:albumAction];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
- (NSMutableArray *)assets
{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}
#pragma mark ----xiangji
// 一次只能取一张照片
- (void)cameraButtonActionWith:(BOOL)isback
{
    [[OTAvatarImagePicker sharedInstance] setDelegate:nil];
    [[OTAvatarImagePicker sharedInstance] setDelegate:self];
    [[OTAvatarImagePicker sharedInstance] getImageFromCameraInIphone:self isback:isback];
}

- (void)albumButtonActionWith:(BOOL)isback
{
    [[OTAvatarImagePicker sharedInstance] setDelegate:nil];
    [[OTAvatarImagePicker sharedInstance] setDelegate:self];
    [[OTAvatarImagePicker sharedInstance] getImageFromAlbumInIphone:self isback:isback];
}

- (void)getImageFromWidget:(UIImage *)image back:(BOOL)isback{
    if (isback) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[SPNetworkManager sharedClient] uploadDataWithimage:image name:[NSString stringWithFormat:@"file%ld.jpg",(long)index] completion:^(BOOL succeeded, id responseObject, NSError *error) {
            if (succeeded) {
                [SVProgressHUD dismiss];
                NSLog(@"%@",responseObject);
                [self.IDBackbutton setImage:image forState:UIControlStateNormal];
                self.idbackImageStr = responseObject;
            }
        }];
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[SPNetworkManager sharedClient] uploadDataWithimage:image name:[NSString stringWithFormat:@"file%ld.jpg",(long)index] completion:^(BOOL succeeded, id responseObject, NSError *error) {
            if (succeeded) {
                [SVProgressHUD dismiss];
                NSLog(@"%@",responseObject);
                [self.IDbutton setImage:image forState:UIControlStateNormal];
                self.idImageStr = responseObject;
            }
        }];
    }
    // 上传图片的接口
    
}
- (void)chooseButtonAction:(UIButton*)button{
    //    NSLog(@"弹出地区选择器");
//    [ChinaPlckerView customChinaPicker:self superView:self.view];

    FGAreaPicker *pickerView = [[FGAreaPicker alloc] init];
    pickerView.dateType = AreaStyleShowProvinceCityCounty;
    pickerView.isChina = YES;
    pickerView.selectResultBlock = ^(NSString *province, NSString *city, NSString *county){
        [self.statebutton setTitle:[NSString stringWithFormat:@" %@",province] forState:UIControlStateNormal];
         NSMutableString *areaString = [NSMutableString string];
        if (!KIsBlankString(province)) {
            [areaString appendString:[NSString stringWithFormat:@" %@", province]];
            self.province = province;
        }
        
        if (!KIsBlankString(city)) {
            [areaString appendString:[NSString stringWithFormat:@" %@", city]];
            self.city = city;
        }
        
        if (!KIsBlankString(county)) {
            [areaString appendString:[NSString stringWithFormat:@" %@", county]];
            self.county = county;
        }
        self.addressString = areaString;
        [self.areabutton setTitle:areaString forState:UIControlStateNormal];
        
    };
    [pickerView show];
    
}
- (void)stateButtonAction:(UIButton *)button{
    FGAreaPicker *pickerView = [[FGAreaPicker alloc] init];
    pickerView.dateType = AreaStyleShowProvince;
    pickerView.selectResultBlock = ^(NSString *province, NSString *city, NSString *county){
         [self.statebutton setTitle:[NSString stringWithFormat:@" %@",province] forState:UIControlStateNormal];
    };
    [pickerView show];
}

- (void)saveButtonAction:(id)sender{
    

//    if (!KIsIdentityCard(self.IDTextField.text)) {
//        [iToast showToastWithText:@"请输入正确的身份证号" position:iToastGravityCenter];
//        return;
//    }
//    return;
    
    
    
    if ([self.nameTextField.text isEmptyString]) {
        [iToast showToastWithText:@"请输入联系人" position:iToastGravityCenter];
        return;
    }

    if ([self.addressTextView.text isEmptyString]) {
        [iToast showToastWithText:@"请输入联系地址" position:iToastGravityCenter];
        return;
    }
    
    if (self.chibutton.selected) {
        
        if (KIsBlankString(self.province)) {
            [iToast showToastWithText:@"请设置所在区域" position:iToastGravityCenter];
            return;
        }
        
        if (self.phoneTextField.text.length!=11) {
            [iToast showToastWithText:@"手机号码有误" position:iToastGravityCenter];
            return;
        }
        
        if ([self.IDTextField.text isEmptyString]) {
            [iToast showToastWithText:@"请输入身份证号" position:iToastGravityCenter];
            return;
        }
        
        if (!KIsIdentityCard(self.IDTextField.text)) {
            [iToast showToastWithText:@"请输入正确的身份证号" position:iToastGravityCenter];
            return;
        }
        
        if (KIsBlankString(self.idImageStr)) {
            [iToast showToastWithText:@"请上传身份证照片" position:iToastGravityCenter];
            return;
        }
        
        if (KIsBlankString(self.idbackImageStr)) {
            [iToast showToastWithText:@"请上传身份证照片" position:iToastGravityCenter];
            return;
        }
        
        
        
        
    }else{
        // 澳洲的地址
        if (KIsBlankString(self.statebutton.titleLabel.text)) {
            [iToast showToastWithText:@"请设置所在洲" position:iToastGravityCenter];
            return;
        }
        
        if ([self.townTextField.text isEmptyString]) {
            [iToast showToastWithText:@"请输入城镇" position:iToastGravityCenter];
            return;
        }
        
        if ([self.codeTextField.text isEmptyString]) {
            [iToast showToastWithText:@"请输入邮政编码" position:iToastGravityCenter];
            return;
        }
        
        if (self.phoneTextField.text.length!=10) {
            [iToast showToastWithText:@"手机号码有误" position:iToastGravityCenter];
            return;
        }
        
    }
    
    // 设置默认地址---不需要了
    NSString *setdefault = @"0";
//    if (self.setDefaultButton.selected) {
//        setdefault = @"1";
//    }
//    
    NSDictionary *paramsDict = @{mC_id : self.currentMember.id,
                                 m_member_user_shell:self.currentMember.memberShell,
                                 m_truename:_nameTextField.text,
                                 m_address:_addressTextView.text,
                                 m_mobphone:_phoneTextField.text,
                                 m_isDefault:setdefault
                                 };
    NSMutableDictionary *mutadic = [NSMutableDictionary dictionaryWithDictionary:paramsDict];
    

    if (self.ausbutton.selected) {
        //澳洲的地址：
        [mutadic setObject:@"2" forKey:@"isChina"];
        [mutadic setObject:_statebutton.titleLabel.text forKey:@"state"];
        [mutadic setObject:_townTextField.text forKey:@"suburb"];
        [mutadic setObject:_codeTextField.text forKey:@"postcode"];
        
    }else{

        if (!KIsBlankString(self.idImageStr)) {
            [mutadic setObject:self.idImageStr forKey:@"idImgA"];
        }
        if (!KIsBlankString(self.idbackImageStr)) {
             [mutadic setObject:self.idbackImageStr forKey:@"idImgB"];
        }

        if (![self.IDTextField.text isEmptyString]) {
             [mutadic setObject:self.IDTextField.text forKey:@"IDNumber"];
        }
        
        if (![self.IDTextField.text isEmptyString]) {
            [mutadic setObject:self.IDTextField.text forKey:@"IDNumber"];
        }
        // 地址
        
        if (!KIsBlankString(self.province)) {
            [mutadic setObject:self.province forKey:@"province"];
        }
        if (!KIsBlankString(self.city)) {
            [mutadic setObject:self.city forKey:@"city"];
        }
        if (!KIsBlankString(self.county)) {
            [mutadic setObject:self.county forKey:@"county"];
        }

        [mutadic setObject:@"1" forKey:@"isChina"];
    }
    if (self.isEdit) {
        [mutadic setObject:_editAddress.addressId forKey:m_addressid];
    }
    
    NSLog(@"选择的选项，%@",mutadic);
    if (self.addNewAddressResultBlock) {
        self.addNewAddressResultBlock(_isChina);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient]addNewAdressWithParams:mutadic completion:^(BOOL succeeded, id responseObject, NSError *error) {
       if (succeeded) {
            NSLog(@"%@",responseObject);
            if (self.isEdit) {
                [SVProgressHUD showWithStatus:@"修改成功"];
            }else{
                [SVProgressHUD showWithStatus:@"新增成功"];
            }
            [self.navigationController popViewControllerAnimated:YES];
            NAPostNotification(kSPAddressUpdate, nil);
        }
    }];
    
    
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Area Picker Delegate
////////////////////////////////////////////////////////////////////////////////////

- (void)pickerViewDidGetProvince:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    //    NALog(@"-----> Picker Seleted %@ %@ %@",province, city, area);
    //    点击过后才赋值的
    //    self.province = province;
    //    self.city = city;
    //    self.district = area;
    //
    //    NSMutableString *areaString = [NSMutableString string];
    //
    //    if (![province isEqualToString:@""]) [areaString appendString:[NSString stringWithFormat:@" %@", province]];
    //    if (![city isEqualToString:@""]) [areaString appendString:[NSString stringWithFormat:@" %@", city]];
    //    if (![area isEqualToString:@""]) [areaString appendString:[NSString stringWithFormat:@" %@", area]];
    //
    //    NSString *string = [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.district];
    //    [self.areabutton setTitle:string forState:UIControlStateNormal];
}
#pragma mark - ChinaPlckerViewDelegate
- (void)chinaPlckerViewDelegateChinaModel:(ChinaArea *)chinaModel{
    
    NSLog(@"id==========%@,%@,%@",chinaModel.provinceModel.idNumber,chinaModel.cityModel.idNumber,chinaModel.areaModel.idNumber);
    NSLog(@"name==========%@,%@,%@",chinaModel.provinceModel.name,chinaModel.cityModel.name,chinaModel.areaModel.name);
    NSMutableString *areaString = [NSMutableString string];
    
//    if (![chinaModel.provinceModel.name isEqualToString:@""]) [areaString appendString:[NSString stringWithFormat:@" %@", chinaModel.provinceModel.name]];
//    if (![chinaModel.cityModel.name isEqualToString:@""]) [areaString appendString:[NSString stringWithFormat:@" %@", chinaModel.cityModel.name]];
//    if (![chinaModel.areaModel.name isEqualToString:@""]) [areaString appendString:[NSString stringWithFormat:@" %@", chinaModel.areaModel.name]];
    
    if (!KIsBlankString(chinaModel.provinceModel.name)) {
        [areaString appendString:[NSString stringWithFormat:@" %@", chinaModel.provinceModel.name]];
        self.province = chinaModel.provinceModel.name;
    }
    
    if (!KIsBlankString(chinaModel.cityModel.name)) {
        [areaString appendString:[NSString stringWithFormat:@" %@", chinaModel.cityModel.name]];
        self.city = chinaModel.cityModel.name;
    }
    
    if (!KIsBlankString(chinaModel.areaModel.name)) {
        [areaString appendString:[NSString stringWithFormat:@" %@", chinaModel.areaModel.name]];
        self.county = chinaModel.areaModel.name;
    }else{
//         self.county = self.city;
    }
  
    

    self.addressString = areaString;
    [self.areabutton setTitle:areaString forState:UIControlStateNormal];

//  self.addressTextView.text = areaString;
    
}
#pragma mark ---UItextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark ---UItextView delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    // 没啥意义这里。。。
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect frame=[textView convertRect: textView.bounds toView:window];
    
    //    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    int offset = frame.origin.y + 20 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.tableView.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, NAScreenHeight-kNavigationHeight);
    
    [UIView commitAnimations];
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.tableView.frame =CGRectMake(0, 0, self.view.frame.size.width, NAScreenHeight-kNavigationHeight);
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
