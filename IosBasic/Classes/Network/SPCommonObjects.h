//
//  SPCommenObjects.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/3.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NACommonObject
////////////////////////////////////////////////////////////////////////////////////

@interface NACommonObject : NSObject;

@property (nonatomic, strong) NSDictionary *objectDict;

+ (instancetype)parseWithDictionary:(NSDictionary *)dict;

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SPCommonObjects
////////////////////////////////////////////////////////////////////////////////////

@interface SPCommonObjects : NACommonObject

@end


#pragma mark-----ECShop

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECMainBansObject
////////////////////////////////////////////////////////////////////////////////////
@interface ECMainBansObject : NACommonObject
@property(strong,nonatomic) NSString * idNumber ;
@property(strong,nonatomic) NSString * name ;

@property(strong,nonatomic) NSString * imageUrl ; // 显示的图片

@property(strong,nonatomic) NSString * url ;
@property(strong,nonatomic) NSString * color ;

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECMainBansObject
////////////////////////////////////////////////////////////////////////////////////
@interface ECCityObject : NACommonObject

@property(strong,nonatomic) NSString * idNumber ;  // 当前级别的id
@property(strong,nonatomic) NSString * name ;
@property(strong,nonatomic) NSString * cityid ;
@property(strong,nonatomic) NSArray * sonArray ;


@end


@interface ChatMessageObject : NACommonObject

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSString *type; // 1 好友添加消息  2 系统消息

@property (nonatomic,strong) NSString *title;  // 系统短语



@property (nonatomic,strong) NSNumber *sendTime;
@property (nonatomic,strong) NSString *sendTimeStr;

@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSNumber *isSelf;
@property (nonatomic,strong) NSString *sid;
@property (nonatomic,strong) NSString *tid;

@end



@interface ECAreaModel : NACommonObject

@property(strong,nonatomic) NSString * idNumber ;  // 当前级别的id
@property(strong,nonatomic) NSString * name ;
@property(strong,nonatomic) NSString * parentId ;



@end

@interface ECCityModel : NACommonObject

@property(strong,nonatomic) NSString * idNumber ;  // 当前级别的id
@property(strong,nonatomic) NSString * name ;
@property(strong,nonatomic) NSString * parentId ;


@end

@interface ECProvinceModel : NACommonObject

@property(strong,nonatomic) NSString * idNumber ;  // 当前级别的id
@property(strong,nonatomic) NSString * name ;

@end


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECClassifyGoodsObject    产品类别名称
////////////////////////////////////////////////////////////////////////////////////
@interface ECClassifyGoodsObject : NACommonObject
// 后期将这个dic改为类别，在数据外处理。
@property(strong,nonatomic) NSString * idNumber ;
@property(strong,nonatomic) NSString * name ;
@property(strong,nonatomic) NSString * imageUrl ;   // image。   大图
@property(strong,nonatomic) NSString * imageUrl2 ; // gc-image  首页的 图片
@property(strong,nonatomic) NSString * imageUrl3 ; // gc-image  小图
@property(strong,nonatomic) NSArray * classifysArray ;

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECClassifyGoodsObject     首页--待定的类
////////////////////////////////////////////////////////////////////////////////////
@interface ECClassifyAndGoodsObject : NACommonObject

@property(strong,nonatomic) ECClassifyGoodsObject * classifyObject ;
@property(strong,nonatomic) NSArray * goodsArray ;

@end



////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECHotAndNewGoodsObject   包含类别和商品
////////////////////////////////////////////////////////////////////////////////////
@interface ECHotAndNewGoodsObject : NACommonObject
// 后期将这个dic改为类别，在数据外处理。
@property(strong,nonatomic) NSDictionary * classifyDic ;
@property(strong,nonatomic) NSArray * goodsArray ;

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECGoodsCommentObject
////////////////////////////////////////////////////////////////////////////////////
@interface ECGoodsCommentObject : NACommonObject
@property(strong,nonatomic) NSString * idNumber ;
@property(strong,nonatomic) NSString * commentAvatar ;
@property(strong,nonatomic) NSString * commentName ;
@property(strong,nonatomic) NSNumber * score ;
@property(strong,nonatomic) NSNumber * commentTime ;
@property(strong,nonatomic) NSString * content ;

