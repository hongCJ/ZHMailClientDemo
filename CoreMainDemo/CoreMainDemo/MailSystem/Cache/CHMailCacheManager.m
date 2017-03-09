//
//  CHMailCacheManager.m
//  CoreMainDemo
//
//  Created by 郑红 on 02/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailCacheManager.h"
#import "NSString+Server.h"
#import "CHMailModel.h"

@interface CHMailCacheManager ()
{
    
}



@end

@implementation CHMailCacheManager

+ (void)P_removeFile:(NSString*)filePath {
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        [manager removeItemAtPath:filePath error:nil];
    }
}

+ (void)cacheFile:(NSData *)data {
    
}

+ (NSData*)fileDataBy:(NSString *)fileName {
    NSString * filePath = [NSString fileCache:fileName];
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [NSData dataWithContentsOfFile:filePath];
    } else {
        return nil;
    }
}

+ (void)clearAllFileCache {
    NSString * filePath = [NSString fileCache:nil];
    [self P_removeFile:filePath];
}

+ (void)removeFileBy:(NSString *)fileName {
    NSString * filePath = [NSString fileCache:fileName];
    [self P_removeFile:filePath];
}


+ (void)clearAllMailCache {
    NSString * filePath = [NSString cachePathForAccount:nil folder:nil];
    [self P_removeFile:filePath];
    
}

+ (void)clearMailCacheBy:(NSString *)account folder:(NSString *)folder {
    NSString * filePath = [NSString cachePathForAccount:account folder:folder];
    [self P_removeFile:filePath];
}

+ (void)cacheMail:(CHMailModel *)model {
    for (CHMailFolderModel * folder in model.mailFolder) {
        NSString * filePath = [NSString cachePathForAccount:folder.accountEmail folder:folder.path];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        [NSKeyedArchiver archiveRootObject:folder toFile:filePath];
    }
}



+ (CHMailFolderModel*)getCacheFolder:(CHMailFolderModel *)folder {
    if (folder == nil) {
        return folder;
    }
    NSString * filePath = [NSString cachePathForAccount:folder.accountEmail folder:folder.path];
    CHMailFolderModel * cacheFolder = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (cacheFolder) {
        return cacheFolder;
    } else {
        return folder;
    }
}


+ (NSArray*)getAllFolderIn:(CHMailAccountModel *)account {
    NSMutableArray * mutArray = [[NSMutableArray alloc] init];
    NSString * directorPath = [NSString cachePathForAccount:account.email folder:nil];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:directorPath]) {
        return mutArray.copy;
    }
    NSArray * files = [fileManager contentsOfDirectoryAtPath:directorPath error:nil];
    if (files.count > 0) {
        for (NSString * path in files) {
            if ([path hasSuffix:@"archiver"]) {
                NSString * archiverPath = [directorPath stringByAppendingPathComponent:path];
                CHMailFolderModel * cacheFolder = [NSKeyedUnarchiver unarchiveObjectWithFile:archiverPath];
                if (cacheFolder != nil) {
                    [mutArray addObject:cacheFolder];
                }
            }
            
        }
    }
    return mutArray.copy;
}

@end
