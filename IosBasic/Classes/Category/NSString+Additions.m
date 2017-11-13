//
//  NSString+Additions.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/11.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

+ (instancetype)jsonStringFromDictionary:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error)
    {
        NSLog(@"Error: %@", error);
    }
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

- (id)jsonStringToArrayOrDictionary
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSASCIIStringEncoding]
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

@end