@property(strong,nonatomic) NSString * time ;



@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECBrandObject
////////////////////////////////////////////////////////////////////////////////////
@interface ECBrandObject : NACommonObject
@property(strong,nonatomic) NSString * brandID ;

@property(strong,nonatomic) NSString * name ;
@property(strong,nonatomic) NSString * avatar ;
@property(strong,nonatomic) NSString * brand_class ;

@property(strong,nonatomic) NSString * brand_recommend ;
@property(strong,nonatomic) NSString * brand_sort ;


@end



////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECGoodsObject
////////////////////////////////////////////////////////////////////////////////////
@interface ECGoodsObject : NACommonObject
@property(strong,nonatomic) NSString * idNumber ;


@property(strong,nonatomic) NSNumber * marketPrice ;
@property(strong,nonatomic) NSString * name ;
@property(strong,nonatomic) NSNumber * goodsPrice ;
@property(strong,nonatomic) NSString * imageUrl ;
@property(strong,nonatomic) NSNumber * selectNum ;   // 商品的数量--购物车中
@property(strong,nonatomic) NSNumber * selectNum2 ;   // 商品的数量--购物车中
@property(strong,nonatomic) NSString * cartsId ;   // 购物车id
@property(strong,nonatomic) NSNumber * commentsNum;
@property(strong,nonatomic) NSNumber * salesNum;   // 销量
@property(strong,nonatomic) NSNumber * goodsStockNum;

// Detail
@property(strong,nonatomic) NSString * isFavorites ;  // 1 已收藏
@property(strong,nonatomic) NSArray * imagesArray;   // 滚动条的图片
@property(strong,nonatomic) NSArray * commmendGoods;
@property(strong,nonatomic) NSArray * goodsTypeOfTitles;
@property(strong,nonatomic) NSArray * goodsTypes;
@property(strong,nonatomic) NSArray * goodStockArray;
@property(strong,nonatomic) NSString * htmlDetail ;
@property(strong,nonatomic) ECGoodsCommentObject * commentObj;

@property(strong,nonatomic) NSString * wayBillId ;  // 订单消息中运单编号

@property(strong,nonatomic) NSNumber * chooseNum ; // 选择的个数---商品详情页
@property(strong,nonatomic) NSString * chooseIdNum ; // 选择对应的id--商品详情页
@property(strong,nonatomic)NSString *chooseStr;  // 选择的类型文字描述--商品详情页



@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECGoodsSTockObject
////////////////////////////////////////////////////////////////////////////////////
@interface ECGoodsSTockObject : NACommonObject
@property(strong,nonatomic) NSString * idNumber ;  // 商品ID
@property(strong,nonatomic) NSNumber * goodsPrice ;
@property(strong,nonatomic) NSString * stockId ;
@property(strong,nonatomic) NSString * storeNum ;
@property(strong,nonatomic) NSString * specValue ;

@property(strong,nonatomic) NSString * name ;

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 我的－－地址的model
////////////////////////////////////////////////////////////////////////////////////

@interface ECAddress: NACommonObject

@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *IDNumber;
@property (nonatomic,strong) NSNumber *isDefault;

@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *county;
@property (nonatomic,strong) NSString *areaInfo;  // 国内拼接
@property (nonatomic,strong) NSString *addressDetail;  // 详细地址

@property (nonatomic,strong) NSString *state; // 洲
@property (nonatomic,strong) NSString *suburb;  // 城镇
@property (nonatomic,strong) NSString *postcode;  // 邮编
@property (nonatomic,strong) NSString *areaInfo2;  // 澳洲拼接


@property (nonatomic,strong) NSString *phone_number;


@property (nonatomic,strong) NSString *isChina;  // 2 澳大利亚 1 中国
@property (nonatomic,strong) NSString *idImgA;
@property (nonatomic,strong) NSString *idImgB;



