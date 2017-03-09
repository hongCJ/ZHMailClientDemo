//
//  CHMailManager.h
//  CoreMainDemo
//
//  Created by 郑红 on 21/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CHMailManagerFolderProtocol <NSObject>

//- (void)newAccountAdded;
- (void)fetchFolder:(NSArray*)folder inAccount:(CHMailAccountModel*)account;

@end

@protocol CHMailManagerListProtocol <NSObject>

- (void)fetchMailIn:(CHMailFolderModel*)folder;

@end

@protocol CHMailManagerContentProtocol <NSObject>

- (void)fetchMail:(CHMailLetterModel*)letter;

@end

@protocol CHMailManagerSendLetterProtocol <NSObject>

- (void)sendLetterComplete:(NSError*)error;


@end



@class CHMailServerModel;
@interface CHMailManager : NSObject

@property (nonatomic,weak) id<CHMailManagerFolderProtocol> folderDelegate;
@property (nonatomic,weak) id<CHMailManagerListProtocol> listDelegate;
@property (nonatomic,weak) id<CHMailManagerContentProtocol> contentDelegate;
@property (nonatomic,weak) id<CHMailManagerSendLetterProtocol> sendLetterDelegate;

@property (nonatomic,copy) void(^CHMailAddAccountBlock)(NSString * err);

+ (CHMailManager*)sharedManager;

- (void)fetchMailInFolder:(CHMailFolderModel*)folder;

- (void)fetchMailContent:(CHMailLetterModel*)letter infolder:(CHMailFolderModel*)folder;
- (void)fetchAllFolder;

- (void)sendMail:(CHMailLetterModel*)letter byAccount:(CHMailAccountModel*)account;

- (void)addMailAccount:(CHMailServerModel*)server
                 email:(NSString*)email
              password:(NSString*)password
           displayName:(NSString*)name
           description:(NSString*)description;



@end
