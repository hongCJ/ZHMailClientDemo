//
//  CHMailServerModel.h
//  CoreMainDemo
//
//  Created by 郑红 on 23/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHMailServerModel : NSObject

@property (nonatomic,assign) unsigned int smtpPort;
@property (nonatomic,assign) unsigned int imapPort;
@property (nonatomic,assign) unsigned int pop3Port;

@property (nonatomic,copy) NSString *displayName;
@property (nonatomic,copy) NSString *icon;

@property (nonatomic,copy) NSString *smtpHost;
@property (nonatomic,copy) NSString *imapHost;
@property (nonatomic,copy) NSString *pop3Host;


- (instancetype)initWithDic:(NSDictionary*)dic;



@end
