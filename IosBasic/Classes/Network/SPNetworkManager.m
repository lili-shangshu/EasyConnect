//
//  SPNetworkManager.m
//  IosBasic
//
//  Created by Nathan Ou on 15/2/28.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "SPNetworkManager.h"
#import "AppDelegate.h"
#import "SPMember.h"
#import "NADefaults.h"
#import <YYModel/YYModel.h>
#import "ChinaData.h"

static NSString *const KECMainBanURL = @"app/index_banner";  //首页ban
static NSString *const KECGetCityURL = @"app/area_list";  // 地区信息
static NSString *const KECMainHotAndNewURL = @"app/index_prodlist";   // 首页 爆款和新品
static NSString *const KECMainOtherURL = @"app/catalog";   // 首页---各类别
static NSString *const KECMainImageURL = @"index.php?act=app_interf&op=middle_img";   // 首页---各类别
static NSString *const KECClassifyOfGoodsURL = @"app/catalog"; // 分类
static NSString *const KECGetAgentCustomURL = @"index.php?act=app_interf&op=spreader"; //  推广商
static NSString *const KECPostAgentCustomURL = @"index.php?act=app_interf&op=spread_apply"; //  申请推广商
static NSString *const KECGetAgentWithdrawURL = @"index.php?act=app_interf&op=spreader_cash"; //  申请提现
static NSString *const KECSubmitCommentURL = @"index.php?act=app_interf&op=add_evaluation"; //  提交评论


static NSString *const KECGetBrandURL = @"app/brands"; // 品牌专区
static NSString *const KECGetGoodsURL = @"app/prodlist";
static NSString *const KECGetHotSearchURL = @"index.php?act=app_interf&op=hot_search";
static NSString *const KECGetGoodsDetailURL = @"app/product";
static NSString *const KECGetGoodsCommentURL = @"index.php?act=app_interf&op=comments_list";
static NSString *const kECLoginURL = @"app/login"; //用户登录接口
static NSString *const kECFindPWDURL = @"app/forgetpsw"; //用户登录接口
static NSString *const kECGetAddressURL = @"app/address_list";
static NSString *const kECEditNewAdressURL = @"index.php?act=app_interf&op=address_edit";
static NSString *const kECDelateNewAdressURL = @"app/address_delete";
static NSString *const kECAddNewAdressURL = @"app/address";
static NSString *const kECAddIDURL = @"app/checkaddinfo";
static NSString *const kECSetAdressURL = @"index.php?act=app_interf&op=address_default";

static NSString *const kSPscthumbImage = @"app/idphoto"; // 上传图片

static NSString *const kECChangeAdressURL = @"index.php?act=app_interf&op=change_address";

static NSString *const kECUseVoucherURL = @"index.php?act=app_interf&op=voucher";

static NSString *const kSPSignUpURL = @"app/register"; //注册接口
static NSString *const KECGetCollectGoodsURL = @"app/fav_list";
static NSString *const KECAddCollectGoodsURL = @"app/fav";
static NSString *const KECDeletaCollectGoodsURL = @"app/fav";
static NSString *const KECAddShopCartGoodsURL = @"app/cart_add";
static NSString *const KECGetShopCartGoodsURL = @"app/cart";
static NSString *const KECChangeCartGoodsURL = @"app/cart_edit";
static NSString *const KECdeleteCartGoodsURL = @"app/cart_delete";

static NSString *const KECBalanceURL = @"index.php?act=app_interf&op=buy_step1";
static NSString *const KECSubmitURL = @"app/checkout";
static NSString *const KECGetOrderURL = @"app/my_order";
static NSString *const KECCancleOrderURL = @"app/order";
static NSString *const KECCheckPayURL = @"app/pay";
static NSString *const KECGetOrderDetailURL = @"app/order_detail";
static NSString *const KECGetOrderNumURL = @"index.php?act=app_interf&op=order_count";
static NSString *const KECChangeUserDetailURL = @"app/profile";
static NSString *const KECPayByYinlianURL = @"index.php?act=app_interf&op=pay";

