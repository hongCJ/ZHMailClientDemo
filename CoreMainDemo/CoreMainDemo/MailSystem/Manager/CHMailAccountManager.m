//
//  CHMailAccountManager.m
//  CoreMainDemo
//
//  Created by 郑红 on 21/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailAccountManager.h"
#import "CHMailAccountModel.h"
#import "CHMailServerModel.h"

@interface CHMailAccountManager ()
{
    NSArray * accountArray;
}

@end

@implementation CHMailAccountManager

- (id)init {
    self = [super init];
    if (self) {
        [self loadMailAccount];
    }
    return self;
}

- (void)loadMailAccount {
    NSDictionary * accountDic = [self localEmail];
    NSMutableArray * modelArray = [[NSMutableArray alloc] init];
    [accountDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        CHMailAccountModel * model = [[CHMailAccountModel alloc] initWithDic:obj];
        [modelArray addObject:model];
    }];
    accountArray = [modelArray copy];
}

- (NSArray*)getMailAccount {
    return [accountArray copy];
}

- (void)clearAccount {
    NSString * filePath = [NSString mailAccountPath];
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        [manager removeItemAtPath:filePath error:nil];
    }
    
}

- (void)deleteAccount:(CHMailAccountModel *)account {
    NSDictionary * mailDic = [self localEmail];
    NSMutableDictionary  * mutDic = [[NSMutableDictionary alloc] initWithDictionary:mailDic];
    [mutDic removeObjectForKey:account.email];
    
    NSString * filePath = [NSString mailAccountPath];
    [NSKeyedArchiver archiveRootObject:mutDic.copy toFile:filePath];
}

- (CHMailAccountModel*)addNewAccount:(NSString *)email
             password:(NSString *)password
               server:(CHMailServerModel*)server
          displayName:(NSString*)displayName
               detail:(NSString*)detail{
   
    CHMailAccountModel * model = [[CHMailAccountModel alloc] initWithServer:server email:email password:password];
    model.displayName = displayName;
    model.detailInfo = detail;
    
    return model;
}

- (void)saveAccount:(CHMailAccountModel *)account {
    NSDictionary * info = [account accountInfo];
    
    [self addNewEmail:info indentifier:account.email];
}

- (NSDictionary*)localEmail {
    NSString * filePath = [NSString mailAccountPath];
    NSDictionary * dic = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (dic == nil) {
        return [[NSDictionary alloc] init];
    }
    return dic;
}

- (void)addNewEmail:(NSDictionary*)dic indentifier:(NSString*)identifier{
    NSDictionary * mailDic = [self localEmail];
    NSMutableDictionary  * mutDic = [[NSMutableDictionary alloc] initWithDictionary:mailDic];
    [mutDic setObject:dic forKey:identifier];
    NSString * filePath = [NSString mailAccountPath];
    [NSKeyedArchiver archiveRootObject:mutDic.copy toFile:filePath];
    
}




@end
