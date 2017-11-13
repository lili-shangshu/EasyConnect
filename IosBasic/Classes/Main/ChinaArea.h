//
//  ChinaArea.h
//  IosBasic
//
//  Created by li jun on 16/12/7.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface ChinaArea : NSObject
// 公开省-市-区三个模型属性
/**
 *  省份模型
 */
@property (nonatomic,strong)ECProvinceModel *provinceModel;
/**
 *  城市模型
 */
@property (nonatomic,strong)ECCityModel *cityModel;
/**
 *  地区模型
 */
@property (nonatomic,strong)ECAreaModel *areaModel;



// 这里判断是否需要拆分这个类呢
// 分成两部分，，，，1 存储地址信息 需要使用 FMDB
// 2 处理逻辑的

/**
 *  获取所有省份模型的集合数组
 *
 *  @return 返回所有省份数据模型的集合
 */
- (NSMutableArray *)getAllProvinceData;
/**
 *  根据省份ID获取对应的省份数据模型
 *
 *  @param provinceID 省份ID
 *
 *  @return 省份数据模型
 */
- (ECProvinceModel *)getProvinceDataByID:(NSString *)provinceID;
/**
 *  根据省份ID获取该省份的所有城市数据模型的集合
 *
 *  @param parentID 省份ID
 *
 *  @return 一个省份的城市数据模型集合
 */
- (NSMutableArray *)getCityDataByParentID:(NSString *)parentID;
/**
 *  根据城市ID获取对应的城市数据模型
 *
 *  @param cityID 城市ID
 *
 *  @return 城市数据模型
 */
- (ECCityModel *)getCityDataByID:(NSString *)cityID;
/**
 *  根据城市ID获取该城市的所有区域数据模型的集合
 *
 *  @param parentID 城市ID
 *
 *  @return 一个城市的区域数据模型集合
 */
- (NSMutableArray *)getAreaDataByParentID:(NSString *)parentID;
/**
 *  根据地区ID获取对应的地区数据模型
 *
 *  @param areaID 地区ID
 *
 *  @return 地区数据模型
 */

- (ECAreaModel *)getAreaDataByID:(NSString *)areaID;

@end