static NSString *const KECGetHelpFirstURL = @"index.php?act=app_interf&op=article_class";
static NSString *const KECGetHelpSecondURL = @"index.php?act=app_interf&op=article_list";
static NSString *const KECGetHelpThridURL = @"index.php?act=app_interf&op=article_show";


static NSString *const KECGetOrderMessageURL = @"app/balance";
static NSString *const KECGetwareURL = @"app/warehouse_list";
static NSString *const KECGetexpressURL = @"app/express_list";
static NSString *const KECDeleteOrderMessageURL = @"index.php?act=app_interf&op=system_msg_del";
static NSString *const kSPVersionURL = @"app/version"; // 版本号
static NSString *const kSPSendMsg = @"app/get_captcha"; //短信发送



static NSString *const kSPSafetyCodeURL = @"api/safety_code";
static NSString *const kSPUpdateSafetyCodeURL = @"api/update_safety_code";
static NSString *const kSPAboutURL = @"api/about"; //about us
static NSString *const kSPFAQCodeURL = @"api/faqs"; // faq
static NSString *const kSPInvestProURL = @"api/investment_products"; // investment products
static NSString *const kSPBuyProURL = @"api/buy_product";
static NSString *const kSPMyProURL = @"api/my_product";
static NSString *const kSPRechargeURL = @"api/recharge";
static NSString *const kSPRollInURL = @"api/roll_in";
static NSString *const kSPRollOutURL = @"api/roll_out";
static NSString *const kSPInvestIncomeURL = @"api/invest_income";
static NSString *const kSPBindEmailURL = @"api/bind_emai";
static NSString *const kSPBindPhoneURL = @"api/bind_phone";
static NSString *const kSPPaymentURL = @"api/payment";
static NSString *const kSPRecordURL = @"api/record";
static NSString *const kSPChangePassword = @"api/changepwd";  // 修改密码
static NSString *const kSPMessageURL = @"api/message";
static NSString *const kSPHomeURL = @"api/home";
static NSString *const kSPAccountIncomeURL = @"api/account_income";
static NSString *const kSPDoLimit = @"api/do_limit";
static NSString *const kSPSendToken   = @"api/token" ; //发送 手机 token ，用于推送

static NSString *const kSPResetPassworad = @"api/forgotpwd"; //忘记密码，重置密码接口
static NSString *const kSPMsgResetPassworad = @"api/forgotpwd"; //短信找回和重置密码接口
static NSString *const kSPAccountModify = @"apicourier/profile"; //帐户资料修改
static NSString *const kSPUploadImage = @"apicourier/avatar"; // 上传图片
static NSString *const kSPOrderStatusUpdate = @"apicourier/orders_update"; // 更新订单状态
static NSString *const kSPComment = @"apicourier/comment"; // 获取评论
static NSString *const kSPOrders  = @"apicourier/orders"; // 获取订单列表

static NSString *const kSPErrorReport = @"app/error"; // 系统错误信息

@implementation SPNetworkManager

+ (instancetype)sharedClient
{
    static SPNetworkManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:50*1024*1024 diskCapacity:100*1024*1024 diskPath:nil];
        [config setURLCache:cache];
        
        NSString *severString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SeverString"];
        NSString *severString2 =  [severString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _sharedClient = [[SPNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:severString2] sessionConfiguration:config];
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedClient.requestSerializer.timeoutInterval = 10.f;
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",nil];
        
    });
    return _sharedClient;
}

