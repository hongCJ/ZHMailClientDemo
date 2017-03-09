//
//  NSString+Server.h
//  CoreMainDemo
//
//  Created by 郑红 on 21/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Server)

- (NSString*)serverFromEmail;

+ (NSString*)mailServerPath;

+ (NSString*)mailAccountPath;

- (BOOL)CH_Email;

+ (NSString*)cachePathForAccount:(NSString*)account folder:(NSString*)folder;

+ (NSString*)fileCache:(NSString*)fileName;

- (NSArray *)filterImageSrc;

@end
