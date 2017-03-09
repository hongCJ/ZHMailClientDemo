//
//  CHMailAccountManager.h
//  CoreMainDemo
//
//  Created by 郑红 on 21/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHMailServerModel;

@interface CHMailAccountManager : NSObject

- (NSArray*)getMailAccount;
- (void)clearAccount;

- (void)deleteAccount:(CHMailAccountModel*)account;


- (CHMailAccountModel*)addNewAccount:(NSString*)email
             password:(NSString*)password
               server:(CHMailServerModel*)server
          displayName:(NSString*)displayName
               detail:(NSString*)detail;

- (void)saveAccount:(CHMailAccountModel*)account;

@end