@property (nonatomic,strong) NSString *areaId;
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *vat_hash;
@property (nonatomic,strong) NSString *offpay_hash;
@property (nonatomic,strong) NSString *offpay_hash_batch;

@property(strong,nonatomic) NSString * address ; // 拼接的详细地址

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 我的－－地址的model
////////////////////////////////////////////////////////////////////////////////////

@interface ECVoucher: NACommonObject

@property (nonatomic, strong) NSString *voucher_id;    // ID
@property (nonatomic, strong) NSNumber *voucher_limit;  // 使用条件
@property (nonatomic,strong) NSString *voucher_title;   // 优惠卷的名称
@property (nonatomic,strong) NSString *voucher_start_date;  // 使用时间
@property (nonatomic,strong) NSString *voucher_end_date;
@property (nonatomic,strong) NSString *voucher_state; // 1 能用
@property (nonatomic,strong) NSNumber *voucher_price;   // 抵扣的金额



@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECAgentCustomObject
////////////////////////////////////////////////////////////////////////////////////

@interface ECAgentCustomObject : NACommonObject

@property (nonatomic, strong) NSNumber *spread_state_0;
@property (nonatomic, strong) NSNumber *spread_state_1;
@property (nonatomic, strong) NSNumber *spread_state_all;
@property (nonatomic, strong) NSArray *member_spreader;

@end


@interface ECCustomObject : NACommonObject

@property (nonatomic, strong) NSString *member_name;
@property (nonatomic, strong) NSString *member_truename;
@property (nonatomic, strong) NSString *member_id;

@end


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECMemberObject
////////////////////////////////////////////////////////////////////////////////////

@interface ECMemberObject : NACommonObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * member_user_shell;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * work_num;

@property (nonatomic, strong) NSString * token;   // 设备token值
@property (nonatomic, strong) NSNumber * isAccept; // 1 接受 2 不接受

@property (nonatomic, strong) NSString * start_time; //
@property (nonatomic, strong) NSNumber * end_time; //  这个用不到了

@property (nonatomic, strong) NSString * working_id; //

@property (nonatomic, strong) NSNumber * state; // 1 未开始 2 开始了

// 暂时不用
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * email;




@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECOrdersObject
////////////////////////////////////////////////////////////////////////////////////

@interface ECOrdersObject : NACommonObject

@property (nonatomic, strong) NSString * idNumber;      //订单id
@property (nonatomic, strong) NSString * order_type;      //1 自取 2快递 3送货
@property (strong,nonatomic)  NSString * paySn ;        // 支付的sn码，支付时使用

@property (nonatomic, strong) NSString * typeNum;       // 订单类型
@property (nonatomic, strong) NSString * payState;       // 是否支付 如果typeNum = @“未发货”，且payState = @“未支付”  是未支付的订单

@property (nonatomic, strong) NSNumber * evaluation_num; // 订单类型
@property (nonatomic, strong) NSNumber * total;         // 总额
@property (nonatomic, strong) NSNumber * goods_amount;  // 商品总额
@property (nonatomic, strong) NSArray * goodsArray;     // 订单中包含的商品
@property (nonatomic, strong) NSNumber * freight;       // 运费

@property(nonatomic,strong) NSString *orderSn;  // 订单号

// order_type = 1
@property(nonatomic,strong) NSString *city_id;  // 订单号
@property(nonatomic,strong) NSString *selectAdress;  // 订单号
@property(nonatomic,strong) NSString *city_phone;  // 订单号

// order_type = 3
@property(nonatomic,strong) NSString *name;  // 订单号
@property(nonatomic,strong) NSString *address;  // 订单号
@property(nonatomic,strong) NSString *phone;  // 订单号


@property (nonatomic, strong) NSNumber * canCancel;   // 1可取消
@property (nonatomic, strong) NSNumber * canDelete;    // 1 可删除
@property (nonatomic, strong) NSNumber * canSign;    // 1 可签收
@property (nonatomic, strong) NSNumber * canPay;    // 1 可支付

@property (nonatomic, strong) NSNumber * isPay;    // 值为1时，设置订单详情页面的cell 为 没有按钮，状态为已支付。

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECOrdersObject
////////////////////////////////////////////////////////////////////////////////////

