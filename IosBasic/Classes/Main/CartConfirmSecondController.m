//
//  CartConfirmSecondController.m
//  IosBasic
//
//  Created by li jun on 17/4/14.
//  Copyright © 2017年 CRZ. All rights reserved.
//
#import "OrdersCellView.h"

#import "CartConfirmSecondController.h"
#import "CartComfirmThirdController.h"

#import "CartConfirmSecondWebViewPayController.h"


#import "OTAvatarImagePicker.h"
#import "SPSpriteCardController.h"

#define k_title @"title"
#define k_CartsHead @"cartshead"  // 商品信息  上面增加标题，下面增加页尾
#define k_Carts @"carts"  // 商品信息  上面增加标题，下面增加页尾
#define k_ID @"请上传身份证*"
#define k_pay  @"Pay"  // 金额
#define k_payType  @"payType"  // 支付方式
#define k_button @"button"  // 两个button

#define padding 10
#define text_font 15.f
#define kLableHeight 44.f

@interface CartConfirmSecondController ()<UITableViewDelegate,UITableViewDataSource,OTAvatarImagePickerDelegate,UITextFieldDelegate>
    
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSMutableArray *buttonArray;

@property(nonatomic,strong)UIButton *IDbutton;
@property(nonatomic,strong)NSString *idImageStr;
@property(nonatomic,strong)UIButton *IDBackbutton;
@property(nonatomic,strong)NSString *idbackImageStr;
@property(nonatomic,strong)UITextField *IDTextField;





@property(nonatomic)BOOL isUpdateID;

@property(nonatomic)NSInteger payType; // 可能同时生成多个订单，判断是否跳转支付成功。
@property(nonatomic,strong)NSIndexPath *payIndexPath;  // 选中的
@property(nonatomic,strong)NSString *orderId; // 选中的

@end

@implementation CartConfirmSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitleArray];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - kNavigationHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
   
    // Do any additional setup after loading the view.
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)initTitleArray{
    NSMutableArray *mutaArray = [NSMutableArray arrayWithObjects:k_title, nil];
    for (int i=0; i<self.ordersArray.count; i++) {
        [mutaArray addObject:k_Carts];
        _payType ++;
    }
//    if (_showID) {
//          [mutaArray addObject:k_ID];
//    }
    self.titleArray = mutaArray ;
    self.buttonArray = [NSMutableArray array];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self addBackButton];
    [self addBackgroundTapAction];
    self.title = @"订单详情";
}
// 视图点击
- (void)backgroundTapAction:(id)sensor
{
    // 子类实现
    [self.IDTextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
// 后退按钮
- (void)backBarButtonPressed:(id)backBarButtonPressed
{
//    if (_showID) {
//        if (!_isUpdateID) {
//            [SVProgressHUD showInfoWithStatus:@"请上传身份证信息"];
//            return;
//        }
//    }
    if (_isOrderpay) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark------tableVIew delegat
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.titleArray[indexPath.row];
    if ([title isEqualToString:k_title]) {
       return 90;
    }else if ([title isEqualToString:k_ID]){
        return 7.5*kLableHeight+20;
    }else {
        // title
        ECOrdersObject *cellModel = _ordersArray[indexPath.row-1];
        return [OrdersCellView ViewHeightWithProduct:cellModel];
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NACommenCell *cell;
    NSString *title = self.titleArray[indexPath.row];
    
    if ([title isEqualToString:k_title]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_title];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_title];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(NAScreenWidth/6, 40, NAScreenWidth*2/3, 1)];
            lineView.backgroundColor = [UIColor gray2];
            [cell.contentView addSubview:lineView];
            
            for (int i=0; i<3; i++) {
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(i*NAScreenWidth/3, lineView.bottom+20, NAScreenWidth/3, 20)];
                [lable setLabelWith:@"" color:[UIColor gray1] font:[UIFont defaultTextFontWithSize:text_font-1] aliment:NSTextAlignmentCenter];
                [cell.contentView addSubview:lable];
                
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(lable.center.x-10, lable.top-30, 20, 20)];
                view.backgroundColor = [UIColor gray1];
                view.layer.masksToBounds = YES;
                view.layer.cornerRadius = 10;
                [cell.contentView addSubview:view];
                if (i==0) {
                    lable.text = @"生成订单";
                }
                if (i==1) {
                    view.backgroundColor = [UIColor red2];
                    lable.textColor = [UIColor spThemeColor];
                    lable.text = @"订单详情";
                }
                if (i==2) {
                    lable.text = @"下单成功";
                }
            }
        }
    }
    

    
    if ([title isEqualToString:k_Carts]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_Carts];
        
        if (!cell || !cell.customView1) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_Carts];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            OrdersCellView *orderView = [[OrdersCellView alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, 44.f)];
            cell.customView1 = orderView;
            cell.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:orderView];
            
        }
        ECOrdersObject *cellModel = _ordersArray[indexPath.row-1];
        OrdersCellView *orderView = (OrdersCellView *)cell.customView1;
        [orderView updateViewWithisShopCartOrder:cellModel];
        
        orderView.payButtonBlock = ^(ECOrdersObject *model){
            NSLog(@"支付");
            self.payIndexPath = indexPath;
            self.orderId = model.idNumber;
//            [SVProgressHUD showInfoWithStatus:@"功能开发中"];
            
//            [self payWithPayPalWithOrder:model];
            
            // 支付完成后跳转。
            
            [self chooseModeOfPayWith:model];
            
        };
        
    }

    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)chooseModeOfPayWith:(ECOrdersObject *)orderModel{
    
    UIAlertController *alertController2 = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:@"" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"测试");
    }];
    
    UIAlertAction *paypalAction = [UIAlertAction actionWithTitle:@"Paypal 支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Paypal");
//        [self payWithPayPalWithOrder:orderModel];
    }];
    
    UIAlertAction *ewayAction = [UIAlertAction actionWithTitle:@"eWay 支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"eway支付");
        SPSpriteCardController *cardVC = [[SPSpriteCardController alloc]init];
        cardVC.title = @"选择支付的卡";
        [self.navigationController pushViewController:cardVC animated:YES];
    }];
    
    [alertController2 addAction:ewayAction];
    [alertController2 addAction:paypalAction];
    [alertController2 addAction:cancelAction];
    
    [self presentViewController:alertController2 animated:YES completion:nil];
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
