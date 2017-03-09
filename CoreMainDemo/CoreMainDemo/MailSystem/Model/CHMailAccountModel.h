//
//  CHMailAccountModel.h
//  CoreMainDemo
//
//  Created by 郑红 on 20/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CHMailServerModel;
@interface CHMailAccountModel : NSObject<NSCoding>

@property (nonatomic,copy) NSString *displayName;
@property (nonatomic,copy) NSString *detailInfo;

@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *email;

@property (nonatomic,strong) CHMailServerModel *server;

@property (nonatomic,assign) BOOL certificated;
@property (nonatomic,assign) BOOL useSSL;



- (id)initWithServer:(CHMailServerModel*)server//example.com
             email:(NSString*)email//userName before@
          password:(NSString*)password;//password

- (id)initWithDic:(NSDictionary*)dic;

- (NSDictionary *)accountInfo;

@end
