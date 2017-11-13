//
//  DistributionController.m
//  IosBasic
//
//  Created by li jun on 16/10/17.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "DistributionController.h"
#import "UIScrollView+RefreshControl.h"
#import "TQRichTextView.h"

#define herizon_padding 20.f
#define vertical_padding 10.f

#define height_lable 50.f
#define button_width 20.f
#define text_font 15.f


@interface DistributionController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation DistributionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - kNavigationHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 在最后增加一个按钮
    //    self.tableView.height = self.view.height - kTransulatInset-kTransulatInset;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView hideExtraCellHide];
    [self.view addSubview:self.tableView];
    
    //    self.limits = 10;
    //    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":self.currentMember.id}];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addTopRefreshControlUsingBlock:^{
        [weakSelf showTipsWithCheckingDataArray:nil];
        [weakSelf refreshTopWithCompletion:^{
            [weakSelf showTipsWithCheckingDataArray:weakSelf.dataArray];
            [weakSelf.tableView topRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView topRefreshControlStartInitializeRefreshing];
    });
    // Do any additional setup after loading the view.
}

- (void)refreshTopWithCompletion:(void(^)())completion{
    //
    //    [self.filterDictionary setObject:[NADefaults sharedDefaults].memberUserShell forKey:m_member_user_shell];
    //    [self.filterDictionary setObject:@(1) forKey:m_SearchKey_page];
    //    [[SPNetworkManager sharedClient] loadAddressWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
    //        if (succeeded) {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                self.dataArray = responseObject;
    //                [self.tableView reloadData];
    //
    //                if (completion) {
    //                    completion();
    //                }
    //                NSMutableArray *array  = responseObject;
    //                if ([array count] < self.limits) {
    //                    [self.tableView removeBottomRefreshControl];
    //                }else
    //                    [self addBottomRefresh];
    //            });
    //
    //        }else{
    //
    //            if (completion) {
    //                completion();
    //            }
    //        }
    //    }];
    
    NSMutableArray *Array = [NSMutableArray array];
    
    DistributionModel *model1= [[DistributionModel alloc]init];
    model1.distributionName= @"邮局平邮";
    model1.distributioninfo = @"邮局平邮对描述内容";
    
    model1.distributionPrice = 3.5;
    
    
    DistributionModel *model2= [[DistributionModel alloc]init];
    model2.distributionName= @"顺丰快递";
    model2.distributioninfo = @"截至2015年底，顺丰已拥有约1.5万台营运车辆，以及遍布中国大陆的近1.3万个营业网点。此外，公司目前拥有30架自有全货机。与此同时，顺丰积极拓展国际件服务，目前已开通美国、日本、韩国、新加坡、马来西亚、泰国、越南、澳大利亚、蒙古等国家的快递服务";
    model2.distributionPrice = 5.0;
    
    for (int i=0; i<2; i++) {
         [Array addObject:model1];
         [Array addObject:model2];
    }
    
    self.dataArray = [NSMutableArray arrayWithArray:Array];
    [self.tableView reloadData];
    if (completion) {
        completion();
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DistributionModel *model = _dataArray[indexPath.row];
    return [self cellHeightbyModel:model]+11.f;
}

- (float)cellHeightbyModel:(DistributionModel *)distributionMOdel{
    float cellHeight = height_lable*1.3;
    float width = self.view.width - vertical_padding*3-herizon_padding-button_width-80.f;
    cellHeight += [TQRichTextView heightWithText:distributionMOdel.distributioninfo width:width font:[UIFont defaultTextFontWithSize:text_font-2]];
    return cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   DistributionModel *model = _dataArray[indexPath.row];
    NACommenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address"];
    //    if (cell == nil) {
    cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"address"];
    
    UIButton *setAddressButton = [[UIButton alloc] initWithFrame:CGRectMake(herizon_padding,vertical_padding, 20, 20)];
    [setAddressButton setBackgroundImage:[UIImage imageNamed:@"circle_selected"] forState:UIControlStateSelected];
    [setAddressButton setBackgroundImage:[UIImage imageNamed:@"circle_unselected"] forState:UIControlStateNormal];
    if ([self.selecdName isEqualToString:model.distributionName]) {
        setAddressButton.selected = YES;
    }
    setAddressButton.tag = indexPath.row;
//    [setAddressButton addTarget:self action:@selector(setAddressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.customButton1 = setAddressButton;
    [cell.contentView addSubview:setAddressButton];
    
    UILabel *namelable = [[UILabel alloc]initWithFrame:CGRectMake(setAddressButton.right+vertical_padding, 0, 80.f, height_lable)];
    [namelable setLabelWith:model.distributionName color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentCenter];
    [cell.contentView addSubview:namelable];
    
     float width = self.view.width - vertical_padding*3-herizon_padding-button_width-80.f;
    UILabel *pricelable = [[UILabel alloc]initWithFrame:CGRectMake(namelable.right+vertical_padding, 0, width, height_lable*0.8)];
    NSString *string = [NSString stringWithFormat:@"配送费用：$：%.2f",model.distributionPrice];
    [pricelable setLabelWith:string color:[UIColor blackColor] font:[UIFont defaultTextFontWithSize:text_font-2] aliment:NSTextAlignmentLeft];
    [cell.contentView addSubview:pricelable];
    
    UILabel *redlable = [[UILabel alloc]initWithFrame:CGRectMake(pricelable.left, pricelable.bottom, pricelable.width, height_lable*0.5)];
    [redlable setLabelWith:@"配送价格不可使用红包／积分抵现" color:[UIColor redColor] font:[UIFont defaultTextFontWithSize:text_font-4] aliment:NSTextAlignmentLeft];
    redlable.numberOfLines = 0;
    [cell.contentView addSubview:redlable];
    
    
    float hegith = [TQRichTextView heightWithText:model.distributioninfo width:width font:[UIFont defaultTextFontWithSize:text_font-2]];
    UILabel *infolable = [[UILabel alloc]initWithFrame:CGRectMake(redlable.left, redlable.bottom, redlable.width, hegith)];
    [infolable setLabelWith:model.distributioninfo color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font-2] aliment:NSTextAlignmentLeft];
    infolable.numberOfLines = 0;
    [cell.contentView addSubview:infolable];
    
//    namelable.backgroundColor = [UIColor red2];
//    pricelable.backgroundColor = [UIColor yellowColor];
//    redlable.backgroundColor = [UIColor blue1];
//    infolable.backgroundColor = [UIColor red2];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,infolable.bottom+ vertical_padding, self.view.width, 1.f)];
    lineView.backgroundColor = [UIColor gray1];
    [cell.contentView addSubview:lineView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DistributionModel *model = _dataArray[indexPath.row];
    self.selecdName = model.distributionName;
    [self.delegate distributonSelected:model];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"配送方式";
    [self addBackButton];
    self.navigationController.navigationBarHidden = NO;
    
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
