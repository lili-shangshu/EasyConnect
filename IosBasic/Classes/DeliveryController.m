//
//  DeliveryController.m
//  IosBasic
//
//  Created by Star on 2017/6/21.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "DeliveryController.h"

#define kLableHeight 44.f
#define kNumberInRow 2

#define k_name @"收货人*"
#define k_phone @"手机号码*"

#define k_adress @"详细地址*"
#define k_set @"设为默认"


@interface DeliveryController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UITextField *phoneTextField;

@property(nonatomic,strong)UITextView *addressTextView;

@property(nonatomic,strong)NSArray *titleArray;

@end

@implementation DeliveryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray =  @[k_name,k_phone,k_adress];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, NAScreenHeight-kNavigationHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{

    [self addBackButton];
    self.title = @"收货地址";
    [self addBackgroundTapAction];
    
}
- (void)backBarButtonPressed:(id)backBarButtonPressed
{
    self.selectResultBlock(nil);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backgroundTapAction:(id)sensor
{
    // 子类实现
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];

    [self.addressTextView resignFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 2) {
        return kLableHeight*2;
    }
    
    return kLableHeight;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NACommenCell *cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    float padding = 10.f;
    
    NSString *titleStr = @"";
    
    if (_titleArray.count>indexPath.row) {
        titleStr = self.titleArray[indexPath.row];
    }
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 0, 100, kLableHeight-6)];
    [lable setLabelWith:titleStr color:[UIColor black4] font:[UIFont defaultTextFontWithSize:15] aliment:NSTextAlignmentRight];
    [cell.contentView addSubview:lable];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lable.right+padding, lable.bottom+3, NAScreenWidth-lable.right-10-20, 1)];
    lineView.backgroundColor = [UIColor spBackgroundColor];
    [cell.contentView addSubview:lineView];
    
    if (indexPath.row<2) {
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(lable.right+padding, 0, self.view.width-lable.width-3*padding, kLableHeight-6)];
        textfield.tag = indexPath.row;
        [textfield setBorderStyle:UITextBorderStyleNone];
        textfield.autocorrectionType = UITextAutocorrectionTypeNo;
        textfield.font = [UIFont defaultTextFontWithSize:14];
        textfield.textColor = [UIColor spDefaultTextColor];
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textfield.delegate = self;
        if (indexPath.row==0) {
            self.nameTextField = textfield;
           
        }else{
            textfield.keyboardType = UIKeyboardTypeNumberPad;
            self.phoneTextField = textfield;
        }
        [cell.contentView addSubview:textfield];
    }
    
    
    if ([titleStr isEqualToString:k_adress]) {
        // 详细地址
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(lable.right+padding,lable.top, self.view.width-3*padding-lable.width, 2*kLableHeight-6)];
        textView.textColor = [UIColor spDefaultTextColor];
        textView.font = [UIFont defaultTextFontWithSize:14];
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
        textView.delegate = self;
        self.addressTextView = textView;
        [cell.contentView addSubview:textView];
        lineView.bottom = textView.bottom+3;
    }
    
    if (indexPath.row == _titleArray.count) {
        NACommonButton *button = [NACommonButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 2, NAScreenWidth, 40);
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor red2]];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        lineView.hidden = YES;
        lable.hidden = YES;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)saveButtonAction:(id)sender{
    if ([self.nameTextField.text isEmptyString]) {
        [iToast showToastWithText:@"请输入联系人" position:iToastGravityCenter];
        return;
    }
    //    if ([self.phoneTextField.text isMobileNumber]) {
    //        [iToast showToastWithText:@"Enter contact telphone" position:iToastGravityCenter];
    //        return;
    //    }
    if ([self.addressTextView.text isEmptyString]) {
        [iToast showToastWithText:@"请输入联系地址" position:iToastGravityCenter];
        return;
    }
    
    if (self.selectResultBlock) {
        ECAddress *addredd = [[ECAddress alloc]init];
        addredd.name = _nameTextField.text;
        addredd.phone_number = _phoneTextField.text;
        addredd.areaInfo = _addressTextView.text;
        addredd.addressDetail = @"";
        self.selectResultBlock(addredd);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    //    [self.addressString appendString:textView.text];
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
