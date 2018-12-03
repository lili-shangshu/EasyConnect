//
//  BillController.m
//  IosBasic
//
//  Created by junshi on 16/8/17.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "BillController.h"
#import "UIScrollView+RefreshControl.h"


#define  herizon_padding 20
#define  vertical_padding 30
#define  title_width 80
#define  title_height 44
#define  button_width 30
#define  title_font_size 17
#define  content_font_size 15
#define  view1_height 171
#define  cell_height 70



@interface BillController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation BillController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  [self initData];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, NAScreenHeight-kNavigationHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.limits = 10;
    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{m_id:self.currentMember.id,
                                                                            m_lang:[NADefaults sharedDefaults].lang,
                                                                            m_member_user_shell:self.currentMember.memberShell}];
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
    
    self.wifiTestTriger = YES;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return cell_height ;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NACommenCell *cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, cell_height)];
    BillObject *obj = _dataArray[indexPath.row];
    
    UIImageView *sImg = [[UIImageView alloc] initWithFrame:CGRectMake(herizon_padding, 15, 15, 25)];
    [view addSubview:sImg];
    
    UIImageView *s1Img = [[UIImageView alloc] initWithFrame:CGRectMake(sImg.right + herizon_padding, 25, 10, 10)];
    [view addSubview:s1Img];
    
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(s1Img.right + herizon_padding/3, sImg.top, (NAScreenWidth-herizon_padding*2)/2, sImg.height)];
    [titleLbl setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:23]];
    [view addSubview:titleLbl];

    
    
    
    if(obj.income>0){
        [sImg setImage:[UIImage imageNamed:@"ic_arrow_up"]];
        [s1Img setImage:[[UIImage imageNamed:@"ic_add"] imageWithColor:[UIColor blue1]]];
        [titleLbl setTextColor:[UIColor blue1]];
        [titleLbl setText:[NSString stringWithFormat:@"%.2f",obj.income]];
        
    }else{
        [sImg setImage:[[UIImage imageNamed:@"ic_arrow_down"] imageWithColor:[UIColor red2]]];
        [s1Img setImage:[[UIImage imageNamed:@"ic_minus"] imageWithColor:[UIColor red2]]];
        [titleLbl setTextColor:[UIColor red2]];
        [titleLbl setText:[NSString stringWithFormat:@"%.2f",-obj.income]];
        
    }

   
    
    UILabel *subTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(s1Img.left, titleLbl.bottom, (NAScreenWidth-herizon_padding*2)*2/3, 20)];
    [subTitleLbl setText:obj.incomeDesc];
    [subTitleLbl setTextColor:[UIColor gray2]];
    [subTitleLbl setFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:13]];
    [view addSubview:subTitleLbl];
    
    
    UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(titleLbl.right+15, titleLbl.top,20, 10)];
    [timeLbl setText:obj.time];
    [timeLbl setTextAlignment:NSTextAlignmentRight];
    
    [timeLbl setTextColor:[UIColor gray2]];
    [timeLbl setFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:12]];
    [timeLbl sizeToFit];
    timeLbl.right = NAScreenWidth-herizon_padding;
    [view addSubview:timeLbl];
    
    UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(titleLbl.right+15, timeLbl.bottom,20, 10)];
    [dateLbl setText:obj.date];
    [dateLbl setTextAlignment:NSTextAlignmentRight];
    [dateLbl setTextColor:[UIColor gray2]];
    [dateLbl setFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:12]];
    [dateLbl sizeToFit];
    dateLbl.right = NAScreenWidth-herizon_padding;
    [view addSubview:dateLbl];

    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell_height, NAScreenWidth, 0.5)];
    line.backgroundColor = [UIColor gray1];
    line.alpha = 0.3;
    [view addSubview:line];
    
    
    [cell.contentView addSubview:view];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Refresh Delegate
////////////////////////////////////////////////////////////////////////////////////

- (void)refreshTopWithCompletion:(void(^)())completion
{
    
    [self.filterDictionary setObject:@(1) forKey:m_SearchKey_page];
    [[SPNetworkManager sharedClient] recordWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.dataArray = responseObject;
                [self.tableView reloadData];
                
                if (completion) {
                    completion();
                }
                NSMutableArray *array  = responseObject;
                if ([array count] < self.limits) {
                    [self.tableView removeBottomRefreshControl];
                }else
                    [self addBottomRefresh];
            });
            
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
    [[SPNetworkManager sharedClient] recordWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
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



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = NSLocalizedString(@"btc_bill", @"");
    
    UIBarButtonItem *backBtn = [UIBarButtonItem NA_BarButtonWithImage:[UIImage imageNamed:@"ic_arrow_left"] width:12 height:22 target:self   action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
}


- (void)backBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