- (void)getMainBanImagesWithCompletion:(SPCommonResultBlock)block{
    [self GET:KECMainBanURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    ECMainBansObject *obj = [ECMainBansObject yy_modelWithJSON:dic];
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}
- (void)getCityWithCompletion:(SPCommonResultBlock)block{
    [self GET:KECGetCityURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is");
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            // 在这里使用 FMBD讲地址信息存储在本地
             if (data && [data isKindOfClass:[NSArray class]]) {
                 ChinaData *china = [[ChinaData alloc]initWith:data];
                  block(YES,china,nil);
             }else
             {
                 block(NO, nil, nil);
             }
            /*
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    ECCityObject *obj = [[ECCityObject alloc]init];
                    obj.idNumber = dic[@"area_id"];
                    obj.name = dic[@"area_name"];
                    NSMutableArray *muarray2 = [NSMutableArray array];
                    if ([dic[@"area_son"] isKindOfClass:[NSArray class]]) {
                        NSArray *array2 = dic[@"area_son"];
                        for (NSDictionary *dic2 in array2) {
                            ECCityObject *obj2 = [[ECCityObject alloc]init];
                            obj2.idNumber = dic2[@"area_id"];
                            obj2.name = dic2[@"area_name"];
                             NSMutableArray *muarray3 = [NSMutableArray array];
                            if ([dic2[@"area_son"] isKindOfClass:[NSArray class]]) {
                               NSArray *array3 = dic2[@"area_son"];
                                for (NSDictionary *dic3 in array3) {
                                    ECCityObject *obj3 = [[ECCityObject alloc]init];
                                    obj3.idNumber = dic3[@"area_id"];
                                    obj3.name = dic3[@"area_name"];
                                    obj3.cityid = dic3[@"area_parent_id"];
                                    [muarray3 addObject:obj3];
                                }
                                if (muarray3.count>0) {
                                    obj2.sonArray = muarray3;
                                }
                                
                            }
                            [muarray2 addObject:obj2];
                        }
                        
                    }
                    if (muarray2.count >0) {
                        obj.sonArray = muarray2;
                    }
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else
            {
                block(NO, nil, nil);
            }
            */
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}
- (void)getMainHotAndNewGoodsWithParames:(NSDictionary *)parames Completion:(SPCommonResultBlock)block{
    NSLog(@"%@",parames);
    [self POST:KECMainHotAndNewURL parameters:parames success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSArray *array2 in data) {
                    ECHotAndNewGoodsObject *obj = [[ECHotAndNewGoodsObject alloc]init];
                     NSMutableArray *array3 = [[NSMutableArray alloc] init];
                    for (NSDictionary *dic in array2) {
                        ECGoodsObject *obj = [ECGoodsObject yy_modelWithDictionary:dic];
                        [array3 addObject:obj];
                    }
                    obj.goodsArray = array3;
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}

- (void)getMainOthersGoodsWithCompletion:(SPCommonResultBlock)block{
    [self GET:KECMainOtherURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                   // 待定的
                    ECClassifyGoodsObject *obj = [ECClassifyGoodsObject yy_modelWithJSON:dic];
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}
- (void)getMainMiddelImageWithCompletion:(SPCommonResultBlock)block{
    [self GET:KECMainImageURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSString class]]) {
                NSMutableString *mutStr = [NSMutableString stringWithString:data];
                block(YES,mutStr,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}

- (void)getClassifyOfGoodsWithCompletion:(SPCommonResultBlock)block{
    [self GET:KECClassifyOfGoodsURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    // 待定的
                    ECClassifyGoodsObject *obj = [ECClassifyGoodsObject yy_modelWithJSON:dic];
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        block(NO,task,error);
//        [self showError:error];
    }];
}

- (void)goodsWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
     NALog(@"-----> params is : %@", params);
    [self POST:KECGetGoodsURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    // 待定的
                    ECGoodsObject *obj = [ECGoodsObject yy_modelWithJSON:dic];
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}

- (void)brandWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self GET:KECGetBrandURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);

        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {

                    ECBrandObject *obj = [ECBrandObject yy_modelWithJSON:dic];
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}


- (void)getHotSearchWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self GET:KECGetHotSearchURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                block(YES,data,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}
- (void)getGoodsDetailWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECGetGoodsDetailURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                ECGoodsObject *obj = [ECGoodsObject yy_modelWithJSON:data];
                block(YES,obj,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}
- (void)getGoodsCommentWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self GET:KECGetGoodsCommentURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    // 待定的
                    ECGoodsCommentObject *obj = [ECGoodsCommentObject yy_modelWithJSON:dic];
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}

- (void)loginWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    NALog(@"-----> params is : %@", params);
    [self POST:kECLoginURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                ECMemberObject *obj = [ECMemberObject  yy_modelWithJSON:data];
                NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
                if (![dataDic checkObjectForKey:@"level"]) {
                     obj.level = @"普通会员";
                }

                block(YES,obj,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

// 推广商
- (void)agentCustomWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self GET:KECGetAgentCustomURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                ECAgentCustomObject *obj = [ECAgentCustomObject  yy_modelWithJSON:data];
                NSMutableArray *proArray = [[NSMutableArray alloc] init];
                if([data checkObjectForKey:@"member_spreader"]){
                    for(NSDictionary *dict2 in data[@"member_spreader"]){
                        
                        ECCustomObject *p = [ECCustomObject  yy_modelWithJSON:dict2];;
                        [proArray addObject:p];
                        
                    }
                }
                obj.member_spreader = proArray;
                
                block(YES,obj,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

//   申请注册 推广商
- (void)applyAgentWithParams:(NSDictionary *)params image:(UIImage *)image image2:(UIImage *)image2 completion:(SPCommonResultBlock)block
{
     NALog(@"-----> params is : %@", params);
    
    [self POST:KECPostAgentCustomURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"idfront" fileName:[NSString stringWithFormat:@"file%ld.jpg",(long)index] mimeType:@"image/jpeg"];
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image2, 0.5) name:@"idback" fileName:[NSString stringWithFormat:@"file2%ld.jpg",(long)index]mimeType:@"image/jpeg"];
        
        
    } success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            
            if (block && success) {
                block(YES,data,nil);
                
            }else if (block)
            {
                block(NO,nil,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

//   申请提现
- (void)applyWithdrawWithParams:(NSDictionary *)params completion:(SPCommonResultBlock)block
{
    NALog(@"-----> params is : %@", params);
    [self GET:KECGetAgentWithdrawURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

//   提交评论
- (void)submitCommentWithParams:(NSDictionary *)params completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self GET:KECSubmitCommentURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void)sendMsgWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    NALog(@"-----> params is : %@", params);
    [self POST:kSPSendMsg parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}


- (void)findPasswordWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:kECFindPWDURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)getUserAddressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:kECGetAddressURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    // 待定的
                    ECAddress *obj = [ECAddress yy_modelWithJSON:dic];
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}
- (void)editUserAddressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
     NALog(@"-----> params is : %@", params);
    [self POST:kECAddNewAdressURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                //                MemberObject *obj = [MemberObject  yy_modelWithJSON:data];
                 block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
//        [self showError:error];
          block(NO,nil,nil);
    }];
}
- (void)delegateUserAddressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:kECDelateNewAdressURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                //                MemberObject *obj = [MemberObject  yy_modelWithJSON:data];
                                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)addNewAdressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:kECAddNewAdressURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)postIDInfoToOrderWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:kECAddIDURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];

}
- (void)setDefaultAddressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
     NALog(@"-----> params is : %@", params);
    [self POST:kECSetAdressURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                //                MemberObject *obj = [MemberObject  yy_modelWithJSON:data];
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)uploadDataWithimage:(UIImage *)image name:(NSString *)fileName completion:(SPCommonResultBlock)block{
    [self POST:kSPscthumbImage parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"image" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if ([data isKindOfClass:[NSString class]]) {
                if (block && success) {
                    block(YES,data,nil);
                }
            }else if (block)
            {
                block(NO,nil,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        if (block) {
            block(NO,nil,error);
        }
        [self showError:error];
    }];
}
- (void)changeAddressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:kECChangeAdressURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)usedVoucherWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:kECUseVoucherURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)signUpWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
     NALog(@"-----> params is : %@", params);
    [self POST:kSPSignUpURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                RegisterObject *obj = [RegisterObject  yy_modelWithJSON:data];
                block(YES,obj,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void)getUserCollectWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECGetCollectGoodsURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    // 待定的
                    ECGoodsObject *obj = [ECGoodsObject yy_modelWithJSON:dic];
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else{
                block(NO, nil, nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}
- (void)addToUserCollectWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
     NALog(@"-----> params is : %@", params);
    [self POST:KECAddCollectGoodsURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void)deletaUserCollectWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
     NALog(@"-----> params is : %@", params);
    [self POST:KECDeletaCollectGoodsURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void)addToShopCartWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECAddShopCartGoodsURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void)getUsersShopCartWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECGetShopCartGoodsURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    // 待定的
                    ECGoodsObject *obj = [ECGoodsObject yy_modelWithJSON:dic];
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else{
                block(NO, nil, nil);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}
- (void)changeCartsNumWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECChangeCartGoodsURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)deleteCartsGoodsWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECdeleteCartGoodsURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)balanceWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECBalanceURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)submitOrderWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECSubmitURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in data) {
                    // 待定的
                    ECOrdersObject *obj = [ECOrdersObject yy_modelWithJSON:dic];
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else{
                block(YES,nil,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];

}
- (void)getUserOrderWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECGetOrderURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in data) {
                    // 待定的
                    ECOrdersObject *obj = [ECOrdersObject yy_modelWithJSON:dic];
                    // 测试
//                  obj.freight = @(20);
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else{
                block(YES,nil,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)getOrdersDetaileWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECGetOrderDetailURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                ECOrdersDetailObject *obj = [ECOrdersDetailObject yy_modelWithDictionary:data];
                NSDictionary *dic = data[@"extend_order_common"];
                obj.ordersAddress = [ECAddress yy_modelWithDictionary:dic[@"reciver_info"]];
                block(YES,obj,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)getOrdersNumberWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self GET:KECGetOrderNumURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)changUserInfoWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECChangeUserDetailURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)cancleAndConfirmOrderWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECCancleOrderURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void)checkPaySuccessWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECCheckPayURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)blanceMessageWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECGetOrderMessageURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    // 待定的
                    BalanceMessageObject *obj1 = [BalanceMessageObject yy_modelWithJSON:dic];
                    [array addObject:obj1];
                }
                block(YES,array,nil);
            }else{
                block(NO, nil, nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)getExpressWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self GET:KECGetexpressURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    ExpressObject *obj1 = [ExpressObject yy_modelWithJSON:dic];
                    [array addObject:obj1];
                }
                block(YES,array,nil);
            }else{
                block(NO, nil, nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)getWarehouseWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self POST:KECGetwareURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    // 待定的
                    WarehouseObject *obj1 = [WarehouseObject yy_modelWithJSON:dic];
                    [array addObject:obj1];
                }
                block(YES,array,nil);
            }else{
                block(NO, nil, nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void)deleteOrdersMessageWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self GET:KECDeleteOrderMessageURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
- (void)getHelpInfoFirstWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    [self GET:KECGetHelpFirstURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    ECHelpMessageObject *obj = [ECHelpMessageObject yy_modelWithDictionary:dic];
                    
                   
//                    我天测试
//                    ECHelpMessageObject *obj4 = [[ECHelpMessageObject alloc]init];
//                    obj4.title = @"注册及登陆";
//                    ECHelpMessageObject *obj1 = [[ECHelpMessageObject alloc]init];
//                    obj1.title = @"会员等级";
//                    ECHelpMessageObject *obj2 = [[ECHelpMessageObject alloc]init];
//                    obj2.title = @"会员积分";
//                    ECHelpMessageObject *obj3 = [[ECHelpMessageObject alloc]init];
//                    obj3.title = @"分享好友";
//                    obj.subArray= @[obj4,obj3,obj2,obj1];
                    
                    NSArray *array2 = dic[@"article_list"];
                    NSMutableArray *array3 = [NSMutableArray array];
                    for (NSDictionary *dic3 in array2) {
                        ECHelpMessageObject *obj1 = [ECHelpMessageObject yy_modelWithJSON:dic3];
                        [array3 addObject:obj1];
                    }
                    obj.subArray = array3;
                    
                    
                    
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}
- (void)getHelpInfoSecondWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    [self GET:KECGetHelpSecondURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in data) {
                    ECHelpMessageObject *obj = [ECHelpMessageObject yy_modelWithJSON:dic];
                    [array addObject:obj];
                }
                block(YES,array,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}
- (void)getHelpDetailWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    [self GET:KECGetHelpThridURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        // 这里的数据怎么变成数组了
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                ECHelpMessageObject *obj = [ECHelpMessageObject yy_modelWithJSON:data];
                block(YES,obj,nil);
            }else
            {
                block(NO, nil, nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        [self showError:error];
    }];
}
- (void)payGoodsByYinLianWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    NALog(@"-----> params is : %@", params);
    [self GET:KECPayByYinlianURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}
