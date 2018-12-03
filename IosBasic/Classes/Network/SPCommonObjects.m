//
//  SPCommenObjects.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/3.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "SPCommonObjects.h"
#import "SPNetworkManager.h"
#import "PSPDFAlertView.h"

@implementation NACommonObject

+ (instancetype)parseWithDictionary:(NSDictionary *)dict
{
    return nil;
}

@end


@implementation ECMainBansObject
+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"idNumber":@"pic_id",
              @"nmae":@"pic_name",
              @"imageUrl":@"pic_img"
              };
}
@end

@implementation ChatMessageObject

-(NSString *)sendTimeStr{
    NSDate *tiiii = [NSDate dateWithTimeIntervalSince1970:[self.sendTime doubleValue]];
    NSString *ttttt = NAStringFromDate(@"yyyy-MM-dd HH:mm", tiiii);
    return ttttt;
}

+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"type":@"status",
              @"content":@"message",
              @"sendTime":@"create_time"
              };
}

@end

@implementation ECCityObject
+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"idNumber":@"pic_id",
              @"nmae":@"pic_name",
              @"cityid":@"pic_url",
              @"areid":@"color"
              };
}

@end


@implementation ECProvinceModel

@end

@implementation ECCityModel

@end

@implementation ECAreaModel

@end


@implementation ECHotAndNewGoodsObject
+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"classifyDic":@"recommend",
              @"goodsArray":@"goods_list"
              };
}
+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"goodsArray":[ECGoodsObject class]
              };
}
@end

@implementation ECClassifyAndGoodsObject
+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"classifyObject":@"_class",
              @"goodsArray":@"data"
              };
}
+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"goodsArray":[ECGoodsObject class]
              };
}
@end

@implementation ECClassifyGoodsObject

+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"idNumber":@"id",
              @"name":@"name",
              @"imageUrl":@"bigImage",
              @"imageUrl2":@"root_name",
              @"imageUrl3":@"smallImage",
              @"classifysArray":@"childDetail"
              };
}
+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"classifysArray":[ECClassifyGoodsObject class]
              };
}

@end

@implementation ECBrandObject

@end

@implementation ECGoodsObject
+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"idNumber":@"goodsId",
              @"marketPrice":@"market_price",
              @"name":@"goodsName",
              @"imageUrl":@"avatar",
              @"commentsNum":@"evaluation_count",
              @"salesNum":@"goods_salenum",
              @"selectNum2":@"goodsNum",
              @"cartsId":@"cardsID",
              @"imagesArray":@"ImageArray",
              @"isFavorites":@"isFavority",
              @"commmendGoods":@"goods_commend",
              @"goodsTypeOfTitles":@"goodsTypeofTitleArray",
              @"goodsTypes":@"goodsTypesArray",
              @"goodStockArray":@"goodsStockArray",
              @"goodsStockNum":@"goods_storage",
//              @"htmlDetail":@"attrs",
              @"commentObj":@"goods_evaluate_info"
              };
}

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"commmendGoods":[ECGoodsObject class],
              @"goodStockArray":[ECGoodsSTockObject class]
              };
}
@end

@implementation ECGoodsSTockObject
+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"idNumber":@"goodsID",
              };
}

@end

@implementation ECAddress
+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"addressId":@"addressID",
              @"userId":@"userID",
              @"areaId":@"area_id",
              @"cityId":@"city_id",
//              @"areaInfo":@"addressinfo",
              @"addressDetail":@"addressDetail",
              @"phone_number":@"phone"
              };
}

-(NSString *)address{
    
    if ([_isChina isEqualToString:@"1"]) {
        // 国内
        return [NSString stringWithFormat:@"%@ %@",self.areaInfo,self.addressDetail];
    }else{
        return [NSString stringWithFormat:@"%@ %@",self.areaInfo2,self.addressDetail];
    }
}

-(NSString *)areaInfo{
    return [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.county];
}
-(NSString *)areaInfo2{
    return [NSString stringWithFormat:@"%@ %@",self.state,self.suburb];
}
@end
@implementation ECVoucher
+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"voucher_id":@"voucher_id",
              @"userId":@"member_id",
              @"name":@"true_name",
              @"areaId":@"area_id",
              @"cityId":@"city_id",
              @"areaInfo":@"area_info",
              @"addressDetail":@"address",
              @"phone_number":@"mob_phone",
              @"isDefault":@"is_default"
              };
}

@end


@implementation ECAgentCustomObject

@end

@implementation ECCustomObject

@end

@implementation ECGoodsCommentObject

+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"idNumber":@"geval_id",
              @"commentName":@"member_name",
              @"score":@"geval_scores",
              @"commentTime":@"geval_addtime",
              @"content":@"geval_content",
              @"commentAvatar":@"member_avatar"
              };
}
- (NSString *)time{
    NSDate *tiiii = [NSDate dateWithTimeIntervalSince1970:[self.commentTime doubleValue]];
    NSString *ttttt = NAStringFromDate(@"yyyy-MM-dd", tiiii);
    return ttttt;
}

@end

@implementation ECMemberObject
+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"userId":@"id",
              @"isAccept":@"is_notify",
              @"member_user_shell":@"member_shell",
              };
}
-(NSNumber *)state{
    if ([self.start_time intValue]!=0) {
        return @2;
    }else{
        return @1;
    }
}
@end

@implementation ECOrdersObject
+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"idNumber":@"order_id",     //订单id
              @"paySn":@"pay_sn",       // 支付的sn码，支付时使用
              @"typeNum":@"type_num",   // 订单类型参数1
              @"total":@"Total",   // 总额
              @"payState":@"pay_state",   // 总额
              @"evaluationNum":@"evaluation_state",  // 订单类型参数2
              @"selectAdress":@"selectAdress"
              };
}

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{
              @"goodsArray":[ECGoodsObject class],
              @"selectAdress":[ECAddress class]
              };
}

