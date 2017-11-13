//
//  FGFileManager.m
//  FlyGift
//
//  Created by Nathan Ou on 14/12/16.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import "FGFileManager.h"
#import <UIImageView+AFNetworking.h>

#define kAvatarDirName @"avatar"
#define kMouldDirName @"Moulds"

#define kCacheDirName @"cache"
#define kHTMLFile @"htmlFile"

@interface FGFileManager ()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation FGFileManager

+ (instancetype)shareManager
{
    static FGFileManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FGFileManager alloc] init];
    });
    return manager;
}

- (NSFileManager *)fileManager
{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}


- (NSString *)pathForDocument
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)dirPathWithName:(NSString *)dirName
{
    NSString *dirPath = [NSString stringWithFormat:@"%@/%@", [self pathForDocument], dirName];
    BOOL isDir = NO;
    BOOL existed = [self.fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!(isDir == YES && existed == YES))
    {
        [self.fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NALog(@"--------> File Path is : %@", dirPath);
    return dirPath;
}

- (NSString *)cachDirPathWithName:(NSString *)dirName
{
    return [self dirPathWithName:[NSString stringWithFormat:@"%@/%@",kCacheDirName,dirName]];
}

- (BOOL)checkIsPathForFileExited:(NSString *)path
{
    BOOL isDir = NO;
    BOOL existed = [self.fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!(!isDir && existed)) {
        NSLog(@"----------> File Path is Not Existed or Cannot find such file for Path : %@",path);
        return NO;
    }
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Misc
////////////////////////////////////////////////////////////////////////////////////

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float )folderSizeAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (void)getCacheSizeWithComplition:(void(^)(CGFloat size, NSString *path))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *CachesPath = [paths objectAtIndex:0];
        float size = [self folderSizeAtPath:CachesPath];
        completion(size, CachesPath);
    });
}

- (void)deleteAllFileAtPath:(NSString *)path withCompletion:(void(^)())block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
        NSLog(@"files :%lu",(unsigned long)[files count]);
        for (NSString *p in files) {
            NSError *error;
            NSString *filesPath = [path stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filesPath]) {
                [[NSFileManager defaultManager] removeItemAtPath:filesPath error:&error];
            }
        }
        if (block) {
            block();
        }
    });
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Avatar Image Files
////////////////////////////////////////////////////////////////////////////////////

- (void)saveAvatarWithImage:(UIImage *)image withMemberId:(NSString *)memberId withCompletion:(void (^)(NSString *))block
{
    [self saveAvatarWithImage:image withMemberId:memberId quanlity:1 withCompletion:block];
}

- (void)saveAvatarWithImage:(UIImage *)image withMemberId:(NSString *)memberId quanlity:(CGFloat)quanlity withCompletion:(void (^)(NSString *))block
{
    NSString *filePath = [self dirPathWithName:kAvatarDirName];
    NSString *targetPath = [NSString stringWithFormat:@"%@/%@.jpg",filePath,memberId];
    if (![self checkIsPathForFileExited:targetPath]) {
    }else
    {
        NSLog(@"--------> File Is Already Exited. Over Write!!");
    }
    NSData *imageData = UIImageJPEGRepresentation(image, quanlity);
    [self.fileManager createFileAtPath:targetPath contents:imageData attributes:nil];
    
    if (block) {
        block(targetPath);
    }
}

- (void)updateAvatarForMember:(NSString *)userName withURLStr:(NSString *)urlString
{
    NAImageView *imageView = [[NAImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:urlString] completion:^(UIImage *image){
        [self saveAvatarWithImage:image withMemberId:userName withCompletion:nil];
        
    }];
}

- (UIImage *)avatarStringWithMemberId:(NSString *)userName
{
    NSString *filePath = [self dirPathWithName:kAvatarDirName];
    NSString *targetPath = [NSString stringWithFormat:@"%@/%@.jpg",filePath,userName];
    return [UIImage imageWithContentsOfFile:targetPath];
}

- (UIImage *)imageWithURL:(NSString *)url
{
    if ([self checkIsPathForFileExited:url]) {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:url];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Mould Files
////////////////////////////////////////////////////////////////////////////////////

- (void)saveMouldWithDataDicionary:(NSDictionary *)dict withCompletion:(void (^)(NSString *))block
{
    
}

- (void)deleteCacheFilesWithDirName:(NSString *)dirName
{
    NSError *error;
    NSString *filesPath = [self cachDirPathWithName:dirName];
    if (![self.fileManager removeItemAtPath:filesPath error:&error]) {
        NSLog(@"--------->  File delete ERROR : %@ for Path : %@",error, filesPath);
    }else  NSLog(@"--------->  File delete succeed! Path : %@", filesPath);
}

- (NSURL *)URLForMouldWithId:(NSString *)mouldId
{
    NSString *dirPath = [self dirPathWithName:kMouldDirName];
    NSString *mouldPath = [NSString stringWithFormat:@"%@/%@",dirPath,mouldId];
    
    if ([self checkIsPathForFileExited:mouldPath]) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",mouldPath,kDefaultMouldIndexName];
        return [NSURL URLWithString:filePath];
    }
    
    return nil;
}

- (NSString *)saveToFileForHTMLString:(NSString *)htmlString
{
//    NSString *docPath = [self pathForDocument];
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"fileArray.txt"];
    NSString *filePath = [NSString stringWithFormat:@"%@/fileArray.html",documentsDirectory];
    
    // build the HTML
    
    NSString *html = [NSString stringWithFormat:@"<html><body>%@</body><html>", htmlString];

    
    [html writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    BOOL sucess = [self.fileManager createFileAtPath:filePath contents:[htmlString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    return filePath;
}


- (void)saveEmotionsWithDict:(NSDictionary *)dictionary
{
    NSString *filePath = [self dirPathWithName:@"emotions"];
    
    NSArray *keys = [dictionary allKeys];
    
    for (NSString *key in keys) {
        NSString *targetPath = [NSString stringWithFormat:@"%@/[%@].png",filePath,key];
        if (![self checkIsPathForFileExited:targetPath]) {
        }else
        {
            NSLog(@"--------> File Is Already Exited. Over Write!!");
        }
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dictionary[key]]]];
        NSData *imageData = UIImagePNGRepresentation(image);
        [self.fileManager createFileAtPath:targetPath contents:imageData attributes:nil];
        
        NSLog(@"--------> finish %ld!!!", [keys indexOfObject:key]);
    }
    
    NSLog(@"-----------> Done !!!");
}

- (void)saveImageWithName:(NSString *)name image:(UIImage *)image
{
    NSString *filePath = [self dirPathWithName:@"emotionsImage"];
    NSString *targetPath = [NSString stringWithFormat:@"%@/%@.png",filePath,name];
    if (![self checkIsPathForFileExited:targetPath]) {
    }else
    {
        NSLog(@"--------> File Is Already Exited. Over Write!!");
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    [self.fileManager createFileAtPath:targetPath contents:imageData attributes:nil];
}

@end
