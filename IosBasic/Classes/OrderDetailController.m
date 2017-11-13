//
//  OrderDetailController.m
//  IosBasic
//
//  Created by li jun on 16/12/15.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "OrderDetailController.h"
#import "NAAccesorryView.h"
#import "ShopCartCellView.h"
#import "PickerChoiceView.h"
#import "GoodsDetailController.h"
#import "CartConfirmSecondController.h"

#import "OTAvatarImagePicker.h"

#define k_state @"状态"
#define k_address @"地址"
#define k_goods @"商品"
#define k_fee @"费用"
#define k_point @"返积分20点"
#define k_order @"编号和创建时间"

#define k_ID @"ID"

#define text_font 15
#define cell_height  50.f
#define cell_height2  40.f
#define cart_height 130.f
#define padding 10
// y
#define vertical_padding 10.f
// x
#define herizon_padding 20.f
#define kLableHeight 44.f

@interface OrderDetailController ()<UITableViewDataSource,UITableViewDelegate,TFPickerDelegate,OTAvatarImagePickerDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UIButton *IDbutton;
@property(nonatomic,strong)NSString *idImageStr;
@property(nonatomic,strong)UIButton *IDBackbutton;
@property(nonatomic,strong)NSString *idbackImageStr;
@property(nonatomic,strong)UITextField *IDTextField;

@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic)float productFee;
@end

@implementation OrderDetailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    [self addBackButton];
    self.title = @"订单详情";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
//    [self initTitleArray];
//    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - kNavigationHeight)];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    
//    self.tableView.backgroundColor = [UIColor spBackgroundColor];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
//    
//    
//    if ([_detailObj.typeNum intValue] == 10) {
//        self.tableView.height -=48;
//        [self setBottomButton];
//    }
}
- (void)initData{
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//    __weak typeof(self) weakSelf = self;
//    NSDictionary *dic = @{m_id:self.currentMember.id,
//                          m_member_user_shell:self.currentMember.memberShell,
//                          m_orderid:self.orderId};
//    [[SPNetworkManager sharedClient]getOrdersDetaileWithParams:dic completion:^(BOOL succeeded, id responseObject, NSError *error) {
//        [SVProgressHUD dismiss];
//        if (succeeded) {
//            NSLog(@"%@",responseObject);
//            
//            weakSelf.detailObj = responseObject;
//            [self initTitleArray];
//            
//            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, NAScreenHeight  - kNavigationHeight)];
////            NSLog(@"%.1f====%.1f====%.1f",NAScreenHeight,self.tableView.top,self.tableView.height);
//            
//            self.tableView.delegate = self;
//            self.tableView.dataSource = self;
//            
//            self.tableView.backgroundColor = [UIColor spBackgroundColor];
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//            [self.view addSubview:self.tableView];
//            
//            // 订单内页进行操作
////            if ([_detailObj.typeNum intValue] == 10) {
////                self.tableView.height -=48;
////                 NSLog(@"===%.1f",self.tableView.height);
////                [self setBottomButton];
////            }
//        }
//    }];
    
    
    
    [self initTitleArray];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, NAScreenHeight  - kNavigationHeight)];
    //            NSLog(@"%.1f====%.1f====%.1f",NAScreenHeight,self.tableView.top,self.tableView.height);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

}



