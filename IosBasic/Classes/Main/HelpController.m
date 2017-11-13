//
//  HelpController.m
//  IosBasic
//
//  Created by li jun on 17/4/20.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "HelpController.h"
#import "UIScrollView+RefreshControl.h"
#import "HelpDetailController.h"

#define text_font 15.f
#define padding 10.f
#define herizon_padding 20.f

@interface HelpController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSMutableArray *dataArray;
@end

@implementation HelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self initData];
    //这个的目的是为了使得启动app时，单元格是收缩的
    for (int i=0; i<30; i++) {
        close[i] = YES;
    }
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, NAScreenHeight-kNavigationHeight) ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.wifiTestTriger = YES;
    // Do any additional setup after loading the view.
}
- (void)initData{
    
    _dataArray = [[NSMutableArray alloc] init];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    __weak typeof(self) weakSelf = self;
    [[SPNetworkManager sharedClient] getHelpInfoFirstWithParams:nil completion:^(BOOL succeeded, id responseObject ,NSError *error){
        [SVProgressHUD dismiss];
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.dataArray = responseObject;
                [weakSelf.tableView reloadData];
            });
        }else{
            
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self addBackButton];
    self.title = @"帮助中心";
    self.navigationController.navigationBarHidden = NO;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (close[section]) {
        return 0;
    }
    
     ECHelpMessageObject *obj  = _dataArray[section];
    
    return obj.subArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kDefautCellHeight;
}
//创建组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, kDefautCellHeight)];
    view.tag = 1000 + section;
    view.backgroundColor = [UIColor whiteColor];
    [view addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    ECHelpMessageObject *obj = _dataArray[section];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(herizon_padding, 10, NAScreenWidth-herizon_padding*4, 30)];
    [label setTextColor:[UIColor black2]];
    [label setFont:[UIFont boldDefaultTextFontWithSize:15]];
    label.text = obj.helpTitle;
    [view addSubview:label];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    if(close[section]){
        [imgView setImage:[UIImage imageNamed:@"arrowImage"]];
        imgView.frame = CGRectMake(8, 15, 8, 15);
        
    }else{
        [imgView setImage:[UIImage imageNamed:@"arrowImage1"]];
        imgView.frame = CGRectMake(8, 18, 15, 8);
    }
    imgView.right = NAScreenWidth-herizon_padding;
    [view addSubview:imgView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(herizon_padding, kDefautCellHeight, NAScreenWidth-2*herizon_padding, 0.5)];
    line.backgroundColor = [UIColor gray1];
    line.alpha = 0.3;
    [view addSubview:line];
    
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ECHelpMessageObject *obj = _dataArray[indexPath.section];
//    //定义字体大小
//    return obj.subArray.count*(kDefautCellHeight-10);

    return kDefautCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NACommenCell *cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    ECHelpMessageObject *obj = _dataArray[indexPath.section];
    ECHelpMessageObject *object = obj.subArray[indexPath.row];
    // 按钮未加入到 cell
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(herizon_padding*2, 10, NAScreenWidth-4*herizon_padding, (kDefautCellHeight-10))];
//    [button setTitleColor:[UIColor spThemeColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor spThemeColor] forState:UIControlStateHighlighted];
//    button.titleLabel.font = [UIFont defaultTextFontWithSize:text_font];
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [button setTitle:object.title forState:UIControlStateNormal];
//    button.tag = indexPath.row;
    
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(herizon_padding*2, 10, NAScreenWidth-4*herizon_padding, (kDefautCellHeight-10))];
    lbl.text = object.title;
    lbl.textColor = [UIColor spThemeColor] ;
    [cell.contentView addSubview:lbl];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ECHelpMessageObject *obj = _dataArray[indexPath.section];
    ECHelpMessageObject *object = obj.subArray[indexPath.row];
    HelpDetailController *controller = [[HelpDetailController alloc] init];
    controller.titleStr = object.title;
    controller.time = object.timeA;
    controller.contentHtml = object.content;
    controller.title = @"详情";
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

-(void)sectionClick:(UIControl *)view{
    
    //获取点击的组
    NSInteger i = view.tag - 1000;
    //取反
    close[i] = !close[i];
    //刷新列表
    NSIndexSet * index = [NSIndexSet indexSetWithIndex:i];
    [self.tableView reloadSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Refresh Delegate
////////////////////////////////////////////////////////////////////////////////////

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
