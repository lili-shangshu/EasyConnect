//
//  OrdersCellView.m
//  IosBasic
//
//  Created by li jun on 16/10/10.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "OrdersCellView.h"
#define k_lable_height 40.f
#define k_button_height 25.f
#define kPadding 20.f
#define k_textfont 15.f
#define padding 10.f
#define k_product_height 120.f


@interface OrdersCellView ()

//@property(strong,nonatomic) UIView * bottomlineView ;

@property(strong,nonatomic)UIView *whiteBgView;

@property(strong,nonatomic)UIView *grayBgView;
@end

@implementation OrdersCellView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
//        商品列表
        self.ordersView = [[UIView alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, padding)];
        self.ordersView.backgroundColor = [UIColor clearColor];
        self.ordersView.userInteractionEnabled = YES;
        [self addSubview:self.ordersView];
        
        
        UIView *whitBGView = [[UIView alloc]initWithFrame:CGRectMake(padding, self.ordersView.bottom, self.ordersView.width, k_lable_height)];
        whitBGView.backgroundColor = [UIColor whiteColor];
        self.whiteBgView = whitBGView;
        [self addSubview:whitBGView];
        
//       合计以及运费
        UILabel *labelH = [[UILabel alloc]initWithFrame:CGRectMake(padding, 0, 80, k_lable_height)];
        [labelH setLabelWith:@"合计：" color:[UIColor black1] font:[UIFont defaultTextFontWithSize:k_textfont-1] aliment:NSTextAlignmentLeft];
        [whitBGView addSubview:labelH];
        
        UILabel *yunfeiLable = [[UILabel alloc]initWithFrame:CGRectMake(0, labelH.top, padding, k_lable_height)];
        yunfeiLable.right = whitBGView.width-padding;
        yunfeiLable.textColor = [UIColor grayColor];
        yunfeiLable.font = [UIFont systemFontOfSize:k_textfont-2];
        yunfeiLable.textAlignment = NSTextAlignmentCenter;
        self.freightLable = yunfeiLable;
        [whitBGView addSubview:yunfeiLable];
        
        UILabel *totallable = [[UILabel alloc]initWithFrame:CGRectMake(0, labelH.top, padding, k_lable_height)];
        totallable.right = yunfeiLable.left;
        totallable.textColor = [UIColor red2];
        totallable.font = [UIFont systemFontOfSize:k_textfont+2];
        totallable.textAlignment = NSTextAlignmentRight;
        self.totalLable = totallable;
        [whitBGView addSubview:totallable];
        
        UIView *grarBg = [[UIView alloc]initWithFrame:CGRectMake(padding, whitBGView.bottom, NAScreenWidth-kPadding, k_lable_height)];
        grarBg.backgroundColor = [UIColor gray2];
        self.grayBgView = grarBg;
        [self addSubview:grarBg];
        
        // 状态
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, grarBg.width*2/5, k_lable_height)];
        [label setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:k_textfont-2] aliment:NSTextAlignmentLeft];
        self.statuLable = label;
        [grarBg addSubview:label];
        
        
        //按钮   支付 评论  确认收货  删除   退款 是位置相同
        
        float buttonWidth = (grarBg.width*3/5)/3;
        UIButton *paybutton = [[UIButton alloc]initWithFrame:CGRectMake(grarBg.width-padding-buttonWidth, 7, buttonWidth, k_button_height)];
        paybutton.right = grarBg.width-10;
        [paybutton setBackgroundColor:[UIColor whiteColor]];
        [paybutton setTitle:@"付  款" forState:UIControlStateNormal];
        paybutton.titleLabel.font = [UIFont defaultTextFontWithSize:14.f];
        [paybutton setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
        [paybutton addTarget:self action:@selector(payButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.payButton = paybutton;
        [grarBg addSubview:paybutton];
        
        UIButton *delegateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        delegateButton.frame =CGRectMake(grarBg.width-padding-buttonWidth, 7, buttonWidth, k_button_height);
        delegateButton.right = grarBg.width-10;
        [delegateButton setBackgroundColor:[UIColor whiteColor]];
        [delegateButton setTitle:@"删除订单" forState:UIControlStateNormal];
        delegateButton.titleLabel.font = [UIFont defaultTextFontWithSize:14.f];
        [delegateButton setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
        [delegateButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton = delegateButton;
        [grarBg addSubview:delegateButton];

        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame = CGRectMake(grarBg.width-padding-buttonWidth, 7, buttonWidth, k_button_height);
         commentButton.right = grarBg.width-10;
        [commentButton setBackgroundColor:[UIColor whiteColor]];
        [commentButton setTitle:@"评  论" forState:UIControlStateNormal];
        commentButton.titleLabel.font = [UIFont defaultTextFontWithSize:14.f];
        [commentButton setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
        [commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.commentButton = commentButton;
        [grarBg addSubview:commentButton];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(grarBg.width-padding-buttonWidth, 7, buttonWidth, k_button_height);
           confirmButton.right = grarBg.width-10;
        [confirmButton setBackgroundColor:[UIColor whiteColor]];
        [confirmButton setTitle:@"确认收货" forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont defaultTextFontWithSize:14.f];
        [confirmButton setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
         [grarBg addSubview:confirmButton];
        self.confirmButton = confirmButton;
        
        UIButton *refundsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        refundsButton.frame = CGRectMake(grarBg.width-padding-buttonWidth, 7, buttonWidth, k_button_height);
           refundsButton.right = grarBg.width-10;
        [refundsButton setBackgroundColor:[UIColor whiteColor]];
        [refundsButton setTitle:@"退  款" forState:UIControlStateNormal];
        refundsButton.titleLabel.font = [UIFont defaultTextFontWithSize:14.f];
        [refundsButton setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
        [refundsButton addTarget:self action:@selector(refundsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [grarBg addSubview:refundsButton];
        self.refundsButton = refundsButton;
        
        
        // 取消订单  和查看物流 一个位置
        UIButton *canclebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        canclebutton.frame = CGRectMake(0, paybutton.top, buttonWidth, k_button_height);
        canclebutton.right = paybutton.left-10;
        canclebutton.userInteractionEnabled = YES;
        [canclebutton setBackgroundColor:[UIColor whiteColor]];
        [canclebutton setTitle:@"取消订单" forState:UIControlStateNormal];
        canclebutton.titleLabel.font = [UIFont defaultTextFontWithSize:14.f];
        [canclebutton setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
        [canclebutton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.cancleButton = canclebutton;
        [grarBg addSubview:canclebutton];
        
        UIButton *logisticsbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        logisticsbutton.frame = CGRectMake(padding*2+buttonWidth, paybutton.top, buttonWidth, k_button_height);
        canclebutton.right = paybutton.left-10;
        logisticsbutton.userInteractionEnabled = YES;
        [logisticsbutton setBackgroundColor:[UIColor whiteColor]];
        [logisticsbutton setTitle:@"查看物流" forState:UIControlStateNormal];
        logisticsbutton.titleLabel.font = [UIFont defaultTextFontWithSize:14.f];
        [logisticsbutton setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
        [logisticsbutton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.logisticsButton = logisticsbutton;
//        [grarBg addSubview:logisticsbutton];
        
        
        
        
//        UIView *bottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, canclebutton.bottom+padding, self.width, padding)];
//        bottomlineView.backgroundColor = [UIColor spBackgroundColor];
//        self.bottomlineView = bottomlineView;
//        [self addSubview:bottomlineView];
        
    }
    return self;
}


#pragma mark --button
- (void)payButtonAction:(UIButton*)button{
    if (self.payButtonBlock) {
        self.payButtonBlock(self.orderCell);
        NSLog(@"=======付款＝＝＝＝＝＝");
    }
}
- (void)cancelButtonAction:(UIButton*)button{
    if (self.cancleButtonBlock) {
        self.cancleButtonBlock(self.orderCell);
        NSLog(@"=======取消＝＝＝＝＝＝");
    }
}

- (void)commentButtonAction:(UIButton*)button{
    if (self.commentButtonBlock) {
        self.commentButtonBlock(self.orderCell);
        NSLog(@"=======评论＝＝＝＝＝＝");
    }
}

- (void)confirmButtonAction:(UIButton *)button{
    if (self.confirmButtonBlock) {
        self.confirmButtonBlock(self.orderCell);
    }
}
- (void)refundsButtonAction:(UIButton *)button{
    
}
- (void)deleteButtonAction:(UIButton *)buton{
    if (self.deleteButtonBlock) {
        self.deleteButtonBlock(self.orderCell);
    }
}
-(void)removeAllButton{
    
    [self.cancleButton removeFromSuperview];
    
    [self.deleteButton removeFromSuperview];
    [self.confirmButton removeFromSuperview];
    [self.payButton removeFromSuperview];
    [self.commentButton removeFromSuperview];
    
    [self.logisticsButton removeFromSuperview];
    [self.refundsButton removeFromSuperview];
}
- (void)updateViewWithOrder:(ECOrdersObject *)orderCell  {
    self.orderCell = orderCell;
    
    [self removeAllButton];
    
    if ([orderCell.canSign intValue]==1) {
        [self.grayBgView  addSubview:self.confirmButton];
        self.confirmButton.right = self.grayBgView.width-10;
    }
    
    if ([orderCell.canCancel intValue]==1&&[orderCell.canPay intValue]==0) {
        [self.grayBgView  addSubview:self.cancleButton];
         self.cancleButton.right = self.grayBgView.width-10;
    }
    
    if ([orderCell.canDelete intValue]==1) {
        [self.grayBgView  addSubview:self.deleteButton];
         self.deleteButton.right = self.grayBgView.width-10;
    }
    
    if ([orderCell.canPay intValue]==1) {
        [self.grayBgView addSubview:self.payButton];
        [self.grayBgView  addSubview:self.cancleButton];
    }
    
    self.statuLable.text = [NSString stringWithFormat:@"状态：%@",orderCell.typeNum];
    
    if ([orderCell.typeNum isEqualToString:@"未发货"]||[orderCell.typeNum isEqualToString:@"自取"]) {
        if ([orderCell.payState isEqualToString:@"未支付"]) {
             self.statuLable.text = @"状态：未支付";
        }
    }
    self.statuLable.textColor = [UIColor spDefaultTextColor];
    
    // 先清除一下
   [self.ordersView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i<orderCell.goodsArray.count; i++) {
        ECGoodsObject  *model = orderCell.goodsArray[i];
        // 包含 图像  名称  价钱  个数  下划线  总高度为120
        UIView *containorView = [[UIView alloc]initWithFrame:CGRectMake(0, i*k_product_height, self.ordersView.width, k_product_height)];
        containorView.backgroundColor = [UIColor whiteColor];
        [self.ordersView addSubview:containorView];
        
        // 图
        NAImageView *imageView = [[NAImageView alloc]initWithFrame:CGRectMake(padding, padding, k_product_height-2*padding, k_product_height-2*padding)];
        [imageView setImageWithURL:[NSURL URLWithString:model.imageUrl]];
        [containorView addSubview:imageView];
        // 标题
        UILabel *namelable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+padding, imageView.top, self.ordersView.width-imageView.width-3*padding, imageView.height*3/4)];
        namelable.numberOfLines = 0;
        namelable.textColor = [UIColor spDefaultTextColor];
        namelable.font = [UIFont systemFontOfSize:k_textfont];
        namelable.textAlignment = NSTextAlignmentLeft;
        namelable.text = model.name;
        //换行设置
        namelable.lineBreakMode = NSLineBreakByWordWrapping;
        //注意这里UILabel的numberoflines(即最大行数限制)设置成0，即不做行数限制。
        namelable.numberOfLines = 0;
        [containorView addSubview:namelable];
        
        //售价 40
        UILabel *pricelable = [[UILabel alloc]initWithFrame:CGRectMake(namelable.left, namelable.bottom, imageView.width, imageView.height/4)];
        pricelable.bottom = imageView.bottom;
        pricelable.textColor = [UIColor spThemeColor];
        pricelable.font = [UIFont systemFontOfSize:k_textfont+2];
        pricelable.textAlignment = NSTextAlignmentLeft;
        pricelable.text = [NSString stringWithFormat:@"$:%.2f",[model.goodsPrice floatValue]];
        [containorView addSubview:pricelable];
        
        // 个数
        UILabel *numlable = [[UILabel alloc]initWithFrame:CGRectMake(pricelable.right +padding, pricelable.y,containorView.width-imageView.width-pricelable.width-4*padding, pricelable.height)];
        numlable.bottom = imageView.bottom;
        numlable.textColor = [UIColor spDefaultTextColor];
        numlable.font = [UIFont systemFontOfSize:k_textfont];
        numlable.textAlignment = NSTextAlignmentRight;
//      numlable.text = [NSString stringWithFormat:@"x %d",[model.selectNum intValue]];
        numlable.text = [NSString stringWithFormat:@"x %d",[model.selectNum2 intValue]];
        [containorView addSubview:numlable];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,containorView.height -1, containorView.width-20, 0.5)];
        lineView.backgroundColor = [UIColor spBackgroundColor];
        [containorView addSubview:lineView];
    }
    
    self.freightLable.text = [NSString stringWithFormat:@"(含运费$ %.2f)",[orderCell.freight floatValue]];
    [self.freightLable sizeToFit];
    
    if ([orderCell.freight floatValue] == 0) {
        self.freightLable.width = 0.f;
    }
    
    self.freightLable.right = self.whiteBgView.width-padding;
    self.whiteBgView.top = orderCell.goodsArray.count*k_product_height;
    
//    NSLog(@"lable.y:%.1f======",self.freightLable.y);
    self.totalLable.text = [NSString stringWithFormat:@"$ %.2f",[orderCell.total floatValue]];
    [self.totalLable sizeToFit];
    self.totalLable.right = self.freightLable.left;
//    self.totalLable.top = self.freightLable.top;
    
    self.freightLable.height = k_lable_height;
    self.totalLable.height = self.freightLable.height;
    
    self.grayBgView.top = self.whiteBgView.bottom;
    
//    self.cancleButton.top = self.totalLable.bottom;
//    self.payButton.top = self.cancleButton.top;
//    self.commentButton.top = self.payButton.top;
//    self.confirmButton.top = self.payButton.top;
//    self.deleteButton.top = self.payButton.top;
//    self.logisticsButton.top = self.payButton.top;
//    self.refundsButton.top = self.payButton.top;
    
//    self.bottomlineView.top = self.payButton.bottom+padding;
//    // 因为高度导致按钮点击都失效了
//    self.height = self.bottomlineView.bottom;
    
    // 调整下面的线的位置
    

        // 因为高度导致按钮点击都失效了
    self.height = self.grayBgView.bottom;
    
}
- (void)updateViewWithisShopCartOrder:(ECOrdersObject *)orderCell{
    self.orderCell = orderCell;
    
    [self removeAllButton];
    // 暂时隐藏payButton
    [self.grayBgView addSubview:self.payButton];
    
    self.statuLable.text = [NSString stringWithFormat:@"状态：%@",orderCell.typeNum];
    
    if ([orderCell.typeNum isEqualToString:@"未发货"]||[orderCell.typeNum isEqualToString:@"自取"]) {
        if ([orderCell.payState isEqualToString:@"未支付"]) {
            self.statuLable.text = @"状态：未支付";
        }
    }
    
    
    if ([orderCell.isPay integerValue]==1) {
        [self.payButton removeFromSuperview];
        self.statuLable.text = @"状态：已支付";
    }
    
    // 先清除一下
    [self.ordersView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i<orderCell.goodsArray.count; i++) {
        ECGoodsObject  *model = orderCell.goodsArray[i];
        // 包含 图像  名称  价钱  个数  下划线  总高度为120
        UIView *containorView = [[UIView alloc]initWithFrame:CGRectMake(0, i*k_product_height, self.ordersView.width, k_product_height)];
        containorView.backgroundColor = [UIColor whiteColor];
        [self.ordersView addSubview:containorView];
        
        // 图
        NAImageView *imageView = [[NAImageView alloc]initWithFrame:CGRectMake(padding, padding, k_product_height-2*padding, k_product_height-2*padding)];
        [imageView setImageWithURL:[NSURL URLWithString:model.imageUrl]];
        [containorView addSubview:imageView];
        // 标题
        UILabel *namelable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+padding, imageView.top, self.ordersView.width-imageView.width-3*padding, imageView.height*3/4)];
        namelable.numberOfLines = 0;
        namelable.textColor = [UIColor spDefaultTextColor];
        namelable.font = [UIFont systemFontOfSize:k_textfont];
        namelable.textAlignment = NSTextAlignmentLeft;
        namelable.text = model.name;
        //换行设置
        namelable.lineBreakMode = NSLineBreakByWordWrapping;
        //注意这里UILabel的numberoflines(即最大行数限制)设置成0，即不做行数限制。
        namelable.numberOfLines = 0;
        
        //        namelable.backgroundColor = [UIColor red2];
        [containorView addSubview:namelable];
        
        //售价 40
        UILabel *pricelable = [[UILabel alloc]initWithFrame:CGRectMake(namelable.left, namelable.bottom, imageView.width, imageView.height/4)];
        pricelable.bottom = imageView.bottom;
        pricelable.textColor = [UIColor spThemeColor];
        pricelable.font = [UIFont systemFontOfSize:k_textfont+2];
        pricelable.textAlignment = NSTextAlignmentLeft;
        pricelable.text = [NSString stringWithFormat:@"$:%.2f",[model.goodsPrice floatValue]];
        [containorView addSubview:pricelable];
        
        // 个数
        UILabel *numlable = [[UILabel alloc]initWithFrame:CGRectMake(pricelable.right +padding, pricelable.y,containorView.width-imageView.width-pricelable.width-4*padding, pricelable.height)];
        numlable.bottom = imageView.bottom;
        numlable.textColor = [UIColor spDefaultTextColor];
        numlable.font = [UIFont systemFontOfSize:k_textfont];
        numlable.textAlignment = NSTextAlignmentRight;
        numlable.text = [NSString stringWithFormat:@"x %d",[model.selectNum2 intValue]];
        [containorView addSubview:numlable];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,containorView.height -1, containorView.width-20, 0.5)];
        lineView.backgroundColor = [UIColor spBackgroundColor];
        [containorView addSubview:lineView];
        
    }
    
    self.freightLable.text = [NSString stringWithFormat:@"(含运费$ %.2f)",[orderCell.freight floatValue]];
    [self.freightLable sizeToFit];
    if ([orderCell.freight floatValue]==0) {
        self.freightLable.width = 1;
    }
    self.freightLable.right = self.whiteBgView.width-padding;
    self.whiteBgView.top = orderCell.goodsArray.count*k_product_height;
    
    //    NSLog(@"lable.y:%.1f======",self.freightLable.y);
    self.totalLable.text = [NSString stringWithFormat:@"$ %.2f",[orderCell.total floatValue]];
    [self.totalLable sizeToFit];
    self.totalLable.right = self.freightLable.left;
    //    self.totalLable.top = self.freightLable.top;
    
    self.freightLable.height = k_lable_height;
    self.totalLable.height = self.freightLable.height;
    
    self.grayBgView.top = self.whiteBgView.bottom;

    // 因为高度导致按钮点击都失效了
    self.height = self.grayBgView.bottom;
    
}
+ (CGFloat)ViewHeightWithProduct:(ECOrdersObject *)orderCell;{
    // 这里是“状态”＋合计＋付款三个的高度
    CGFloat cellheight = k_lable_height;
    cellheight+=orderCell.goodsArray.count*k_product_height;
   
    // 只有待发货的是没有按钮的
     return cellheight+k_lable_height;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