//  上传图片
- (void)uploadDataWith:(NSString *)idNumber memberShell:(NSString *)shell name:(NSString *)fileName  image:(UIImage *)image  avatar:(BOOL)isAvatar completion:(SPCommonResultBlock)block
{
    NSString *typeString = m_avatar;
    if (!isAvatar) typeString = @" ";
    NSDictionary *dict = @{mC_id : idNumber,
                           m_member_user_shell:shell,
                           @"image" : fileName,
                           m_editType : typeString,
                           };
    NSLog(@"===========%@",dict);
    [self POST:KECChangeUserDetailURL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // image 上传的参数名称
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"image" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject completion:^(BOOL success, id data){
            if ([data isKindOfClass:[NSDictionary class]]) {
                if (block && success) {
                    block(YES,data,nil);
                }
            }else if (block)
            {
                block(NO,nil,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NALog(@"-----> Failure with Error : %@", error);
        if (block) {
            block(NO,nil,error);
        }
    }];
}

//  自动登陆
- (void)autoLoginWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self POST:kECAddNewAdressURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] withToast:NO completion:^(BOOL success, id data){
            if (block && success) {
                //                MemberObject *obj = [MemberObject  yy_modelWithJSON:data];
                //                block(YES,obj,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void) safetyCodeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    
    [self POST:kSPSafetyCodeURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

// Update Safety code
- (void)updateSafetyCodeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    
    [self POST:kSPUpdateSafetyCodeURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}



// About us
- (void) aboutCodeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self GET:kSPAboutURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                AboutFAQObject *obj = [AboutFAQObject  yy_modelWithJSON:data[0]];
                block(YES,obj,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}


// FAQ
- (void) faqCodeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self GET:kSPFAQCodeURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dict in data) {
                    AboutFAQObject *obj = [AboutFAQObject  yy_modelWithJSON:dict];
                    [array addObject:obj];
                }
                
                block(YES,array,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        
        [self showError:error];
    }];
}

//
- (void) investmentProductsWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self GET:kSPInvestProURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dict in data) {
                    ProductObject *obj = [ProductObject  yy_modelWithJSON:dict];
                    [array addObject:obj];
                }
                
                block(YES,array,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void)buyProductsWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self POST:kSPBuyProURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                
                block(YES,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}


