//
//  NSDate+toString.h
//  CoreMainDemo
//
//  Created by 郑红 on 10/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (toString)

- (NSString*)toMailString;

- (NSString*)toString;

- (NSString*)toString:(NSString*)formatter;

@end