@end

@implementation ECOrdersDetailObject
+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"idNumber":@"order_sn",
              @"orderId":@"order_id",
              @"typeNum":@"order_state",
              @"total":@"order_amount",
              @"evaluationNum":@"evaluation_state",
              @"ordersAddress":@"reciver_info",
              @"goodsArray":@"goods_list",
              @"freight":@"shipping_fee",
              @"time":@"add_time"
              };
}
+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"ordersAddress":[ECAddress class],
             @"goodsArray":[ECGoodsObject class]
             };
}
-(NSString *)foundTime{
    NSDate *tiiii = [NSDate dateWithTimeIntervalSince1970:[self.time doubleValue]];
    NSString *ttttt = NAStringFromDate(@"yyyy-MM-dd HH:mm:ss", tiiii);
    return ttttt;
}
-(NSString *)stateString{
    NSString *string = @"";
    int state =[self.typeNum intValue];
    if (state == 10) {
        string = @"待付款";
    }else if (state == 20){
        string = @"待发货";
    }else if (state == 30){
        string = @"待收货";
    }
    else if (state == 0){
        string = @"已取消";
    }else if (state == 40 && [self.evaluationNum intValue]==0){
        string = @"待评价";
      
    }else if (state == 40 && [self.evaluationNum intValue]==1){
        string = @"已完成";
    }
    return string;
}

@end

@implementation ECHelpMessageObject

+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"idNumber":@"ac_id",
              @"articleIdNum":@"article_id",
              @"helpTitle":@"ac_name",
              @"title":@"article_title",
              @"content":@"article_content",
              @"timeA":@"article_time"
              };
}
- (NSString *)time{
    NSDate *tiiii = [NSDate dateWithTimeIntervalSince1970:[self.timeA doubleValue]];
    NSString *ttttt = NAStringFromDate(@"yyyy-MM-dd HH:mm", tiiii);
    return ttttt;
}

@end

@implementation ECOrdersMessageObject

+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"idNumber":@"message_id",
              @"orderIdNum":@"order_id",
              @"typeNum":@"order_state",
              @"expressName":@"e_name",
              @"expressNum":@"shipping_code"
              };
}
-(NSString *)stateString{
    NSString *string = @"";
    int state =[self.typeNum intValue];
    if (state == 10) {
        string = @"待付款";
    }else if (state == 20){
        string = @"待发货";
    }else if (state == 30){
        string = @"待收货";
    }else if (state == 40 ){
        string = @"已完成";
    }
    return string;
}


@end

@implementation BalanceMessageObject

-(NSString *)timeStr{

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.time intValue]];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    //        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:confromTimesp];
    //输出格式为：2010-10-27 10:22:13

    return currentDateStr;
}
@end

@implementation ExpressObject


@end

@implementation ProductObject


@end


@implementation MyInvestmentObject

@end

@implementation InvestmentIncomeObject

@end

@implementation BillObject

@end

@implementation WarehouseObject

+(NSDictionary*)modelCustomPropertyMapper{
    return @{ @"id":@"city_id",
              @"name":@"city_name",
              @"phone":@"city_phone"
              };
}

@end

@implementation MessageObject

@end

@implementation HomeObject

@end

@implementation PointObject

@end

@implementation AccountIncomeObject

@end

@implementation MemberObject

@end

@implementation RegisterObject

@end

@implementation AboutFAQObject

@end


//OrderTableViewCell
//OrderDetailModel

@implementation OrderDetailModel

@end



@implementation CommentModel

@end

@implementation DistributionModel

@end

@implementation OrderTableViewCell

@end

@implementation SPStriptCardObject
+ (instancetype)parseWithDictionary:(NSDictionary *)dict{
    SPStriptCardObject *object = [[SPStriptCardObject alloc] init];
    object.objectDict = dict;
    if([dict checkObjectForKey:@"id"]) object.id = dict[@"id"];
    if([dict checkObjectForKey:@"last4"]) object.last4 = dict[@"last4"];
    if([dict checkObjectForKey:@"brand"]) object.brand = dict[@"brand"];
    
    return object;
}


@end


@implementation SPVersionObject

+ (instancetype)parseWithDictionary:(NSDictionary *)dict
{
    SPVersionObject *object = [[SPVersionObject alloc] init];
    object.objectDict = dict;

    if ([dict checkObjectForKey:@"ios_verNo"]) object.version = dict[@"ios_verNo"];
    if ([dict checkObjectForKey:@"ios_intro"]) object.intro = dict[@"ios_intro"];
    if ([dict checkObjectForKey:@"ios_appUrl"]) object.url = dict[@"ios_appUrl"];
    
    return object;
}

+ (void)checkVerionWithDict:(NSDictionary *)dict
{
    SPVersionObject *object = [SPVersionObject parseWithDictionary:dict];
    // 获取版本号
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if (![object.version isEqualToString:versionString]) {
        PSPDFAlertView *alert = [[PSPDFAlertView alloc] initWithTitle:@"Version Update Tip" message:object.intro];
//        [alert addButtonWithTitle:@"Refuse" block:^(NSInteger buttonIndex){
//        }];
        
        [alert setCancelButtonWithTitle:@"Update" block:^(NSInteger buttonIndex){
            NSURL* url = [[ NSURL alloc ] initWithString :object.url];
            [[UIApplication sharedApplication ] openURL:url];
        }];
        [alert show];
    }
}

@end