- (void)myProductsWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self POST:kSPMyProURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in data) {
                    ProductObject *obj = [ProductObject  yy_modelWithJSON:dict];
                    [array addObject:obj];
                }
                
                block(YES,array,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        block(NO,task,error);
//       [self showError:error];
    }];
}

- (void)rechargeWithdrawWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self POST:kSPRechargeURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
            
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}


- (void)rollInWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self POST:kSPRollInURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                
                block(YES,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}


- (void)rollOutWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self POST:kSPRollOutURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                
                block(YES,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void)investIncomeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self POST:kSPInvestIncomeURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                InvestmentIncomeObject *obj = [InvestmentIncomeObject  yy_modelWithJSON:data];
                block(YES,obj,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
//        由于已经显示过了不需要了
//        [self showError:error];
    }];
}

- (void)bindEmailWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self POST:kSPBindEmailURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}


- (void)bindPhoneWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self POST:kSPBindPhoneURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void)paymentWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
     NALog(@"-----> params is : %@", params);
    [self GET:KECPayByYinlianURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }
            else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void)recordWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self GET:kSPRecordURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dict in data) {
                    BillObject *obj = [BillObject  yy_modelWithJSON:dict];
                    NSData *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[obj.incomeTime intValue]];
                    //实例化一个NSDateFormatter对象
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //设定时间格式,这里可以设置成自己需要的格式
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    //用[NSDate date]可以获取系统当前时间
                    NSString *currentDateStr = [dateFormatter stringFromDate:confromTimesp];
                    NSArray *sArray = [currentDateStr componentsSeparatedByString:@" "];
                    if(sArray){
                        obj.time = sArray[1];
                        obj.date = sArray[0];
                    }

                    [array addObject:obj];
                }
                
                block(YES,array,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}


