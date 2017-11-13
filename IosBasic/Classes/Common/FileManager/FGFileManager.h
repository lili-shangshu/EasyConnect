//
//  FGFileManager.h
//  FlyGift
//
//  Created by Nathan Ou on 14/12/16.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDefaultMouldIndexName @"index.htm"

@interface FGFileManager : NSObject

+ (instancetype)shareManager;

- (void)getCacheSizeWithComplition:(void(^)(CGFloat size, NSString *path))completion;
- (void)deleteAllFileAtPath:(NSString *)path withCompletion:(void(^)())block;

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Avatar & Images
////////////////////////////////////////////////////////////////////////////////////

// AvatarImage Will be saved in dir Avatar with name memberId
// And will return url Path with Save success;
- (void)saveAvatarWithImage:(UIImage *)image withMemberId:(NSString *)memberId withCompletion:(void(^)(NSString *url))block;
- (void)saveAvatarWithImage:(UIImage *)image withMemberId:(NSString *)memberId quanlity:(CGFloat)quanlity withCompletion:(void (^)(NSString *))block;
- (UIImage *)avatarStringWithMemberId:(NSString *)userName;
- (void)updateAvatarForMember:(NSString *)userName withURLStr:(NSString *)urlString;

- (UIImage *)imageWithURL:(NSString *)url;

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Mould
////////////////////////////////////////////////////////////////////////////////////

- (void)saveMouldWithDataDicionary:(NSDictionary *)dict withCompletion:(void(^)(NSString *url))block;

- (NSURL *)URLForMouldWithId:(NSString *)mouldId;

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - HTML File
////////////////////////////////////////////////////////////////////////////////////
- (NSString *)saveToFileForHTMLString:(NSString *)htmlString;

- (void)saveEmotionsWithDict:(NSDictionary *)dictionary;
- (void)saveImageWithName:(NSString *)name image:(UIImage *)image;

@end
