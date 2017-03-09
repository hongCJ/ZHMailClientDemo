//
//  CHSIngleAccountManager.h
//  CoreMainDemo
//
//  Created by 郑红 on 21/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHMailFolderModel;
@class CHMailSession;

@protocol CHMailSessionDelegate <NSObject>

@optional

- (void)Session:(CHMailSession *)session LoginComplete:(NSError *)error;

- (void)Session:(CHMailSession *)session fetchFolder:(NSString*)folder Status:(MCOIMAPFolderStatus*)status error:(NSError*)error;

- (void)Session:(CHMailSession *)session fecthFolderList:(NSArray *)folder error:(NSError *)error;

- (void)Session:(CHMailSession *)session fetchMailinFolder:(CHMailFolderModel *)folder error:(NSError *)error;

- (void)Session:(CHMailSession *)session fetchMailContent:(CHMailLetterModel *)mail error:(NSError *)error;

- (void)Session:(CHMailSession *)session fetchNextPage:(NSInteger)page error:(NSError*)error;

- (void)Session:(CHMailSession *)session fetchNewMail:(NSArray *)mail inFolder:(CHMailFolderModel*)foler;

- (void)Session:(CHMailSession *)session sendMailComplete:(NSError*)error;

- (void)Session:(CHMailSession *)session saveMail:(CHMailLetterModel *)mail toFolder:(NSString*)folder complete:(NSError*)error;


@required

@end

@interface CHMailSession : NSObject

@property (nonatomic,weak) id<CHMailSessionDelegate> sessionDelegate;

@property (nonatomic,readonly,copy) NSString *identifier;

@property (nonatomic,assign) BOOL hasAccountLogin;
@property (nonatomic,assign) BOOL hasAccountChecked;
@property (nonatomic,strong) CHMailAccountModel * mailAccount;


- (instancetype)initWithAccount:(CHMailAccountModel*)account;

- (void)loginAccount;

- (void)sendMail:(CHMailLetterModel*)mail;

- (void)fetchFolderStatus:(NSString*)folder;

- (void)fetchAllFolder;

- (void)fetchMailInFolder:(NSString*)folder;

- (void)fetchMailByUid:(uint32_t)uid folder:(NSString*)folder;

- (void)refreshFolder:(NSString*)folder;

- (void)saveMail:(CHMailLetterModel*)mail toFolder:(NSString*)folder;

- (void)deleteMail:(CHMailLetterModel*)mail fromFolder:(NSString*)folder;



+ (BOOL) isCID:(NSURL *)url;

+ (BOOL) isXMailcoreImage:(NSURL *)url;




@end