//重置密码
- (void)resetPasswordWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    
    [self POST:kSPChangePassword parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
    
}

- (void)messageWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self GET:kSPMessageURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dict in data) {
                    MessageObject *obj = [MessageObject  yy_modelWithJSON:dict];
                    NSData *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[obj.createdDate intValue]];
                    //实例化一个NSDateFormatter对象
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //设定时间格式,这里可以设置成自己需要的格式
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    //用[NSDate date]可以获取系统当前时间
                    NSString *currentDateStr = [dateFormatter stringFromDate:confromTimesp];
                    obj.time = currentDateStr;
                    
                    [array addObject:obj];
                }
                
                block(YES,array,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

- (void)homeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self POST:kSPHomeURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                HomeObject *obj = [HomeObject  yy_modelWithJSON:data];
                NSMutableArray *array = [[NSMutableArray alloc] init];
                if ([data checkObjectForKey:m_line_data]){
                    for (NSDictionary *dict in data[m_line_data]) {
                        PointObject *obj2 = [PointObject  yy_modelWithJSON:dict];
                        [array addObject:obj2];
                    }
                }
                obj.lineData = array;
                block(YES,obj,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
//        NSDictionary *erroDic =  error.userInfo;
//        if([erroDic checkObjectForKey:@"NSLocalizedDescription"]){
//            block(NO,task,erroDic[@"NSLocalizedDescription"]);
//        }
//        [self showError:error];
         block(NO,task,error);
    }];
}

