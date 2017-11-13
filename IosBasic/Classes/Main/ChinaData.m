//
//  ChinaData.m
//  IosBasic
//
//  Created by li jun on 16/12/7.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "ChinaData.h"

@interface ChinaData()
//@property (nonatomic,strong)FMDatabase *dataBase;
@property(nonatomic,strong)FMDatabaseQueue *fmdbQueue;
@property (nonatomic,copy)NSString *dbPath;

@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation ChinaData

- (id)initWith:(NSArray *)array{
    if (self = [super init]) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [path stringByAppendingPathComponent:@"data.sqlite"];
        self.dbPath = fileName;
        _dataArray = array;
        self.fmdbQueue = [[FMDatabaseQueue alloc]initWithPath:self.dbPath];
//        self.dataBase = [[FMDatabase alloc] initWithPath:self.dbPath];
        [self deleData];
        [self creatCityTabel];
        [self saveProvince];
    }
    return self;
}

/**
 *  创建城市表单
 */
- (void)creatCityTabel{
    
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        [db executeUpdate:@"CREATE TABLE IF  NOT EXISTS Province (rowid INTEGER PRIMARY KEY AUTOINCREMENT,IDNUMBER text,NAME text)"];
        [db executeUpdate:@"CREATE TABLE IF  NOT EXISTS City (rowid INTEGER PRIMARY KEY AUTOINCREMENT, IDNUMBER text,NAME text,PARENTID text)"];
        [db executeUpdate:@"CREATE TABLE IF  NOT EXISTS Area (rowid INTEGER PRIMARY KEY AUTOINCREMENT, IDNUMBER text,NAME text,PARENTID text)"];
        [db close];
    }];
    
}
- (void)deleData{
    
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        [db executeUpdate:@"DROP TABLE IF EXISTS Province;"];
        [db executeUpdate:@"DROP TABLE IF EXISTS City;"];
        [db executeUpdate:@"DROP TABLE IF EXISTS Area;"];
        [db close];
    }];
    
    /*
    // 省份
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.fmdbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:@"delete from Province where status like ?",@"1"];
        }];
    });
    
    // 城市
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.fmdbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:@"delete from City  where status like ?",@"1"];
        }];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.fmdbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:@"delete from Area  where status like ?",@"1"];
        }];
    });
    */
}
// 存储数据
- (void)saveProvince{
    // 新增一项删除已经存在的数据
    
    NSLog(@"开始了");

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.fmdbQueue inDatabase:^(FMDatabase *db) {
            [db open];
            for (NSDictionary *dic in self.dataArray) {
                ECProvinceModel *obj = [[ECProvinceModel alloc]init];
                obj.idNumber = dic[@"area_id"];
                obj.name = dic[@"area_name"];
                [db executeUpdate:@"INSERT INTO Province (name,idNumber) VALUES (?,?)",obj.name,obj.idNumber];
            }
             NSLog(@"完成了1111111");
            [db close];
        }];
    });
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.fmdbQueue inDatabase:^(FMDatabase *db) {
            [db open];
            for (NSDictionary *dic in self.dataArray) {
                if ([dic[@"area_son"] isKindOfClass:[NSArray class]]) {
                    NSArray *array2 = dic[@"area_son"];
                    for (NSDictionary *dic2 in array2) {
                        ECCityModel *obj2 = [[ECCityModel alloc]init];
                        obj2.idNumber = dic2[@"area_id"];
                        obj2.name = dic2[@"area_name"];
                        obj2.parentId = dic2[@"area_parent_id"];
                        [db executeUpdate:@"INSERT INTO City (name,idNumber,parentId) VALUES (?,?,?)",obj2.name,obj2.idNumber,obj2.parentId];
                    }
                }
            }
            NSLog(@"完成了222222");
            [db close];
        }];
     });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.fmdbQueue inDatabase:^(FMDatabase *db) {
            [db open];
            for (NSDictionary *dic in self.dataArray) {
                if ([dic[@"area_son"] isKindOfClass:[NSArray class]]) {
                    NSArray *array2 = dic[@"area_son"];
                    for (NSDictionary *dic2 in array2) {
                        if ([dic2[@"area_son"] isKindOfClass:[NSArray class]]) {
                            NSArray *array3 = dic2[@"area_son"];
                            for (NSDictionary *dic3 in array3) {
                                ECAreaModel *obj3 = [[ECAreaModel alloc]init];
                                obj3.idNumber = dic3[@"area_id"];
                                obj3.name = dic3[@"area_name"];
                                obj3.parentId = dic3[@"area_parent_id"];
                                [db executeUpdate:@"INSERT INTO Area (name,idNumber,parentId) VALUES (?,?,?)",obj3.name,obj3.idNumber,obj3.parentId];
                            }
                        }
                    }
                }
            }
            NSLog(@"完成了33333333");
            [db close];
        }];
     });
   
    
    
   /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.fmdbQueue inDatabase:^(FMDatabase *db) {
            [db open];
            for (NSDictionary *dic in self.dataArray) {
                ECProvinceModel *obj = [[ECProvinceModel alloc]init];
                obj.idNumber = dic[@"area_id"];
                obj.name = dic[@"area_name"];
                [db executeUpdate:@"INSERT INTO Province (name,idNumber) VALUES (?,?)",obj.name,obj.idNumber];
                if ([dic[@"area_son"] isKindOfClass:[NSArray class]]) {
                    NSArray *array2 = dic[@"area_son"];
                    for (NSDictionary *dic2 in array2) {
                        ECCityModel *obj2 = [[ECCityModel alloc]init];
                        obj2.idNumber = dic2[@"area_id"];
                        obj2.name = dic2[@"area_name"];
                        obj2.parentId = dic2[@"area_parent_id"];
                        [db executeUpdate:@"INSERT INTO City (name,idNumber,parentId) VALUES (?,?,?)",obj2.name,obj2.idNumber,obj2.parentId];
                        if ([dic2[@"area_son"] isKindOfClass:[NSArray class]]) {
                            NSArray *array3 = dic2[@"area_son"];
                            for (NSDictionary *dic3 in array3) {
                                ECAreaModel *obj3 = [[ECAreaModel alloc]init];
                                obj3.idNumber = dic3[@"area_id"];
                                obj3.name = dic3[@"area_name"];
                                obj3.parentId = dic3[@"area_parent_id"];
                                [db executeUpdate:@"INSERT INTO Area (name,idNumber,parentId) VALUES (?,?,?)",obj3.name,obj3.idNumber,obj3.parentId];
                            }
                        }
                    }
                }
            }
            [db open];
            NSLog(@"完成了");
      }];
    });
    */
}

@end
