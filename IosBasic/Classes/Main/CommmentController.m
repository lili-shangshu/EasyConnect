//
//  CommmentController.m
//  IosBasic
//
//  Created by li jun on 17/4/13.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "CommmentController.h"
#import "SPStarView.h"
#define padding 10
#define textSize 15

@interface CommmentController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iamgeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLalbe;
@property (weak, nonatomic) IBOutlet UILabel *selectNumLable;
@property (weak, nonatomic) IBOutlet UITextView *commmentTextView;
@property (weak, nonatomic) IBOutlet UILabel *pointLable;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *star1Btn;
@property (weak, nonatomic) IBOutlet UIButton *star2Btn;
@property (weak, nonatomic) IBOutlet UIButton *star3Btn;
@property (weak, nonatomic) IBOutlet UIButton *star4Btn;
@property (weak, nonatomic) IBOutlet UIButton *star5Btn;

@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) NSMutableArray *buttonStatusArray;

@property (nonatomic,strong) NSMutableArray *commentArray;
@property (nonatomic,strong) NSMutableArray *goodArray;



@end

@implementation CommmentController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _buttonArray = [[NSMutableArray alloc] init];
    [_buttonArray addObject:self.star1Btn];
    [_buttonArray addObject:self.star2Btn];
    [_buttonArray addObject:self.star3Btn];
    [_buttonArray addObject:self.star4Btn];
    [_buttonArray addObject:self.star5Btn];
    
    
    _buttonStatusArray = [[NSMutableArray alloc] init];
    
    _goodArray = [[NSMutableArray alloc]initWithArray:self.OrdersObj.goodsArray];
    
//    _goodArray = self.OrdersObj.goodsArray;
    _commentArray = [[NSMutableArray alloc] init];
    
    [self initData];
    
    [self addBackgroundTapAction];
    // Do any additional setup after loading the view from its nib.
}

- (void)backgroundTapAction:(id)sensor
{
    // 子类实现
    [self hideKeyBoard];
    
}
- (void)initData{

    self.star1Btn.selected = YES;
    self.star2Btn.selected = YES;
    self.star3Btn.selected = YES;
    self.star4Btn.selected = YES;
    self.star5Btn.selected = YES;
    
    self.commmentTextView.text = @"";
    
    
    ECGoodsObject *model  = self.OrdersObj.goodsArray[_commentArray.count];
    [self.iamgeView setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    self.titleLable.text =  model.name;
    self.selectNumLable.text = [NSString stringWithFormat:@"x %d",[model.selectNum intValue]];
    self.priceLalbe.text =[NSString stringWithFormat:@"$:%.2f",[model.goodsPrice floatValue]];

    if(_commentArray.count < _goodArray.count-1){
        [_confirmBtn setTitle:@"下个商品" forState:UIControlStateNormal];
    }else{
        [_confirmBtn setTitle:@"提交评论" forState:UIControlStateNormal];
    }

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.view.backgroundColor = [UIColor spBackgroundColor];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"评论";
   
//    
//    CGFloat left = 2*padding + _pointLable.right;
//    for(int i = 0 ; i<5;i++){
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(left, _pointLable.top+5, 20, 20)];
//        [button setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateSelected];
//        [button setBackgroundImage:[UIImage imageNamed:@"star_gray"] forState:UIControlStateNormal];
//        button.tag = i;
//        
//        button.selected = YES;
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        left = left+25;
//        [_buttonArray addObject:button];
//        [_buttonStatusArray addObject:@"selected"];
//        [self.view addSubview:button];
//    }
    
    
    
    self.titleLable.textColor = [UIColor black4];
    self.titleLable.font = [UIFont defaultTextFontWithSize:textSize];
    
    self.priceLalbe.font = [UIFont defaultTextFontWithSize:textSize-2];
    self.priceLalbe.textColor = [UIColor spThemeColor];
    
    self.selectNumLable.font = [UIFont defaultTextFontWithSize:textSize-2];
    self.selectNumLable.textColor = [UIColor spDefaultTextColor];
    
    self.commmentTextView.placeholder = @"留下您的评论";
}
- (void)buttonAction:(UIButton *)button{
    button.selected = !button.selected;
    
}
- (IBAction)starButtonClicked:(UIButton *)sender {

    sender.selected = !sender.selected;
    
    for (UIButton *button in _buttonArray) {
        if (button.tag<=sender.tag) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)confirmButtonClicked:(id)sender {
    
//    if ([self.commmentTextView.text isEmptyString]){
//        [iToast showToastWithText:@"请输入评论" position:iToastGravityCenter];
//        return;
//    }
    
    int starNum = 0;
    for(int i= 0 ; i<_buttonArray.count;i++){
        UIButton *button = _buttonArray[i];
        if(button.selected)
            starNum = starNum +1;
    }
    
    ECGoodsObject *model ;
    ECGoodsCommentObject *comment;
    
    
    if(_commentArray.count<=_goodArray.count-1){
        model  = self.OrdersObj.goodsArray[_commentArray.count];
        comment = [[ECGoodsCommentObject alloc] init];
        comment.idNumber = model.idNumber;
        comment.score = [NSNumber numberWithInt:starNum];
        comment.content = self.commmentTextView.text;
    
    }
    
    
    
    if(_commentArray.count<_goodArray.count-1){
    
        [_commentArray addObject:comment];
        [self initData];

    }else if(_commentArray.count==_goodArray.count-1){
    
        [_commentArray addObject:comment];

         [self submitComment];
    }else{
     [self submitComment];
    
    }
    
}

- (void)submitComment{

    NSString *goods_score = @"";
    NSString *comments = @"";
    
    for( int i= 0 ; i<_commentArray.count ; i++){
        ECGoodsCommentObject *c = _commentArray[i];
        if(c){
            int s =[c.score intValue];
            NSString *content = c.content;
            goods_score = [goods_score stringByAppendingFormat:@"%d,",s];
            comments = [comments stringByAppendingFormat:@"%@,",content];
        }

    }
    goods_score = [goods_score substringToIndex:[goods_score length]-1];
    comments = [comments substringToIndex:[comments length]-1];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{m_id:self.currentMember.id,
                                                                               m_member_user_shell:self.currentMember.memberShell}];
    [dic setObject:self.OrdersObj.idNumber forKey:@"order_id"];
    [dic setObject:goods_score forKey:@"goods_score"];
    [dic setObject:comments forKey:@"comment"];
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [[SPNetworkManager sharedClient] submitCommentWithParams:dic completion:^(BOOL succeeded, id responseObject ,NSError *error){
        
        if (succeeded) {
            
            [SVProgressHUD showInfoWithStatus:@"评论提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate updateOrdersList:self.OrdersObj.idNumber];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSPPay object:nil userInfo: @{@"cheng":@1}];
            
        }
    }];


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