@interface ECOrdersDetailObject : NACommonObject

@property (nonatomic, strong) NSString * idNumber;  //订单编号
@property (nonatomic, strong) NSString * orderId;  //订单id
@property (nonatomic, strong) NSNumber * typeNum;
@property (nonatomic, strong) NSNumber * total;
@property (nonatomic, strong) NSNumber * goods_amount; // 商品总价
@property (nonatomic, strong) NSNumber * evaluationNum;

// 这里的addressDetail就是全部地址 
@property(nonatomic,strong)ECAddress *ordersAddress;
@property (nonatomic, strong) NSArray * goodsArray;
@property (nonatomic, strong) NSNumber * freight;

// 新增
@property (nonatomic, strong) NSNumber * pointFee;
@property (nonatomic, strong) NSNumber * voucherFee;


@property (nonatomic, strong) NSString * time;  //订单创建时间
@property (nonatomic, strong) NSString * foundTime;
@property(strong,nonatomic) NSString * stateString ;


@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECHelpMessageObject----需要修改。
////////////////////////////////////////////////////////////////////////////////////

@interface ECHelpMessageObject : NACommonObject

@property (nonatomic, strong) NSString * idNumber;
@property (nonatomic, strong) NSString * articleIdNum;
@property(strong,nonatomic) NSString * helpTitle ;// 一级
@property(strong,nonatomic) NSString * title ;  // 二级
@property(strong,nonatomic) NSString * content ;
@property(strong,nonatomic) NSString * timeA ;

@property(strong,nonatomic) NSString * time ;

@property(strong,nonatomic) NSArray * subArray ;
@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECOrdersMessageObject----需要修改。
////////////////////////////////////////////////////////////////////////////////////

@interface ECOrdersMessageObject : NACommonObject

@property (nonatomic, strong) NSString * idNumber;
@property (nonatomic, strong) NSString * orderIdNum;
@property (nonatomic, strong) NSNumber * typeNum;
@property (nonatomic, strong) NSString * expressName;
@property (nonatomic, strong) NSNumber * expressNum;
@property(strong,nonatomic) NSString * stateString ; // 根据返回值来写  有待调整
@property (nonatomic, strong) NSArray * goodsArray;

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECOrdersMessageObject----需要修改。
////////////////////////////////////////////////////////////////////////////////////

@interface BalanceMessageObject : NACommonObject

@property (nonatomic, strong) NSString * idNumber;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSNumber * time;
@property (nonatomic, strong) NSString * cash;

@property (nonatomic, strong) NSString * timeStr;
@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ECOrdersMessageObject----需要修改。
////////////////////////////////////////////////////////////////////////////////////

@interface ExpressObject : NACommonObject

@property (nonatomic, strong) NSString * company_id;
@property (nonatomic, strong) NSString * company_name;

@end



////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MemberObjects
////////////////////////////////////////////////////////////////////////////////////

@interface MemberObject : NACommonObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * ownCode;
@property (nonatomic, strong) NSString * safetyCode;
@property (nonatomic, strong) NSString * member_user_shell;
@property (nonatomic,assign) float baseMoney;

@end



@interface RegisterObject : NACommonObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * member_user_shell;


@end

@interface AboutFAQObject : NACommonObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * intro;

@end

#pragma mark - Store

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 我的订单－－Model
////////////////////////////////////////////////////////////////////////////////////

@interface OrderTableViewCell : NACommonObject
@property(strong,nonatomic) NSString * modelId ;
@property (nonatomic,assign) int statuIndex;
@property(strong,nonatomic) NSArray * productsArray ;
@property (nonatomic,assign) float orderTotal;
@property (nonatomic,assign) float freight;
@end


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 我的订单－－商品的model
////////////////////////////////////////////////////////////////////////////////////

@interface OrderDetailModel : NACommonObject

@property(strong,nonatomic) NSString * productId ;

