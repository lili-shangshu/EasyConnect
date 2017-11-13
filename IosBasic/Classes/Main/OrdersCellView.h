//
//  OrdersCellView.h
//  IosBasic
//
//  Created by li jun on 16/10/10.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersCellView : UIView
@property(strong,nonatomic) UILabel * statuLable ;
@property(strong,nonatomic) UIView * ordersView ;
@property(strong,nonatomic) UILabel * totalLable ;
@property(strong,nonatomic) UILabel * freightLable ;

@property(strong,nonatomic) UIButton * payButton ;
@property(strong,nonatomic) UIButton * cancleButton ;
@property(strong,nonatomic) UIButton * commentButton ;
@property(strong,nonatomic) UIButton * confirmButton ;   // 确认收货
@property(strong,nonatomic) UIButton * deleteButton ;    // 删除订单

@property(strong,nonatomic)UIButton *logisticsButton;  // 查看物流
@property(strong,nonatomic)UIButton *refundsButton;  // 退款

@property(strong,nonatomic) ECOrdersObject * orderCell ;

@property (nonatomic, strong) void(^payButtonBlock)(ECOrdersObject *OrderCell);
@property (nonatomic, strong) void(^cancleButtonBlock)(ECOrdersObject *OrderTableViewCell);
@property (nonatomic, strong) void(^commentButtonBlock)(ECOrdersObject *OrderTableViewCell);
@property (nonatomic, strong) void(^confirmButtonBlock)(ECOrdersObject *OrderTableViewCell);
@property (nonatomic, strong) void(^deleteButtonBlock)(ECOrdersObject *OrderTableViewCell);

- (void)updateViewWithOrder:(ECOrdersObject *)orderCell;

- (void)updateViewWithisShopCartOrder:(ECOrdersObject *)orderCell;

+ (CGFloat)ViewHeightWithProduct:(ECOrdersObject *)orderCell;

@end
