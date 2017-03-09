//
//  CHMailCacheManager.h
//  CoreMainDemo
//
//  Created by 郑红 on 02/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHMailAccountModel;
@class CHMailModel;
@interface CHMailCacheManager : NSObject


+ (void)cacheMail:(CHMailModel *)model;

+ (CHMailFolderModel*)getCacheFolder:(CHMailFolderModel*)folder;

+ (NSArray*)getAllFolderIn:(CHMailAccountModel*)account;

+ (void)clearMailCacheBy:(NSString*)account folder:(NSString*)folder;

+ (void)clearAllMailCache;



+ (void)cacheFile:(NSData*)data;

+ (void)clearAllFileCache;

+ (void)removeFileBy:(NSString*)fileName;

+ (NSData*)fileDataBy:(NSString*)fileName;

@end
