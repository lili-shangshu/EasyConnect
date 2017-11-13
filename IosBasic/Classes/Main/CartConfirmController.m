//
//  CartConfirmController.m
//  IosBasic
//
//  Created by Apple on 16/10/16.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "CartConfirmController.h"
#import "NAAccesorryView.h"
#import "ShopCartCellView.h"
#import "AdressViewController.h"
#import "AddressEditController.h"
#import "DistributionController.h"
#import "InvoiceController.h"
#import "CartConfirmSecondController.h"
#import <YYModel/YYModel.h>

#import <Reachability.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "NACTPageViewController.h"
#import <CTAssetsPickerController.h>
#import "NATextField.h"

#import "WarehouseController.h"
#import "DeliveryController.h"
#import "PickerChoiceView.h"

#import "XTPopView.h"
#import "AppDelegate.h"


#define k_title @"title"
#define k_address @"address" // 这里增加一个没有配送信息的地址
#define k_CartsHead @"cartshead"  // 商品信息  上面增加标题，下面增加页尾
#define k_Carts @"carts"  // 商品信息  上面增加标题，下面增加页尾
#define k_message @"买家留言"
#define k_button @"button"  // 两个button


#define k_distribution @"配送方式"
#define k_invoice @"发票类型"
#define k_red @"使用红包"
#define k_score @"积分"

#define k_total @"订单总额"

#define k_choosedisributon @"请选择配送方式"
#define k_chooseInvoice @"请选择发票类型"


// y
#define padding 10.f
// x
#define herizon_padding 20.f

#define text_font 15.f
#define cart_height 130.f
#define cell_height  50.f

@interface CartConfirmController ()<UITableViewDataSource,UITableViewDelegate,AdressViewControllerDelegate,UITextViewDelegate,TFPickerDelegate,selectIndexPathDelegate>


@property(nonatomic,strong)UITextView *messageTextView;

@property (nonatomic,strong) UILabel *totalLabel;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)XTPopView *popView;

@property (strong, nonatomic) ALAssetsLibrary* library;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) UIView *imagesContainor;


@property(nonatomic,strong)UIImageView *distributionImageV1; // 自取
@property(nonatomic,strong)UILabel *distributionlable1; // 自取
@property(nonatomic,strong)UIImageView *distributionImageV2; // 快递
@property(nonatomic,strong)UILabel *distributionlable2; // 自取
@property(nonatomic,strong)UIImageView *distributionImageV3; // 送货上门
@property(nonatomic,strong)UILabel *distributionlable3; // 自取

@property(nonatomic)NSInteger typeNum; // 1 自取 2快递 3送到门口


@property(nonatomic,strong)NSString *warehouseId; // 仓库ID

@property(nonatomic,strong)NSString *deliceryId; // 快递公司

@property(nonatomic)BOOL showAddID;

@end

@implementation CartConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTitleArray];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - kNavigationHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
     self.library = [[ALAssetsLibrary alloc] init];
    // Do any additional setup after loading the view.
}