- (void)initTitleArray{
    NSMutableArray *mutaArray = [NSMutableArray arrayWithObjects:k_state, nil];
    for (int i=0; i<_selectObj.goodsArray.count; i++) {
        [mutaArray addObject:k_goods];
    }
    [mutaArray addObject:k_fee];
    
//    if ([_selectObj.needID intValue]==1) {
//        [mutaArray addObject:k_ID];
//    }
    
    _titleArray = mutaArray;
}
-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
// 有且只要代付款时，出现这两个
- (void)setBottomButton{
    for (int i=0;i<2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*NAScreenWidth/2, self.tableView.bottom, NAScreenWidth/2, 48)];
        button.tag =i;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:text_font+3]];
        if (i == 0) {
            button.backgroundColor = [UIColor grayColor];
            [button setTitle:@"取消订单" forState:UIControlStateNormal];
        }else{
            button.backgroundColor = [UIColor blackColor];
            [button setTitle:@"付款" forState:UIControlStateNormal];
        }
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}
- (void)buttonAction:(UIButton *)button{
    if(button.tag == 0){
//        [SVProgressHUD showInfoWithStatus:@"取消订单"];
        NSLog(@"取消订单");
        PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        picker.selectLb.text = @"";
        picker.orderId = self.orderId;
        picker.customArr = @[@"改选其他商品",@"改选其他配送方式",@"不想买了",@"其他原因"];
        picker.delegate =self;
        [self.view addSubview:picker];
    }else{
//        [SVProgressHUD showInfoWithStatus:@"付款"];
        NSLog(@"付款");
//        CartConfirmSecondController *secondC = [[CartConfirmSecondController alloc]init];
//        secondC.paysn = _detailObj.paySn;
//        secondC.orderObject = model;
//        secondC.cartsArray = model.goodsArray;
//        float totalMoney = 0;
//        
//        for(ECGoodsObject *obj in model.goodsArray){
//            totalMoney += [obj.goodsPrice floatValue];
//        }
//        
//        secondC.totalMoney = totalMoney;
//        secondC.feightFee = model.freight;
//        secondC.discountMoney = [model.total floatValue];
//        
//        
//        if ([model.pointNum intValue]!=0) {
//            secondC.pointNum = model.pointNum;
//            secondC.pointFee = model.pointFee;
//        }
//        if ([model.voucherFee intValue]!=0) {
//            secondC.voucherFee = model.voucherFee;
//            secondC.voucherStr = model.voucherStr;
//        }
//        
//        
//        [self.navigationController pushViewController:secondC animated:YES];

        
        
    }
}
#pragma mark -------- TFPickerDelegate
// 取消订单
- (void)PickerSelectorIndixString:(NSString *)str WithOrderId:(NSString *)idNumber{
    NSDictionary *dic = @{m_id:self.currentMember.id,
                          m_member_user_shell:self.currentMember.memberShell,
                          m_membername:self.currentMember.name,
                          m_statetype:@"order_cancel",
                          m_orderid:idNumber,
                          @"state_info":str};
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] cancleAndConfirmOrderWithParams:dic completion:^(BOOL succeeded, id responseObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (succeeded) {
            NSLog(@"取消订单");
//            [self refreshTopWithCompletion:nil];
            [self initData];
        }
    }];
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
    if ([title isEqualToString:k_state]) {
        return  cell_height2;
    }else if([title isEqualToString:k_address]){
        return 2*cell_height;
    }else if([title isEqualToString:k_goods]){
        return cart_height;
    }else if([title isEqualToString:k_ID]){
        return 6.5*kLableHeight+20;;
    }else if([title isEqualToString:k_fee]){
//        return 2*cell_height2;
         return cell_height2;
    }else if([title isEqualToString:k_point]){
        return cell_height;
    }else{
        return cell_height2*2-10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NACommenCell *cell;
    NSString *title = self.titleArray[indexPath.row];
    
    if ([title isEqualToString:k_state]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_state];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_state];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(herizon_padding, 10, 20, 20)];
            imageView.image = [UIImage imageNamed:@"dingdan-2"];
            [cell.contentView addSubview:imageView];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 0, NAScreenWidth-30-3*herizon_padding, cell_height2)];
            [lable setLabelWith:_selectObj.typeNum color:[UIColor whiteColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentLeft];
            [cell.contentView addSubview:lable];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,cell_height2-1.5 , self.view.width, 1.5f)];
            lineView.backgroundColor = [UIColor gray1];
            cell.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:lineView];
        }
    }

    // 用不到了
    if ([title isEqualToString:k_address]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_address];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_address];
            
            //  10  30 49   100
