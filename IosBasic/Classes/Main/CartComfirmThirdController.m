//
//  CartComfirmThirdController.m
//  IosBasic
//
//  Created by li jun on 17/4/15.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#define k_title @"title"
#define k_info @"info"
#define k_button @"button"

#define padding 10
#define text_font 15.f

#import "CartComfirmThirdController.h"
#import "OrdersManagerController.h"

@interface CartComfirmThirdController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *titleArray;

@end

@implementation CartComfirmThirdController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitleArray];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - kNavigationHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    
    //[self initData];
}
- (void)initTitleArray{
    NSMutableArray *mutaArray = [NSMutableArray arrayWithObjects:k_title, nil];
    [mutaArray addObject:k_info];
    [mutaArray addObject:k_button];
    self.titleArray = mutaArray ;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    [self addBackButton];
    self.title = @"确认订单";
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
    if ([title isEqualToString:k_info]) {
        return 205;
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
                    lable.text = @"订单信息";
                }
                if (i==1) {
                   
                    lable.text = @"支付信息";
                }
                if (i==2) {
                    lable.text = @"下单成功";
                    view.backgroundColor = [UIColor red2];
                    lable.textColor = [UIColor spThemeColor];
                }
            }
        }
    }
    
    if ([title isEqualToString:k_info]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_info];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_info];
            
            UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, 185)];
            bgview.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:bgview];
            
            // 图 两个label   以及黑线
            UIImageView  *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/2-25, 30, 50, 50)];
            imageView.top += 10;
            imageView.image =[UIImage imageNamed:@"submit_button"];
            [bgview addSubview:imageView];
            
            UILabel *submitLable = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom+10, bgview.width, 25)];
            [submitLable setLabelWith:@"订单支付成功" color:[UIColor black4] font:[UIFont boldSystemFontOfSize:text_font+1] aliment:NSTextAlignmentCenter];
            [bgview addSubview:submitLable];
            
            UILabel *subTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, submitLable.bottom, submitLable.width, 20)];
            [subTitleLable setLabelWith:@"请耐心等待商家发货，我们将第一时间为您安排递送" color:[UIColor spDefaultTextColor] font:[UIFont systemFontOfSize:text_font-3] aliment:NSTextAlignmentCenter];
            [bgview addSubview:subTitleLable];

            // 虚线
//            UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(padding, subTitleLable.bottom+19, bgview.width-2*padding, 1)];
//            lineview.backgroundColor = [UIColor spBackgroundColor];
//            [bgview addSubview:lineview];
            
            // 订单号
//            UILabel *orderNumLable = [[UILabel alloc]initWithFrame:CGRectMake(10, lineview.bottom+25, bgview.width/4-10, 25)];
//            [orderNumLable setLabelWith:@"订单号:" color:[UIColor black4] font:[UIFont systemFontOfSize:text_font-1] aliment:NSTextAlignmentLeft];
//            [bgview addSubview:orderNumLable];
//            
//            UILabel *orderNumLable2 = [[UILabel alloc]initWithFrame:CGRectMake(orderNumLable.right, orderNumLable.top, bgview.width*3/4-10, 25)];
//            [orderNumLable2 setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont systemFontOfSize:text_font] aliment:NSTextAlignmentLeft];
//            if (_orderNum) {
//                orderNumLable2.text = _orderNum;
//            }
//            [bgview addSubview:orderNumLable2];
            
        }
    }
    
    if ([title isEqualToString:k_button]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_button];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_button];
            
            UIButton *gocartButton = [[UIButton alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, 40)];
            [gocartButton setBackgroundImage:[UIImage imageNamed:@"ic_Button"] forState:UIControlStateNormal];
            [gocartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [gocartButton setTitle:@"去购物车" forState:UIControlStateNormal];
            gocartButton.titleLabel.font = [UIFont boldSystemFontOfSize:text_font+1];
            [gocartButton addTarget:self action:@selector(gocartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:gocartButton];
            if (_isOrderpay) {
                gocartButton.hidden = YES;
            }else{
                gocartButton.hidden = NO;
            }
            
            UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(gocartButton.left, gocartButton.bottom+10, gocartButton.width, 40)];
            [nextButton setBackgroundColor:[UIColor red2]];
            [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [nextButton setTitle:@"返回首页" forState:UIControlStateNormal];
            nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:text_font+1];
            [nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:nextButton];
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

#pragma mark ---Uibutton
- (void)gocartButtonClicked{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)nextButtonClicked{
    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *myDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myDelegate.mainTabbarController setSelectedIndex:0];
    
}
- (void)backBarButtonPressed:(id)backBarButtonPressed
{
    if (_isOrderpay) {
        // 跳转到orderView页面
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[OrdersManagerController class]]) {
                OrdersManagerController *A =(OrdersManagerController *)controller;
                [self.navigationController popToViewController:A animated:YES];
            }
        }
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
    
//    [self.navigationController popViewControllerAnimated:YES];
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