- (void)initTitleArray{
    NSMutableArray *mutaArray = [NSMutableArray arrayWithObjects:k_title, nil];
    [mutaArray addObject:k_address];
    [mutaArray addObject:k_message];
    [mutaArray addObject:k_CartsHead];
    for (int i=0; i<self.cartsArray.count; i++) {
        [mutaArray addObject:k_Carts];
    }
    [mutaArray addObject:k_button];
    self.titleArray = mutaArray ;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    [self addBackButton];
    if (_showHome) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];;
        [button setImage:[UIImage imageNamed:@"back_home"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5);
        //    UIEdgeInsetsMake(CGFloat top, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
        [button addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.width = button.width;
        button.height = 44.f;
        UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightbtn;
    }
    self.title = @"确认订单";
}
- (void)rightBtnAction:(UIButton *)sender{
    
    NSArray  *classfyArray = @[@"返回首页"];
    CGPoint point = CGPointMake(sender.left+sender.width/2 , sender.bottom);
    XTPopView *view1 = [[XTPopView alloc] initWithOrigin:point Width:100 Height:40*classfyArray.count Type:XTTypeOfUpRight Color:[UIColor whiteColor]];
    view1.dataArray = classfyArray;
    view1.fontSize = 13;
    view1.row_height = 40;
    view1.titleTextColor = [UIColor blackColor];
    view1.delegate = self;
    _popView = view1;
    [_popView popView];
}
- (void)selectIndexPathRow:(NSInteger )index{
    [_popView dismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.mainTabbarController.selectedIndex = 0;
    //    self.tabBarController.selectedIndex = 0;
    return;
    
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
    if ([title isEqualToString:k_address]) {
        if (_selectAddress) {
            return 155 +90 ;
        }else{
            return 155;
        }
    }else if([title isEqualToString:k_message]){
        return 130+10 ;
    }else if([title isEqualToString:k_CartsHead]){
        return 50 ;
    }else if([title isEqualToString:k_Carts]){
        return 90;
    }else if([title isEqualToString:k_button]){
        return 110+30;
    }else {
        // title
        return 90;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NACommenCell *cell;
    NSString *title = self.titleArray[indexPath.row];
    if ([title isEqualToString:k_address]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_address];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_address];
        }
            // 暂时设置－－肯定有返回地址
//            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, 220)];
//            bgView.backgroundColor = [UIColor whiteColor];
//            [cell.contentView addSubview:bgView];
            
            UIButton *bgView = [[UIButton alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, 145)];
            bgView.backgroundColor  = [UIColor whiteColor];
//            [bgView addTarget:self action:@selector(selectAddressButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:bgView];
            
            // title
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 5, bgView.width-2*padding, 30)];
            [lable setLabelWith:@"配送方式" color:[UIColor red2] font:[UIFont boldSystemFontOfSize:text_font+1] aliment:NSTextAlignmentLeft];
            [bgView addSubview:lable];
            // 红线
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(padding, lable.bottom+4, bgView.width-2*padding, 1)];
            view.backgroundColor = [UIColor red2];
            [bgView addSubview:view];
            for (int i=0; i<3; i++) {
                //uibu
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(padding, view.bottom +i*35, view.width, 35)];
                button.tag = i;
                [button addTarget:self action:@selector(distributionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [bgView addSubview:button];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5,  button.height-10, button.height-10)];
                imageView.image = [UIImage imageNamed:@"address-D"];
                [button addSubview:imageView];
                
                
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+padding, 0, button.width/2-imageView.right-padding, button.height)];
                [lable setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentLeft];
                [button addSubview:lable];
                
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, lable.bottom-1, button.width, 1)];
                lineView.backgroundColor = [UIColor grayColor];
                lineView.alpha = 0.2;
                [button addSubview:lineView];
                
                UILabel *sublable = [[UILabel alloc]initWithFrame:CGRectMake(lable.right, 0, button.width/2-10, button.height)];
                [sublable setLabelWith:@"" color:[UIColor red2] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentRight];
                sublable.hidden = YES;
                [button addSubview:sublable];
                
                
                if (i==0) {
                    lable.text = @"自取(仓库)";
                    self.distributionImageV1 = imageView;
                    self.distributionlable1 = sublable;
                    
                }else if (i==1){
                    lable.text = @"包邮速递";
                    self.distributionImageV2 = imageView;
                    self.distributionlable2 = sublable;
                }else{
                    lable.text = @"送货上门";
                    self.distributionImageV3 = imageView;
                    self.distributionlable3 = sublable;
                    [lineView removeFromSuperview];
                }
                
            }
            
            if (_selectAddress) {
                bgView.height += 90;
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(padding, 145, bgView.width-2*padding, 1)];
                lineView.backgroundColor = [UIColor grayColor];
                lineView.alpha = 0.2;
                [bgView addSubview:lineView];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, lineView.bottom+4, lable.width-20, 25.f)];
                NSString *atring = [NSString stringWithFormat:@"%@ (收)       %@",_selectAddress.name,_selectAddress.phone_number];
                nameLabel.text = atring;
                nameLabel.textColor =  [UIColor spDefaultTextColor];
                nameLabel.font = [UIFont systemFontOfSize:15];
                [bgView addSubview:nameLabel];
                
                UILabel *addresslable = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, 60.f)];
                addresslable.numberOfLines = 0;
                addresslable.text = _selectAddress.address;
                addresslable.textColor =  [UIColor spDefaultTextColor];
                addresslable.font = [UIFont systemFontOfSize:14];
                [bgView addSubview:addresslable];
                
            }
            /*
            //  10  30 49   100
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, view.bottom+5, lable.width-40, 25.f)];
            NSString *atring = [NSString stringWithFormat:@"%@ 收       %@",_selectAddress.name,_selectAddress.phone_number];
            nameLabel.text = atring;
            nameLabel.textColor =  [UIColor spDefaultTextColor];
            self.addressnameLable = nameLabel;
            nameLabel.font = [UIFont systemFontOfSize:15];
            [bgView addSubview:nameLabel];
            
            UILabel *addresslable = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, 60.f)];
            addresslable.numberOfLines = 0;
            addresslable.text = _selectAddress.address;
             addresslable.textColor =  [UIColor spDefaultTextColor];
            addresslable.font = [UIFont systemFontOfSize:14];
            self.addressLable =addresslable;
            [bgView addSubview:addresslable];
            
            
            UIButton *selectButton = [[UIButton alloc]initWithFrame:CGRectMake(addresslable.right+10, view.bottom, 40, 90)];
            [selectButton setImage:[UIImage imageNamed:@"arrowImage_red"] forState:UIControlStateNormal];
            selectButton.imageEdgeInsets = UIEdgeInsetsMake(35, 15, 35, 15);
            [selectButton addTarget:self action:@selector(selectAddressButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:selectButton];
            */
        
    }
    
    if ([title isEqualToString:k_message]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_message];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_message];
            
            UIView *bgView = [[UIButton alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, 130)];
            bgView.backgroundColor  = [UIColor whiteColor];
            [cell.contentView addSubview:bgView];
            
            // title
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 5, bgView.width-2*padding, 30)];
            [lable setLabelWith:@"留言信息" color:[UIColor red2] font:[UIFont boldSystemFontOfSize:text_font+1] aliment:NSTextAlignmentLeft];
            [bgView addSubview:lable];
            // 红线
            UIView *redlineview = [[UIView alloc]initWithFrame:CGRectMake(padding, lable.bottom+4, bgView.width-2*padding, 1)];
            redlineview.backgroundColor = [UIColor red2];
            [bgView addSubview:redlineview];
            
            UITextView *textVIew = [[ UITextView alloc]initWithFrame:CGRectMake(padding, redlineview.bottom+4, redlineview.width, 80)];
            textVIew.backgroundColor = [UIColor spBackgroundColor];
            textVIew.font = [UIFont systemFontOfSize:text_font];
            textVIew.placeholder = @"请填写您的留言";
            textVIew.returnKeyType = UIReturnKeyDone;
            textVIew.delegate =self;
            self.messageTextView = textVIew;
            [bgView addSubview:textVIew];
            
        }
    }
    
    if ([title isEqualToString:k_CartsHead]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_CartsHead];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_CartsHead];
            
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, 40)];
            bgView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:bgView];
            
            // title 和红线
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 5, bgView.width-2*padding, 30)];
            [lable setLabelWith:@"商品信息" color:[UIColor red2] font:[UIFont boldSystemFontOfSize:text_font+1] aliment:NSTextAlignmentLeft];
            [bgView addSubview:lable];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(padding, lable.bottom+4, bgView.width-2*padding, 1)];
            view.backgroundColor = [UIColor red2];
            [bgView addSubview:view];
            
        }
    }
    
    
    if ([title isEqualToString:k_Carts]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_Carts];
       
        if (!cell || !cell.customView1) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_Carts];
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(padding, 0, NAScreenWidth-2*padding, 90)];
            bgView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:bgView];
            
            //商品的四个元素
            UIImageView *iamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(padding, 5, 80, 80)];
            cell.customImageView = iamgeView;
            [bgView addSubview:iamgeView];
            
            //灰色的县
            UIView *garylineView = [[UIView alloc]initWithFrame:CGRectMake(padding, iamgeView.bottom+4, bgView.width-2*padding, 1)];
            garylineView.backgroundColor = [UIColor spBackgroundColor];
            [bgView addSubview:garylineView];
            
            //title
            UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(iamgeView.right+10, 5, bgView.width-iamgeView.right-2*padding, 50)];
            [titleLable setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont systemFontOfSize:text_font-1] aliment:NSTextAlignmentLeft];
            titleLable.numberOfLines = 0;
            cell.customLabel1 = titleLable;
            [bgView addSubview:titleLable];
            
            UILabel *PriceLable = [[UILabel alloc]initWithFrame:CGRectMake(titleLable.left, titleLable.bottom, titleLable.width/2, 30)];
            [PriceLable setLabelWith:@"" color:[UIColor red2] font:[UIFont systemFontOfSize:text_font+1] aliment:NSTextAlignmentLeft];
            cell.customLabel2 = PriceLable;
            [bgView addSubview:PriceLable];
            
            UILabel *Numberlable = [[UILabel alloc]initWithFrame:CGRectMake(PriceLable.right, titleLable.bottom, titleLable.width/2, 30)];
            [Numberlable setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont systemFontOfSize:text_font-1] aliment:NSTextAlignmentRight];
            cell.customLabel3 = Numberlable;
            [bgView addSubview:Numberlable];
             cell.customView1 = bgView;

        }
        ECGoodsObject *object = _cartsArray[indexPath.row-4];
        cell.customLabel1.text = object.name;
        [cell.customImageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:object.imageUrl]];
        cell.customLabel2.text = [@"$:" stringByAppendingString:[NSString stringWithFormat:@"%.2f",[object.goodsPrice floatValue]]] ;
        cell.customLabel3.text = [NSString stringWithFormat:@"X %d",[object.selectNum intValue]];
        self.totalMoney += [object.goodsPrice floatValue] *[object.selectNum intValue];
    }
    
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
                    view.backgroundColor = [UIColor red2];
                    lable.textColor = [UIColor spThemeColor];
                    lable.text = @"生成订单";
                }
                if (i==1) {
                    lable.text = @"订单详情";
                }
                if (i==2) {
                    lable.text = @"下单成功";
                }
            }
        }
    }
    
    
    if ([title isEqualToString:k_button]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_button];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_button];
        
            UILabel *totallable = [[UILabel alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, 35)];
            [totallable setLabelWith:[NSString stringWithFormat:@"合计：$%.2f",self.totalMoney] color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:text_font] aliment:NSTextAlignmentCenter];
            totallable.backgroundColor = [UIColor red2];
            self.totalLabel = totallable;
            [cell.contentView addSubview:totallable];
            
            UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(totallable.left, totallable.bottom+20, totallable.width, 40)];
            [nextButton setBackgroundImage:[UIImage imageNamed:@"ic_Button"] forState:UIControlStateNormal];
            [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
            nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:text_font+1];
            [nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:nextButton];
        }
    }
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)distributionButtonClicked:(UIButton *)sender{
    if (sender.tag == 0) {
        
        _typeNum = 1;
        self.distributionlable2.hidden = YES;
        self.distributionlable3.hidden = YES;
        self.distributionImageV1.image = [UIImage imageNamed:@"address-D1"];
        self.distributionImageV2.image = [UIImage imageNamed:@"address-D"];
        self.distributionImageV3.image = [UIImage imageNamed:@"address-D"];
        
        WarehouseController *conV = [[WarehouseController alloc]init];
        conV.selectResultBlock = ^(WarehouseObject *obj) {
            
            _selectAddress = nil;
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
             self.distributionImageV1.image = [UIImage imageNamed:@"address-D1"];
            
            if (obj) {
                self.distributionlable1.hidden = NO;
                self.distributionlable1.text = obj.name;
                self.warehouseId = obj.id;
            }else{
                _warehouseId = nil;
                self.distributionlable1.hidden = NO;
                self.distributionlable1.text = @"请选择仓库";
            }

        };
        [self.navigationController pushViewController:conV animated:YES];
        
        
    }else if(sender.tag == 1){
        
        _selectAddress = nil;
        _typeNum = 2;
        self.distributionlable1.hidden = YES;
        self.distributionlable3.hidden = YES;
        self.distributionImageV1.image = [UIImage imageNamed:@"address-D"];
        self.distributionImageV2.image = [UIImage imageNamed:@"address-D1"];
        self.distributionImageV3.image = [UIImage imageNamed:@"address-D"];
        
        AdressViewController *addressVC = [[AdressViewController alloc]init];
        addressVC.delegate = self;
        addressVC.isChange = @"1";
        [self.navigationController pushViewController:addressVC animated:YES];
        
        
    }else{
        _typeNum = 3;
        _selectAddress = nil;
         self.distributionlable1.hidden = YES;
        self.distributionlable2.hidden = YES;
        self.distributionImageV1.image = [UIImage imageNamed:@"address-D"];
        self.distributionImageV2.image = [UIImage imageNamed:@"address-D"];
        self.distributionImageV3.image = [UIImage imageNamed:@"address-D1"];
        
        AdressViewController *addressVC = [[AdressViewController alloc]init];
        addressVC.delegate = self;
        addressVC.isChange = @"2";
        [self.navigationController pushViewController:addressVC animated:YES];
        
    }
}