- (void)accountIncomeWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block
{
    [self POST:kSPAccountIncomeURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                AccountIncomeObject *obj = [AccountIncomeObject  yy_modelWithJSON:data];
                block(YES,obj,nil);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        block(NO,task,error);
//        [self showError:error];
    }];
}

- (void)doLimitWithParams:(NSDictionary *)params  completion:(SPCommonResultBlock)block{
    [self POST:kSPDoLimit parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }else{
                block(NO,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}

//发送手机 token ，用于推送
- (void)postTokenWithParams:(NSDictionary *)params completion:(SPCommonResultBlock)block{
    [self POST:kSPSendToken parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject[0] completion:^(BOOL success, id data){
            if (block && success) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    block(YES,data,nil);
                }
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}


- (void)getAppVersion:(NSDictionary *)params completion:(SPCommonResultBlock)block
{
     NALog(@"-----> params is : %@",params);
    [self GET:kSPVersionURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject);
        [self parseDataWithResposeObject:responseObject withToast:NO completion:^(BOOL success, id data){
            if (block && success) {
                block(YES,data,nil);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [self showError:error];
    }];
}


// 发送错误日志
- (void)postErrorWithString:(NSString *)errorString completion:(void(^)())block
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:errorString forKey:@"error"];
    [dict setObject:@(0) forKey:@"type"];
    if ([SPMember currentMember]) {
        [dict setObject:[SPMember currentMember].id forKey:@"userid"];
    }
    if ([[UIDevice currentDevice].identifierForVendor UUIDString]) {
        [dict setObject:[[UIDevice currentDevice].identifierForVendor UUIDString] forKey:@"deviceid"];
    }
    [dict setObject:NAGetPhoneVesionString() forKey:@"model"];
    
//    NSDate *senddate=[NSDate date];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *dateStr=[dateformatter stringFromDate:senddate];
//   [dict setObject:dateStr forKey:@"time"];
    // 获取版本号
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [dict setObject:versionString forKey:@"version"];
    
    NSDictionary *postErrorDict = @{@"data":[NSString stringWithFormat:@"[%@]",[NSString jsonStringFromDictionary:dict]]};
    
    [self POST:kSPErrorReport parameters:postErrorDict success:^(NSURLSessionDataTask *task, id responseObject){
        NALog(@"-----> ResposeObject is : %@", responseObject[0]);
        [self parseDataWithResposeObject:responseObject[0] withToast:NO completion:^(BOOL succes, id data){
            if (succes) {
                block();
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
       [self showError:error];
    }];
}


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Misc
////////////////////////////////////////////////////////////////////////////////////

- (void)showError:(NSError *)error{
//    [SVProgressHUD dismiss];
    NALog(@"-----> Failure with Error : %@", error);
    NSDictionary *erroDic =  error.userInfo;
    if([erroDic checkObjectForKey:@"NSLocalizedDescription"]){
        [SVProgressHUD showInfoWithStatus:erroDic[@"NSLocalizedDescription"]];
    }
}

- (void)parseDataWithResposeObject:(id)resposeObject completion:(void(^)( BOOL success,id data))block
{
    [self parseDataWithResposeObject:resposeObject withToast:YES completion:block];
}
- (void)parseDataWithResposeObject:(id)resposeObject withToast:(BOOL)withToast completion:(void(^)( BOOL success,id data))block
{
    NSInteger status;
    if ([resposeObject checkObjectForKey:m_status]) status = [resposeObject[m_status] integerValue];
    
//    if ([resposeObject checkObjectForKey:m_status]) status = resposeObject[m_status];
    
    NSString *message = resposeObject[m_msg];
    if (status != 200) {
        NALog(@" -----> Fail with Message : %@", message);
        if(![message isEqualToString:@"请重新登录"]){
            if (withToast) {
                [SVProgressHUD showInfoWithStatus:message];
            }
            block(NO, resposeObject[m_data]);
        }else{
            [SVProgressHUD dismiss];
        }
    }else
        block(YES, resposeObject[m_data]);
}

- (void)parseDataWithResposeObject:(id)resposeObject withToast:(BOOL)withToast alertMessage:(BOOL)alertMessage completion:(void(^)( BOOL success,id data))block
{
    NSInteger status;
    if ([resposeObject checkObjectForKey:m_status]) status = [resposeObject[m_status] integerValue];
    NSString *message = resposeObject[m_msg];
    if (status != 200) {
        NALog(@" -----> Fail with Message : %@", message);
        if ([self shouldToastMessageWithStatus:status] && withToast) {
            [iToast showToastWithText:message position:iToastGravityBottom];
            NALog(@"------> Response Message : %@", message);
        }
        
        block(NO, resposeObject[m_data]);
    }else{
        block(YES, resposeObject[m_data]);
        if (alertMessage) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (BOOL)shouldToastMessageWithStatus:(NSInteger)status
{
    if (status == 1) return NO;
    return YES;
}



@end
