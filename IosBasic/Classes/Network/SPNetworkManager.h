//
//  SPNetworkManager.h
//  IosBasic
//
//  Created by Nathan Ou on 15/2/28.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "NetworkConstants.h"
#import "SVProgressHUD.h"

#define kAllKeys @"kAllKeys"

typedef NS_ENUM(NSInteger, SPValidateCodeType)
{
    SPValidateCodeType_Reg = 0, // 注册
    SPValidateCodeType_Forgot = 1, // 忘记密码
    SPValidateCodeType_None = 3, // 这个类型会不检查用户是否存在
    SPValidateCodeType_WithDraw = 4, // 提现的时候
};

typedef NS_ENUM(NSInteger, SPCenterType)
{
    SPCenterType_PersonalInfo = 0, // 个人信息
    SPCenterType_Order = 1, // 我的订单
    SPCenterType_Address = 2, // 收货地址管理
};

typedef void (^SPBoolResultBlock)(BOOL succeeded, NSError *error);

typedef void (^SPCommonResultBlock)(BOOL succeeded, id responseObject ,NSError *error);
typedef void (^SPCommunityResultBlock)(BOOL succeeded, NSArray *list, NSInteger tieNumber, NSInteger userNumber, NSError *error);

typedef void (^SPUserDataResultBlock)(BOOL succeeded, id responseObject , NSInteger maxNumber,NSError *error);

@interface SPNetworkManager : AFHTTPSessionManager

+ (instancetype)sharedClient;

#pragma mark-----ECShop


// 登陆
- (void)loginWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 是否接收通知
- (void)postChangeNotificationWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 开始结束任务----OK
- (void)postStartWorkWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 结束任务-----
- (void)postEndWorkWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 上传坐标-----
- (void)postUpdateLocationWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 获取聊天-----
- (void)getChatListWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// 避免多客户端登录
- (void)postcheckLoginWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// 发送聊天-----
- (void)postSendMessageListWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 获取聊天短语-----
- (void)getMessageListWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
//发送手机 token ，用于推送
- (void)postTokenWithParams:(NSDictionary *)params completion:(SPCommonResultBlock)block;
// 版本号
- (void)getAppVersion:(NSDictionary *)params completion:(SPCommonResultBlock)block;


//首页ban
- (void)getMainBanImagesWithCompletion:(SPCommonResultBlock)block;

// 首页 爆款--新品
- (void)getMainHotAndNewGoodsWithParames:(NSDictionary *)parames Completion:(SPCommonResultBlock)block;
// 首页---各类别
- (void)getMainOthersGoodsWithCompletion:(SPCommonResultBlock)block;

- (void)getMainMiddelImageWithCompletion:(SPCommonResultBlock)block;

// 分类
- (void)getClassifyOfGoodsWithCompletion:(SPCommonResultBlock)block;

// 根据 分类  关键字  类别获取产品
- (void)goodsWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 获取品牌分类
- (void)brandWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 获取热门搜索的关键词
- (void)getHotSearchWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 根据id获取产品详情
- (void)getGoodsDetailWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 根据id获取评论的详情
- (void)getGoodsCommentWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// 获取用户的地址
- (void)getUserAddressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 编辑地址
- (void)editUserAddressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 删除地址
- (void)delegateUserAddressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 添加新地址
- (void)addNewAdressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 设置默认地址
- (void)setDefaultAddressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 上传照片----活动照片
- (void)uploadDataWithimage:(UIImage *)image name:(NSString *)fileName completion:(SPCommonResultBlock)block;

// 上传身份证信息到订单详情
- (void)postIDInfoToOrderWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// 切换地址返回邮费及hash值
- (void)changeAddressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)usedVoucherWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 注册
- (void)signUpWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block ;

// 发送短信
- (void)sendMsgWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 找回密码
- (void)findPasswordWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// 获取收藏列表
- (void)getUserCollectWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
//添加收藏
- (void)addToUserCollectWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 删除收藏
- (void)deletaUserCollectWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// 添加购物车
- (void)addToShopCartWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 获取购物车列表
- (void)getUsersShopCartWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 改变购物车数量
- (void)changeCartsNumWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 删除购物车商品
- (void)deleteCartsGoodsWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// 结算
- (void)balanceWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 提交订单
- (void)submitOrderWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 获取订单列表
- (void)getUserOrderWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 取消订单和确认收货  和 删除
- (void)cancleAndConfirmOrderWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 检测订单是否支付成功
- (void)checkPaySuccessWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 获取订单详情
- (void)getOrdersDetaileWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 获取订单个数
- (void)getOrdersNumberWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// 改变用户信息 头像 昵称 性别 修改密码 邮箱
- (void)changUserInfoWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 上传照片
- (void)uploadDataWith:(NSString *)idNumber memberShell:(NSString *)shell name:(NSString *)fileName image:(UIImage *)image  avatar:(BOOL)isAvatar completion:(SPCommonResultBlock)block;
// 获取订单消息-----
- (void)blanceMessageWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 获取仓库-----
- (void)getWarehouseWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 获取快递公司-----
- (void)getExpressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 删除订单消息
- (void)deleteOrdersMessageWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// 推广商
- (void)agentCustomWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
- (void)applyAgentWithParams:(NSDictionary *)params image:(UIImage *)image image2:(UIImage *)image2 completion:(SPCommonResultBlock)block;
//   申请提现
- (void)applyWithdrawWithParams:(NSDictionary *)params completion:(SPCommonResultBlock)block;


//   提交评论
- (void)submitCommentWithParams:(NSDictionary *)params completion:(SPCommonResultBlock)block;

// 获取1级帮助
- (void)getHelpInfoFirstWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 获取2级帮助
- (void)getHelpInfoSecondWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
// 获取帮助详情
- (void)getHelpDetailWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// 银联1 获取tn
- (void)payGoodsByYinLianWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;
#pragma mark-----ECShop




//  自动登陆
- (void)autoLoginWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// Safety code
- (void)safetyCodeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// Update Safety code
- (void)updateSafetyCodeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// About us
- (void)aboutCodeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

// FAQ
- (void)faqCodeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;


- (void)investmentProductsWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)buyProductsWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)myProductsWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)rechargeWithdrawWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)rollInWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)rollOutWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)investIncomeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)bindEmailWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)bindPhoneWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)paymentWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)recordWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

//重置密码
- (void)resetPasswordWithParams:(NSDictionary *)params completion:(SPCommonResultBlock)block;

- (void)messageWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)homeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)accountIncomeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;

- (void)doLimitWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block;



// 发送错误日志
- (void)postErrorWithString:(NSString *)errorString completion:(void(^)())block;


@end