#pragma mark----addreddVC delegert

- (void)addressSleclcted:(ECAddress *)selectAddress isChina:(BOOL)isChina{
    
    if (selectAddress) {
        _selectAddress = selectAddress;
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        if (isChina) {
            self.distributionImageV2.image = [UIImage imageNamed:@"address-D1"];
            
//            if (isChina) {
//                if (KIsBlankString(selectAddress.idImgA)||KIsBlankString(selectAddress.idImgB)||KIsBlankString(selectAddress.IDNumber)) {
//                    _showAddID = YES;
//                }
//            }

        }else{
             self.distributionImageV3.image = [UIImage imageNamed:@"address-D1"];
        }
       
    }else{
        if (isChina) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
            self.distributionImageV2.image = [UIImage imageNamed:@"address-D1"];
            self.distributionlable2.hidden = NO;
            self.distributionlable2.text = @"请选择地址";
        }else{
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
            self.distributionImageV3.image = [UIImage imageNamed:@"address-D1"];
            self.distributionlable3.hidden = NO;
            self.distributionlable3.text = @"请选择地址";
        }
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *title = self.titleArray[indexPath.row];

}


#pragma maek----textdelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect frame=[textView convertRect: textView.bounds toView:window];
    
    int offset = frame.origin.y + 8 - (self.view.frame.size.height - 216.0)+textView.height;//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    if(offset > 0)
