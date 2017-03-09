//
//  CustomRequest.h
//  CoreMainDemo
//
//  Created by 郑红 on 06/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomRequest : NSObject

- (id)initWithConfiguration:(NSURLSessionConfiguration*)configuration;


- (NSURLSessionDataTask*)dataTaskWithRequest:(NSURLRequest*)request delegate:(id<NSURLSessionDataDelegate>)delegate;

@end