@property(strong,nonatomic) NSString * productName ;
@property(strong,nonatomic) NSString * productUrl ;
// 售价
@property (nonatomic,assign) float priceTotal;
// 购买数量
@property (nonatomic,assign) int number;
// 好评数
@property (nonatomic,assign) float goodcommentNumber;
// 销量
@property (nonatomic,assign) float salesNumber;
// 颜色
@property(strong,nonatomic) NSString * productcolor ;
// 尺码
@property(strong,nonatomic) NSString * productsize;

@end


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 购物车－－快递的model
////////////////////////////////////////////////////////////////////////////////////

@interface DistributionModel: NACommonObject

@property (nonatomic,strong) NSString *distributionName;
@property (nonatomic,assign) float distributionPrice;
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,strong) NSString *distributioninfo;
@property (nonatomic, strong) NSString *distributionId;

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 分类－－评论的model
////////////////////////////////////////////////////////////////////////////////////

@interface CommentModel: NACommonObject

@property (nonatomic,strong) NSString *commentId;
@property (nonatomic,assign) float commentType;
@property (nonatomic,strong) NSString *commentName;
@property (nonatomic, strong) NSString *commentTime;
@property (nonatomic, strong) NSString *commentDetaile;

@end


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MyInvestmentObjects
////////////////////////////////////////////////////////////////////////////////////

@interface ProductObject : NACommonObject

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *intro;
@property (nonatomic,assign) float interest;
@property (nonatomic,assign) int keywords;
@property (nonatomic,assign) float annualRate;
@property (nonatomic,assign) float saveMoney;

@end


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MyInvestmentObjects
////////////////////////////////////////////////////////////////////////////////////

@interface MyInvestmentObject : NACommonObject

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) float property;
@property (nonatomic,assign) float income;

@end


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - InvestmentIncomeObjects
////////////////////////////////////////////////////////////////////////////////////

@interface InvestmentIncomeObject : NACommonObject

@property (nonatomic,assign) float allInvestIncome;
@property (nonatomic,assign) float allIncome;
@property (nonatomic,assign) float yestodayAllIncome;

@end


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - BillObject
////////////////////////////////////////////////////////////////////////////////////

@interface BillObject : NACommonObject

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *incomeDesc;
@property (nonatomic,assign) float income;
@property (nonatomic,strong) NSNumber *incomeTime;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *date;

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - WarehouseObject
////////////////////////////////////////////////////////////////////////////////////

@interface WarehouseObject : NACommonObject

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MessageObject
////////////////////////////////////////////////////////////////////////////////////

@interface MessageObject : NACommonObject

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSNumber *createdDate;
@property (nonatomic,strong) NSString *intro;
@property (nonatomic,strong) NSString *time;

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - HomeObject
////////////////////////////////////////////////////////////////////////////////////

@interface HomeObject : NACommonObject

@property (nonatomic,assign) float baseMoney;
@property (nonatomic,assign) float totalIncome;
@property (nonatomic,assign) float yestodayIncome;
@property (nonatomic,assign) float changeBaseMoney;
@property (nonatomic,assign) float changeTotalIncome;
@property (nonatomic,assign) float changeYestodayIncome;
@property (nonatomic,strong) NSArray *lineData;
@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PointObject
////////////////////////////////////////////////////////////////////////////////////

@interface PointObject : NACommonObject

@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *day;

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - AccountIncomeObject
////////////////////////////////////////////////////////////////////////////////////

@interface AccountIncomeObject : NACommonObject

@property (nonatomic,assign) float accountMoney;
@property (nonatomic,assign) float accountMoneyAUD;
@property (nonatomic,assign) float accountMoneyCNY;
@property (nonatomic,assign) float allIncome;
@property (nonatomic,assign) float allProperty;

@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SPVersionObject
////////////////////////////////////////////////////////////////////////////////////

@interface SPVersionObject : NACommonObject

@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *page_url;
@property (nonatomic, strong) NSString *plist;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSNumber *mastbe;

+ (void)checkVerionWithDict:(NSDictionary *)dict;

@end


@interface SPStriptCardObject : NACommonObject

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *brand;  // 卡类型
@property (nonatomic,strong) NSString *last4;  // 后四位
//@property (nonatomic,strong) NSString *cardType;

@end