//        self.tableView.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.height  - kNavigationHeight);
    
    
    if(offset > 0) self.tableView.top =  -offset;
    
    [UIView commitAnimations];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
//     self.tableView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.height- kNavigationHeight);
    self.tableView.top =  0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark----UIbutton

- (void)nextButtonClicked{
    // 创建订单后跳转到我的订单---待支付页面
    NSMutableDictionary *mutaDic = [NSMutableDictionary dictionary];
    [mutaDic setObject:self.currentMember.id forKey:mC_id];
    [mutaDic setObject:self.goodsID forKey:@"cardsID"];
    [mutaDic setObject:self.currentMember.memberShell forKey:m_member_user_shell];
    
    //    接口暂不支持留言
    NSString *messageStr = _messageTextView.text;
    if (KIsBlankString(_messageTextView.text)) {
        messageStr = @"无";
    }
    [mutaDic setObject:messageStr forKey:@"pay_message"];
   
    if (_typeNum!=1&&_typeNum!=2&&_typeNum!=3) {
        [SVProgressHUD showInfoWithStatus:@"请选择配送方式"];
        return;
    }
    
    if (_typeNum == 1) {
        // 仓库
        if (!_warehouseId) {
             [SVProgressHUD showInfoWithStatus:@"请选择仓库"];
            return;
        }
         [mutaDic setObject:@1 forKey:@"typeNum"];
         [mutaDic setObject:_warehouseId forKey:@"warehouseID"];
    }else{
        if (!_selectAddress) {
            [SVProgressHUD showInfoWithStatus:@"请选择地址"];
            return;
        }
//        if (_typeNum == 2) {
//            // 国内
//            [mutaDic setObject:@2 forKey:@"typeNum"];
//            [mutaDic setObject:_selectAddress.addressId forKey:@"addressID"];
//            [mutaDic setObject:_deliceryId forKey:@"companyID"];
//        }else{
//            [mutaDic setObject:@3 forKey:@"typeNum"];
//            [mutaDic setObject:_selectAddress.name forKey:@"name2"];
//            [mutaDic setObject:_selectAddress.phone_number forKey:@"phone2"];
//            [mutaDic setObject:_selectAddress.address forKey:@"address2"];
//        }
        
        if (_typeNum == 2) {
            // 国内
            [mutaDic setObject:@2 forKey:@"typeNum"];
            [mutaDic setObject:_selectAddress.addressId forKey:@"addressID"];
        }else{
            [mutaDic setObject:@3 forKey:@"typeNum"];
            [mutaDic setObject:_selectAddress.addressId forKey:@"addressID"];
        }
    }
    NSLog(@"%@",mutaDic);
    
    // 测试数据
     [mutaDic setObject:@1 forKey:@"test"];
    
 // 创建订单
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] submitOrderWithParams:mutaDic completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded&&responseObject) {
            
            NAPostNotification(kSPUpdateCarts, nil);
            NSArray *response = responseObject;
            CartConfirmSecondController *secondC = [[CartConfirmSecondController alloc]init];
            // 可能产生几个订单的情况
            secondC.ordersArray = response;
            [self.navigationController pushViewController:secondC animated:YES];
            [SVProgressHUD dismiss];
        }
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
