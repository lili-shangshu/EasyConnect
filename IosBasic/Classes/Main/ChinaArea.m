//
//  ChinaArea.m
//  IosBasic
//
//  Created by li jun on 16/12/7.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "ChinaArea.h"
@interface ChinaArea()

@property (nonatomic,strong)FMDatabase *dataBase;
@property (nonatomic,copy)NSString *dbPath;

@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation ChinaArea

+ (instancetype)sharedClient{
    static ChinaArea *china = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        china = [[ChinaArea alloc]init];
    });
    return china;
}


- (instancetype)init{
    if (self = [super init]) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [path stringByAppendingPathComponent:@"data.sqlite"];
        self.dbPath = fileName;
        self.dataBase = [[FMDatabase alloc] initWithPath:self.dbPath];
    }
    return self;
}
- (NSMutableArray *)getAllProvinceData{
    [self.dataBase open];
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM Province"];
    NSMutableArray *stuArray = [[NSMutableArray alloc] init];
    while ([result next]) {
        ECProvinceModel *model = [[ECProvinceModel alloc]init];
        model.name = [result stringForColumn:@"name"];
        model.idNumber = [result stringForColumn:@"idNumber"];
        [stuArray addObject:model];
    }
    [self.dataBase close];
    return stuArray;
}
- (ECProvinceModel *)getProvinceDataByID:(NSString *)provinceID{
     [self.dataBase open];
    ECProvinceModel *model = [[ECProvinceModel alloc]init];
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM Province WHERE IDNUMBER = ?",provinceID];
    while ([result next]) {
        model.name = [result stringForColumn:@"name"];
        model.idNumber = [result stringForColumn:@"idNumber"];
    }
    [self.dataBase close];
    return model;
}

- (NSMutableArray *)getCityDataByParentID:(NSString *)parentID{
    [self.dataBase open];
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM City WHERE PARENTID = ?",parentID];
    NSMutableArray *stuArray = [[NSMutableArray alloc] init];
    while ([result next]) {
        ECCityModel *model = [[ECCityModel alloc]init];
        model.name = [result stringForColumn:@"name"];
        model.idNumber = [result stringForColumn:@"idNumber"];
        model.parentId = [result stringForColumn:@"parentId"];
        [stuArray addObject:model];
    }
    [self.dataBase close];
    return stuArray;
}

- (ECCityModel *)getCityDataByID:(NSString *)cityID{
    [self.dataBase open];
    ECCityModel *model = [[ECCityModel alloc]init];
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM City WHERE IDNUMBER = ?",cityID];
    while ([result next]) {
        model.name = [result stringForColumn:@"name"];
        model.idNumber = [result stringForColumn:@"idNumber"];
        model.parentId = [result stringForColumn:@"parentId"];
    }
    [self.dataBase close];
    return model;
}
- (NSMutableArray *)getAreaDataByParentID:(NSString *)parentID{
    [self.dataBase open];
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM Area WHERE PARENTID = ?",parentID];
    NSMutableArray *stuArray = [[NSMutableArray alloc] init];
    while ([result next]) {
        ECAreaModel *model = [[ECAreaModel alloc]init];
        model.name = [result stringForColumn:@"name"];
        model.idNumber = [result stringForColumn:@"idNumber"];
        model.parentId = [result stringForColumn:@"parentId"];
        [stuArray addObject:model];
    }
    [self.dataBase close];
    return stuArray;
}
- (ECAreaModel *)getAreaDataByID:(NSString *)areaID{
    [self.dataBase open];
    ECAreaModel *model = [[ECAreaModel alloc]init];
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM Area WHERE IDNUMBER = ?",areaID];
    while ([result next]) {
        model.name = [result stringForColumn:@"name"];
        model.idNumber = [result stringForColumn:@"idNumber"];
        model.parentId = [result stringForColumn:@"parentId"];
    }
    [self.dataBase close];
    return model;
}




















@end
