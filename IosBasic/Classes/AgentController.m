//
//  AgentController.m
//  IosBasic
//
//  Created by junshi on 2017/5/11.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "AgentController.h"
#import "SPNetworkManager.h"
#import "AgentCustomController.h"
#import "AgentWithdrawController.h"


@interface AgentController ()
@property (weak, nonatomic) IBOutlet UILabel *sumMony;
@property (weak, nonatomic) IBOutlet UILabel *withdrawedMoney;
@property (weak, nonatomic) IBOutlet UILabel *canWithdrawMoney;
@property (nonatomic,strong) ECAgentCustomObject *agent;

@end

@implementation AgentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackgroundTapAction];
    
    self.view.backgroundColor = [UIColor gray5];
    
    [self initData];
}

- (void)initData
{
    
    NSDictionary *dic = @{m_id:self.currentMember.id,
                          m_member_user_shell:self.currentMember.memberShell};
    
   [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [[SPNetworkManager sharedClient] agentCustomWithParams:dic completion:^(BOOL succeeded, id responseObject ,NSError *error){
        
        if (succeeded) {
            _agent = responseObject;
            if(_agent){
            
                _sumMony.text = [NSString stringWithFormat:@"¥ %0.2f" ,[_agent.spread_state_all floatValue]];
                _withdrawedMoney.text = [NSString stringWithFormat:@"¥ %0.2f" ,[_agent.spread_state_1 floatValue]];
                _canWithdrawMoney.text = [NSString stringWithFormat:@"¥ %0.2f" ,[_agent.spread_state_0 floatValue]];
            }
            [SVProgressHUD dismiss];
        }
    }];
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self addBackButton];
    
}
- (IBAction)withdrawAction:(id)sender {
    
    AgentWithdrawController *controller = [[AgentWithdrawController alloc] init];
    controller.title = @"申请提现";
    controller.money = _agent.spread_state_0;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)listAction:(id)sender {
    
    NSMutableArray *array = _agent.member_spreader;
    if(array){
        AgentCustomController *controller = [[AgentCustomController alloc] init];
        controller.datasArray = array;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"当前无用户"];
        
    }
    
}


@end
