//
//  AgentCustomController.m
//  IosBasic
//
//  Created by junshi on 2017/5/11.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "AgentCustomController.h"

#define text_font 15.f

@interface AgentCustomController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation AgentCustomController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, NAScreenHeight-kNavigationHeight) ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.height = self.view.height - kTransulatInset;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    [self.tableView hideExtraCellHide];
    [self.tableView tableviewSetZeroInsets];
    [self.view addSubview:self.tableView];
    
    
    self.wifiTestTriger = YES;
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self addBackButton];
    self.title = @"我的用户";
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDefautCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"PostReuseID";
    NACommenCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];

    if (!cell) {
        cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        [cell cellSetZeroInsets];
        
    }
    
    ECCustomObject *obj = _datasArray[indexPath.row];
    
    cell.textLabel.text =  obj.member_name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setInsetWithX:0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end
