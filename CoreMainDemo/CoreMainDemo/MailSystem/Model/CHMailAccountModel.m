//
//  CHMailAccountModel.m
//  CoreMainDemo
//
//  Created by 郑红 on 20/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailAccountModel.h"
#import "CHMailServerModel.h"

@implementation CHMailAccountModel

- (id)initWithServer:(CHMailServerModel *)server email:(NSString *)email password:(NSString *)password {
    self = [super init];
    if (self) {
        NSRange  range = [email rangeOfString:@"@"];
        NSString * userName = [email substringToIndex:range.location];
        
        _server = server;
        if (server.smtpHost == nil || server.smtpHost.length == 0) {
            NSString *hostName = [email substringFromIndex:range.location+1];
            _server.smtpHost = [NSString stringWithFormat:@"smtp.%@", hostName];
            _server.pop3Host = [NSString stringWithFormat:@"pop.%@", hostName];
            _server.imapHost = [NSString stringWithFormat:@"imap.%@", hostName];
        }
        _userName = userName;
        _password = password;
        _email = email;
        _displayName = _email;
        _detailInfo = @"";
    }
    return self;

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
    }
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
//    aCoder encodeObject:<#(nullable id)#> forKey:<#(nonnull NSString *)#>
}


- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _server = [[CHMailServerModel alloc] init];
        _server.smtpHost = [dic objectForKey:@"smtpHost"];
        _server.imapHost = [dic objectForKey:@"imapHost"];
        _server.pop3Host = [dic objectForKey:@"pop3Host"];
        _userName = [dic objectForKey:@"username"];
        _password = [dic objectForKey:@"password"];
        _server.smtpPort = [[dic objectForKey:@"smtpPort"] intValue];
        _server.imapPort = [[dic objectForKey:@"imapPort"] intValue];
        _server.pop3Port = [[dic objectForKey:@"pop3Port"] intValue];
        _detailInfo = [dic objectForKey:@"detail"];
        _displayName = [dic objectForKey:@"displayName"];
        _email = [dic objectForKey:@"email"];
    }
    return self;
}

- (NSDictionary *)accountInfo {
    return @{
             @"smtpHost":self.server.smtpHost,
             @"imapHost":self.server.imapHost,
             @"pop3Host":self.server.pop3Host,
             @"username":self.userName,
             @"password":self.password,
             @"displayName":self.displayName,
             @"detail":self.detailInfo,
             @"email":self.email,
             @"smtpPort":@(self.server.smtpPort),
             @"imapPort":@(self.server.imapPort),
             @"pop3Port":@(self.server.pop3Port)
             };
}



@end