//            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(herizon_padding, 0, self.view.width-2*herizon_padding, 30.f)];
//            NSString *atring = [NSString stringWithFormat:@"%@   %@",_detailObj.ordersAddress.name,_detailObj.ordersAddress.phone_number];
//            nameLabel.text = atring;
//            nameLabel.textColor =  [UIColor spDefaultTextColor];
//            nameLabel.font = [UIFont systemFontOfSize:15];
//            [cell.contentView addSubview:nameLabel];
//            
//            UILabel *addresslable = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, 70.f)];
//            addresslable.numberOfLines = 0;
//            addresslable.text = _detailObj.ordersAddress.addressDetail;
//            addresslable.textColor =  [UIColor spDefaultTextColor];
//            addresslable.font = [UIFont systemFontOfSize:14];
//            [cell.contentView addSubview:addresslable];
//            
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,addresslable.bottom-1.5 , self.view.width, 1.5f)];
//            lineView.backgroundColor = [UIColor gray1];
//            [cell.contentView addSubview:lineView];
        }
    }
    
    // 商品详情
    if ([title isEqualToString:k_goods]) {
        // 在这呢
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_goods];
        ECGoodsObject *object = _selectObj.goodsArray[indexPath.row-1];
        if (!cell || !cell.customView1) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_goods];
            ShopCartCellView *view = [[ShopCartCellView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, cart_height)];
            [view.addBtn removeFromSuperview];
            [view.minusBtn removeFromSuperview];
            [view.selectButton removeFromSuperview];
            view.imgView.left = 10;
            [view.deleteButton removeFromSuperview];
            cell.customView1 = view;
            [view changePriceLableAndNumLableFrame];
            [cell.contentView addSubview:view];
        }
        ShopCartCellView *view =(ShopCartCellView*) cell.customView1;
        view.titleLabel.text = object.name;
        if (object.chooseStr) {
            view.subtitleLabel.text = object.chooseStr;
        }
        [view.imgView setImageWithFadingAnimationWithURL:[NSURL URLWithString:object.imageUrl]];
        view.priceLabel.text = [@"$:" stringByAppendingString:[NSString stringWithFormat:@"%.2f",[object.goodsPrice floatValue]]] ;
        view.numLabel.text = [NSString stringWithFormat:@"X %d",[object.selectNum2 intValue]];
    }
    
    
    
       // 5倍高  共 250 每个50 上下间距为0 左右调整
    if ([title isEqualToString:k_fee]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_fee];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_fee];
            
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.width, 1.5f)];
            lineView1.backgroundColor = [UIColor gray1];
            [cell.contentView addSubview:lineView1];
            
             float lablewidth = (NAScreenWidth-2*herizon_padding)/2;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(herizon_padding, 0,lablewidth, cell_height2)];
            [label setLabelWith:@"合计" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font+2] aliment:NSTextAlignmentLeft];
            [cell.contentView addSubview:label];
            
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(herizon_padding+lablewidth, label.top,lablewidth, label.height)];
            [label2 setLabelWith:[NSString stringWithFormat:@"$:%.2f",[_selectObj.total floatValue]] color:[UIColor redColor] font:[UIFont defaultTextFontWithSize:text_font+2] aliment:NSTextAlignmentRight];
            [cell.contentView addSubview:label2];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,cell_height2-1.5f , self.view.width, 1.5f)];
            lineView.backgroundColor = [UIColor gray1];
            [cell.contentView addSubview:lineView];
            
//            NSArray *titleArray = @[@"运费",@"积分／优惠卷抵扣",@"合计"];
//            NSNumber *fee = _pointsAndVouvherFee;
//            NSArray *array = @[_detailObj.freight,fee,_detailObj.total];
////            总共为100
//            for (int i=0; i<3; i++) {
//                float lablewidth = (NAScreenWidth-2*herizon_padding)/2;
//                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(herizon_padding, i*cell_height2,lablewidth, cell_height2)];
//                [label setLabelWith:titleArray[i] color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentLeft];
//                
//                if (i==2) {
//                    label.font = [UIFont defaultTextFontWithSize:text_font+3];
//                }
//                [cell.contentView addSubview:label];
//                
//                UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(herizon_padding+lablewidth, label.top,lablewidth, label.height)];
//                NSString *sting = [NSString stringWithFormat:@"￥:%.2f",[array[i] floatValue]];
//                [label2 setLabelWith:sting color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentRight];
//                
//                if (i==2) {
//                    label2.font = [UIFont defaultTextFontWithSize:text_font+3];
//                    label2.textColor = [UIColor redColor];
//                }
//                [cell.contentView addSubview:label2];
//            }
//            
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,3*cell_height2-1.5f , self.view.width, 1.5f)];
//            lineView.backgroundColor = [UIColor gray1];
//            [cell.contentView addSubview:lineView];
        }
    }
    
    //  返回积分  高是50
    if ([title isEqualToString:k_ID]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_ID];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_ID];
            UIView *bgView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, 5*kLableHeight+20)];
            bgView.backgroundColor  = [UIColor whiteColor];
            [cell.contentView addSubview:bgView];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 0, 150, kLableHeight-10)];
            [lable setLabelWith:@"上传身份证后发货" color:[UIColor red2] font:[UIFont boldSystemFontOfSize:16] aliment:NSTextAlignmentLeft];
            [bgView addSubview:lable];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lable.left, lable.bottom+4, bgView.width-20, 1)];
            lineView.backgroundColor = [UIColor red2];
            [bgView addSubview:lineView];
            
            float buttonWidht =( bgView.width - 60)/2;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20, lineView.bottom+padding, buttonWidht, kLableHeight*3-6);
            [button setBackgroundImage:[UIImage imageNamed:@"communityAdd"] forState:UIControlStateNormal];
            self.IDbutton = button;
            [button addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
            
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame = CGRectMake(button.right+20, lineView.bottom+padding, buttonWidht, kLableHeight*3-6);
            [button2 setBackgroundImage:[UIImage imageNamed:@"communityAdd"] forState:UIControlStateNormal];
            self.IDBackbutton = button2;
            button2.tag =100;
            [button2 addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button2];
            
            // 离线button 有10
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(lable.left, button2.bottom+10, bgView.width-20, 1)];
            lineView2.backgroundColor = [UIColor red2];
            [bgView addSubview:lineView2];
            
            UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(padding, lineView2.bottom+10, 100, kLableHeight-10)];
            [lable2 setLabelWith:@"身份证号*:" color:[UIColor red2] font:[UIFont defaultTextFontWithSize:15] aliment:NSTextAlignmentLeft];
            [lable2 sizeToFit];
            lable2.height = kLableHeight-10;
            [bgView addSubview:lable2];
            
            UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(lable2.right+padding, lable2.top, bgView.width-lable2.width-3*padding, kLableHeight-10)];
            textfield.tag = indexPath.row;
            textfield.borderStyle = UITextBorderStyleRoundedRect;
            //            [textfield setBorderStyle:UITextBorderStyleNone];
            textfield.autocorrectionType = UITextAutocorrectionTypeNo;
            textfield.font = [UIFont defaultTextFontWithSize:14];
            textfield.textColor = [UIColor spDefaultTextColor];
            textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
            textfield.delegate = self;
            self.IDTextField = textfield;
            [bgView addSubview:textfield];
            
            UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(padding, bgView.bottom+0.5*kLableHeight, bgView.width-padding*2, kLableHeight)];
            [nextButton setBackgroundImage:[UIImage imageNamed:@"ic_Button"] forState:UIControlStateNormal];
            [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
            nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:text_font+1];
            [nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:nextButton];
        }
    }
    
    //  返回积分  高是50
    if ([title isEqualToString:k_point]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_point];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_point];
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(herizon_padding, 15, 20, 20)];
//            imageView.image = [UIImage imageNamed:@"myPoint"];
//            [cell.contentView addSubview:imageView];
//            
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 0, NAScreenWidth-30-3*herizon_padding, cell_height)];
//            [label setLabelWith:[NSString stringWithFormat:@"返积分%d点",[_detailObj.goods_amount intValue]] color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentLeft];
//            [cell.contentView addSubview:label];
//            
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,label.bottom-1.5f , self.view.width, 1.5f)];
//            lineView.backgroundColor = [UIColor gray1];
//            [cell.contentView addSubview:lineView];
        }
    }
    
    
    
    // 编号  创建时间
    if ([title isEqualToString:k_order]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_fee];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_fee];
