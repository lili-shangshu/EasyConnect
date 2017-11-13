//
//  AdressViewController.m
//  IosBasic
//
//  Created by li jun on 16/10/12.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "AdressViewController.h"
//#import "AdressNewController.h"
#import "AddressEditController.h"
#import "UIScrollView+RefreshControl.h"


#define cell_height 100.f
#define herizon_padding 20.f
#define vertical_padding 10.f


@interface AdressViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UIImageView *nodataView;

@property(nonatomic)BOOL isChina;

@end

@implementation AdressViewController
NSMutableArray *addressArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor spBackgroundColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 3*kNavigationHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView hideExtraCellHide];
    [self.view addSubview:self.tableView];
    
    self.limits = 10;
    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{mC_id:self.currentMember.id,
    m_member_user_shell:self.currentMember.memberShell}];
    
    self.wifiTestTriger = YES;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addTopRefreshControlUsingBlock:^{
        [weakSelf refreshTopWithCompletion:^{
            [weakSelf showTipsWithCheckingDataArray:weakSelf.dataArray];
            [weakSelf.tableView topRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView topRefreshControlStartInitializeRefreshing];
    });

    NACommonButton *button = [NACommonButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, NAScreenWidth, 44);
    button.bottom = NAScreenHeight-2*64;
    [button setBackgroundColor:[UIColor red2]];
    button.titleLabel.font = [UIFont defaultTextFontWithSize:15.f];
    [button setTitle:@"添加新地址" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    if (!_isFromMine) {
        self.tableView.height = self.view.height - 2*kNavigationHeight;
        button.bottom = NAScreenHeight-64-20;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableWithUpdate) name:kSPAddressUpdate object:nil];
    if (_isChange) {
        if ([_isChange isEqualToString:@"2"]) {
            [self.filterDictionary setObject:@"2" forKey:@"state"];
        }else{
            [self.filterDictionary setObject:@"1" forKey:@"state"];
        }
    }
    
//    else{
//         self.navigationItem.rightBarButtonItem = [UIBarButtonItem NA_BarButtonWithtitile:@"澳洲地址" titleColor:[UIColor whiteColor] target:self action:@selector(changerCountryAction)];
//        [self.filterDictionary setObject:@"1" forKey:@"state"];
//    }
    
}
//- (void)changerCountryAction{
//    
//    self.isChina = !self.isChina;
//    if (self.isChina) {
//         self.navigationItem.rightBarButtonItem = [UIBarButtonItem NA_BarButtonWithtitile:@"中国地址" titleColor:[UIColor whiteColor] target:self action:@selector(changerCountryAction)];
//    }else{
//        self.navigationItem.rightBarButtonItem = [UIBarButtonItem NA_BarButtonWithtitile:@"澳洲地址" titleColor:[UIColor whiteColor] target:self action:@selector(changerCountryAction)];
//    }
//    NSString *state = self.isChina?@"2":@"1";
//    [self.filterDictionary setObject:state forKey:@"state"];
//    [self refreshTableWithUpdate];
//}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//-(UIImageView *)nodataView{
//    if (!_nodataView) {
//        _nodataView = [[UIImageView alloc]initWithFrame:CGRectMake(NAScreenWidth/3, NAScreenHeight/4, NAScreenWidth/3, NAScreenWidth/3)];
//        _nodataView.image = [UIImage imageNamed:@"ic_load_empty.png"];
//        _nodataView.userInteractionEnabled = YES;
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshTableWithUpdate)];
////        tap.numberOfTouches = 1;
//        tap.numberOfTouchesRequired = 1;
//        tap.numberOfTapsRequired = 1;
//        [_nodataView addGestureRecognizer:tap];
//        
//    }
//    return _nodataView;
//}
//- (void)showNodataView:(NSArray *)array{
//
//    if (array.count>0&&array) {
//        [self.nodataView removeFromSuperview];
//    }else{
//        [self.view addSubview:self.nodataView];
//    }
//    
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isChange) {
        self.title = @"请选择地址";
    }else{
        self.title = @"地址管理";
    }
    [self addBackButton];
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)backBarButtonPressed:(id)backBarButtonPressed
{
    if (_isChange) {
        
        if ([_isChange isEqualToString:@"1"]) {
             [self.delegate addressSleclcted:nil isChina:YES];
        }else{
             [self.delegate addressSleclcted:nil isChina:NO];
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButtonAction:(NACommonButton *)button{
        NSLog(@"再来一个");
    AddressEditController *addressVC = [[AddressEditController alloc]init];
    addressVC.title = @"创建新地址";
    if ([self.isChange isEqualToString:@"1"]) {
        addressVC.isChina = YES;
    }else{
        addressVC.isChina = NO;
    }
    addressVC.addNewAddressResultBlock = ^(BOOL isChina) {

        [self refreshTableWithUpdate];
    };
    
    [self.navigationController pushViewController:addressVC animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cell_height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NACommenCell *cell;
        ECAddress *address = _dataArray[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"address"];
        //    if (cell == nil) {
        cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"address"];
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(10, 10, NAScreenWidth-20, cell_height-10)];
        bgview.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgview];
        
        float LableWidth = (bgview.width-20-40)/2;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, LableWidth, 15)];
        nameLabel.text = address.name;
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [UIColor black1];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        cell.customLabel1 = nameLabel;
        [bgview addSubview:nameLabel];
        
        UILabel *pNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, nameLabel.width, nameLabel.height)];
        pNumberLabel.text = address.phone_number;
        pNumberLabel.textColor = [UIColor spDefaultTextColor];
        pNumberLabel.font = [UIFont systemFontOfSize:14];
        pNumberLabel.textAlignment = NSTextAlignmentRight;
        cell.customLabel2 = pNumberLabel;
        [bgview addSubview:pNumberLabel];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom , pNumberLabel.width*2, 50)];
        addressLabel.text = address.address;
        addressLabel.textColor = [UIColor grayColor];
        addressLabel.font = [UIFont systemFontOfSize:13];
        //换行设置
        addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //注意这里UILabel的numberoflines(即最大行数限制)设置成0，即不做行数限制。
        addressLabel.numberOfLines = 0;
        cell.customLabel3 =addressLabel;
        [bgview addSubview:addressLabel];
        
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,20,20)];
        deleteButton.right = bgview.width-10;
        deleteButton.bottom = bgview.height-10;
        deleteButton.tag = [address.addressId integerValue];
        [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setImage:[UIImage imageNamed:@"untrash"] forState:UIControlStateNormal];
        [bgview addSubview:deleteButton];
    
    if (_isChange) {
        UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,20,20)];
        editButton.right = deleteButton.left-10;
        editButton.bottom = bgview.height-10;
        editButton.tag = [address.addressId integerValue];
        [editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [editButton setImage:[UIImage imageNamed:@"unediticon1"] forState:UIControlStateNormal];
        [bgview addSubview:editButton];
    }
    
    
    
        cell.customLabel1.text = address.name;
        cell.customLabel2.text = address.phone_number;
        cell.customLabel3.text = address.address;
        if ([address.isDefault integerValue] == 1) {
            cell.customButton1.selected = YES;
        }else{
            cell.customButton1.selected = NO;
        }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)deleteButtonAction:(UIButton *)button{
    
    UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"删除?" message:@"是否删除？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否",nil];
    [alertView show];
    alertView.tag = button.tag;
    
}
- (void)editButtonAction:(UIButton *)button{
    
    ECAddress *address = [[ECAddress alloc]init];
    for (ECAddress *obj in _dataArray) {
        if ([obj.addressId isEqualToString:[NSString stringWithFormat:@"%li",button.tag]]) {
            address = obj;
        }
    }
    AddressEditController *controller = [[AddressEditController alloc] init];
    controller.editAddress = address;
    controller.title = @"修改地址信息";
    controller.isEdit = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    switch (buttonIndex) {
            //YES应该做的事
        case 0:{
//            NSInteger index = alertView.tag;
//            SPAddressObject *addressObject = _dataArray[index];
            NSDictionary *paramsDict = @{mC_id : self.currentMember.id,
                                         m_member_user_shell:self.currentMember.memberShell,
                                         m_addressid:@(alertView.tag)
                                         };
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [[SPNetworkManager sharedClient] delegateUserAddressWithParams:paramsDict completion:^(BOOL succeeded, id responseObject ,NSError *error){
                if (succeeded) {
                    [iToast showToastWithText:@"地址删除成功" position:iToastGravityCenter];
                    [self refreshTableWithUpdate];
                }
                [SVProgressHUD dismiss];
            }];
            NSLog(@"delete");
            break;
            
        }
            
        case 1://NO应该做的事
            break;
    }
}

