//
//  NSString+Server.m
//  CoreMainDemo
//
//  Created by 郑红 on 21/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "NSString+path.h"

@implementation NSString (path)


+ (NSString*)mailServerPath {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"CHMailServer" ofType:@"plist"];
    return path;
}

+ (NSString*)mailAccountPath {
    NSString * doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    doc = [doc stringByAppendingPathComponent:@"mailCache/account.archiver"];
    return doc;
}

- (BOOL)CH_Email {
    NSString *email = @"^(\\w)+(\\.\\w+)*@(\\w)+(\\.com)$";//((\\.\\w+)+)
    return [self matchUsingRegex:email];
}


- (BOOL)matchUsingRegex:(NSString*)regex {
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isRight = [regextestmobile evaluateWithObject:self];
    return isRight;
}

+ (NSString*)cachePathForAccount:(NSString *)account folder:(NSString *)folder {
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"mailCache/mail"];
    if (account) {
        path = [path stringByAppendingPathComponent:account];
        if (![[NSFileManager defaultManager] fileExistsAtPath:account]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    if (folder) {
        NSString * temp = [folder stringByAppendingString:@".archiver"];
        path = [path stringByAppendingPathComponent:temp];
    }
    
    return path;
}

+ (NSString*)fileCache:(NSString *)fileName {
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"mailCache/file"];
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path] == NO) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (fileName) {
        path = [path stringByAppendingPathComponent:fileName];
    }
 
    return path;
}


- (NSArray *)filterImageSrc
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img\\b[^<>]*?\\bsrc[\\s\\t\\r\\n]*=[\\s\\t\\r\\n]*[""']?[\\s\\t\\r\\n]*(?<imgUrl>[^\\s\\t\\r\\n""'<>]*)[^<>]*?/?[\\s\\t\\r\\n]*>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *result = [regex matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [self substringWithRange:[item rangeAtIndex:0]];
//        <img src="cid:33f30058$1$15aa6677a1b$Coremail$zyj_fy01$changhong.com" />
        imgHtml = [imgHtml stringByReplacingOccurrencesOfString:@" " withString:@""];
        imgHtml = [imgHtml stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString * imgSrc;
//        NSArray *tmpArray = nil;
        NSRange srcRange = [imgHtml rangeOfString:@"src=\""];
        if (srcRange.location != NSNotFound) {
            imgSrc = [imgHtml substringFromIndex:srcRange.location + 5];
        } else
        {
            continue;
        }
        NSRange endRange = [imgSrc rangeOfString:@"\""];
        if (endRange.length != NSNotFound) {
            imgSrc = [imgSrc substringToIndex:endRange.location];
        } else {
            continue;
        }
        
        [resultArray addObject:imgSrc];
//        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
//            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
//        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
//            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
//        }
//        
//        if (tmpArray.count >= 2) {
//            NSString *src = tmpArray[1];
//            
//            NSUInteger loc = [src rangeOfString:@"\""].location;
//            if (loc != NSNotFound) {
//                src = [src substringToIndex:loc];
//                [resultArray addObject:src];
//            }
//        }
    }
    
    return resultArray;
}

@end