//            NSString *idsting = [NSString stringWithFormat:@"订单编号:%@",_detailObj.idNumber];
//            NSString *timeSting  = [NSString stringWithFormat:@"创建时间:%@",_detailObj.foundTime];
//            NSArray *array = @[idsting,timeSting];
//            for (int i=0; i<2; i++) {
//                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(herizon_padding, i*(cell_height2-5), NAScreenWidth-2*herizon_padding, cell_height2-5)];
//                [label setLabelWith:array[i] color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font-2] aliment:NSTextAlignmentLeft];
//                [cell.contentView addSubview:label];
//            }
//            
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,2*cell_height2-10-1.5f , self.view.width, 1.5f)];
//            lineView.backgroundColor = [UIColor gray1];
//            [cell.contentView addSubview:lineView];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
- (void)nextButtonClicked{
    if ([self.IDTextField.text isEmptyString]) {
        [iToast showToastWithText:@"请输入身份证号" position:iToastGravityCenter];
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
    
    NSMutableDictionary *mutaDic = [NSMutableDictionary dictionary];
    [mutaDic setObject:self.currentMember.id forKey:mC_id];
    [mutaDic setObject:self.currentMember.memberShell forKey:m_member_user_shell];
    
    [mutaDic setObject:self.idImageStr forKey:@"idImgA"];
    [mutaDic setObject:self.idbackImageStr forKey:@"idImgB"];
    [mutaDic setObject:self.IDTextField.text forKey:@"IDNumber"];
    [mutaDic setObject:_selectObj.idNumber forKey:@"order_id"];
    NSLog(@"参数%@",mutaDic);

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] postIDInfoToOrderWithParams:mutaDic completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showInfoWithStatus:@"上传成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSPPay object:nil userInfo: nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    if(indexPath.row>=2&&indexPath.row<2+_detailObj.goodsArray.count){
//        ECGoodsObject *object = _detailObj.goodsArray[indexPath.row-2];
//        GoodsDetailController *controller = [[GoodsDetailController alloc] init];
//        controller.goodsId = object.idNumber;
//        [self.navigationController pushViewController:controller animated:YES];
//    }
    
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
