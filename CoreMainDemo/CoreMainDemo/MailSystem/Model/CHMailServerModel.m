//
//  CHMailServerModel.m
//  CoreMainDemo
//
//  Created by 郑红 on 23/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailServerModel.h"

@implementation CHMailServerModel

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _displayName = [dic objectForKey:@"displayName"];
        _icon = [dic objectForKey:@"icon"];
        _smtpHost = [dic objectForKey:@"smtpHost"];
        _imapHost = [dic objectForKey:@"imapHost"];
        _pop3Host = [dic objectForKey:@"pop3Host"];
        _smtpPort = [[dic objectForKey:@"smptPort"] intValue];
        _imapPort = [[dic objectForKey:@"imapPort"] intValue];
        _pop3Port = [[dic objectForKey:@"pop3Port"] intValue];
    }
    return self;
}

@end