#pragma mark -- UITableView  delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECAddress *address = _dataArray[indexPath.row];
    if (!_isFromMine) {
        if ([_isChange isEqualToString:@"1"]) {
            [self.delegate addressSleclcted:address isChina:YES];
        }else{
            [self.delegate addressSleclcted:address isChina:NO];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
       
        AddressEditController *controller = [[AddressEditController alloc] init];
        controller.editAddress = address;
        controller.title = @"修改地址信息";
        controller.isEdit = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Misc
////////////////////////////////////////////////////////////////////////////////////

- (void)reloadingDataAction:(id)sender
{
    [self refreshTableWithUpdate];
}

- (void)refreshTableWithUpdate
{
    [self showLoadingView:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshTopWithCompletion:^{
            [self showTipsWithCheckingDataArray:self.dataArray];
        }];
    });

    
}

- (void)addBottomRefresh
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addBottomRefreshControlUsingBlock:^{
        [weakSelf refreshBottomWith:^{
            [weakSelf.tableView bottomRefreshControlStopRefreshing];
        }];
    } ];
}
- (void)refreshTopWithCompletion:(void(^)())completion{
   
    [self.filterDictionary setObject:@(1) forKey:m_SearchKey_page];
   
     // 当有block时显示转圈
    if (completion) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
    [[SPNetworkManager sharedClient] getUserAddressWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
        [SVProgressHUD dismiss];
        if (succeeded) {

                self.dataArray = responseObject;
              //  [self showNodataView:self.dataArray];
                [self.tableView reloadData];
                if (completion) {
                    completion();
                }
                NSMutableArray *array  = responseObject;
                if ([array count] < self.limits) {
                    [self.tableView removeBottomRefreshControl];
                }else
                    [self addBottomRefresh];
            
        }else{
            if (completion) {
                completion();
            }
        }
    }];
    
}

- (void)refreshBottomWith:(void(^)())completion
{
    [self.filterDictionary setObject:@(self.page) forKey:m_SearchKey_page];
    [[SPNetworkManager sharedClient] getUserAddressWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            // Did Finish Loading
            //            [self updatePullToRefreshStringWithArray:responseObject];
            
            if (succeeded) {
                [self.dataArray addObjectsFromArray:responseObject];
                [self.tableView reloadData];
                
            }
            if (completion) {
                completion();
            }
            NSMutableArray *array  = responseObject;
            if ([array count] < self.limits) {
                [self.tableView removeBottomRefreshControl];
            }else
                [self addBottomRefresh];
        });
    }];
}

- (NSInteger)page
{
    return (self.dataArray.count/self.limits)+1;
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
