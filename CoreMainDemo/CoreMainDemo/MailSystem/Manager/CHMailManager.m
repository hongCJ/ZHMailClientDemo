//
//  CHMailManager.m
//  CoreMainDemo
//
//  Created by 郑红 on 21/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailManager.h"
#import "CHMailAccountManager.h"
#import "CHMailModel.h"
#import "CHMailSession.h"
#import "CHMailAccountModel.h"

#import "CHMailCacheManager.h"
@interface CHMailManager ()<CHMailSessionDelegate>
{
    CHMailAccountManager * accountManager;
    dispatch_queue_t managerQueue;
    NSMutableArray<CHMailSession*> * sessionArray;
    
}


@end

@implementation CHMailManager

+ (CHMailManager*)sharedManager {
    static dispatch_once_t onceToken;
    static CHMailManager* manager;
    dispatch_once(&onceToken, ^{
        manager = [[CHMailManager alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        accountManager = [[CHMailAccountManager alloc] init];
        sessionArray = [[NSMutableArray alloc] init];
        managerQueue = dispatch_queue_create("MailManagerQueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(managerQueue, ^{
           [self loadSession];
        });
    }
    return self;
}

- (void)loadSession {
    NSArray * array = [accountManager getMailAccount];
    for (CHMailAccountModel * account in array) {
        CHMailSession * session = [[CHMailSession alloc] initWithAccount:account];
        session.sessionDelegate = self;
        [session loginAccount];
        [sessionArray addObject:session];
    }
}

- (void)fetchAllFolder {
    for (CHMailSession * session in sessionArray) {
        [session fetchAllFolder];
    }
}

- (void)fetchMailInFolder:(CHMailFolderModel *)folder {
    for (CHMailSession * session in sessionArray) {
        if ([session.identifier isEqualToString:folder.accountEmail]) {
            [session fetchMailInFolder:folder.path];
            break;
        }
    }
}

- (void)fetchMailContent:(CHMailLetterModel *)letter infolder:(CHMailFolderModel *)folder {
    for (CHMailSession * session in sessionArray) {
        if ([session.identifier isEqualToString:folder.accountEmail]) {
            [session fetchMailByUid:letter.uid folder:folder.path];
            break;
        }
    }
}

- (void)sendMail:(CHMailLetterModel *)letter byAccount:(CHMailAccountModel *)account{
    for (CHMailSession * session in sessionArray) {
        if ([session.identifier isEqualToString:account.email]) {
            [session sendMail:letter];
            break;
        }
    }
}


- (void)addMailAccount:(CHMailServerModel *)server
                 email:(NSString *)email
              password:(NSString *)password
           displayName:(NSString *)name
           description:(NSString *)description {
    
    CHMailAccountModel * model =  [accountManager addNewAccount:email password:password server:server displayName:name detail:description];
    
    CHMailSession * session = [[CHMailSession alloc] initWithAccount:model];
    session.sessionDelegate = self;
    [session loginAccount];
    
}

#pragma mark MailModelDelagatr

- (void)Session:(CHMailSession *)session LoginComplete:(NSError *)error {
    NSString * err = nil;
    if (error) {
        err = [error localizedDescription];
    }
    if (self.CHMailAddAccountBlock) {
        self.CHMailAddAccountBlock(err);
        if (err == nil) {
            [accountManager saveAccount:session.mailAccount];
            [session fetchAllFolder];
            [sessionArray addObject:session];
        }
        self.CHMailAddAccountBlock = nil;
    }
//    if (err == nil) {
//        [session fetchAllFolder];
//    }
    
}

- (void)Session:(CHMailSession *)session sendMailComplete:(NSError *)error {
    if (self.sendLetterDelegate) {
        if ([self.sendLetterDelegate respondsToSelector:@selector(sendLetterComplete:)]) {
            [self.sendLetterDelegate sendLetterComplete:error];
        }
    }
}

- (void)Session:(CHMailSession *)session fetchNextPage:(NSInteger)page error:(NSError *)error {
    
}

- (void)Session:(CHMailSession *)session fecthFolderList:(NSArray *)folder error:(NSError *)error {
    if (self.folderDelegate) {
        if ([self.folderDelegate respondsToSelector:@selector(fetchFolder:inAccount:)]) {
            [self.folderDelegate fetchFolder:folder inAccount:session.mailAccount];
        }
    }
}

- (void)Session:(CHMailSession *)session fetchNewMail:(NSArray *)mail inFolder:(CHMailFolderModel *)foler {
    
}

- (void)Session:(CHMailSession *)session fetchMailContent:(CHMailLetterModel *)mail error:(NSError *)error {
    if (self.contentDelegate) {
        if ([self.contentDelegate respondsToSelector:@selector(fetchMail:)]) {
            [self.contentDelegate fetchMail:mail];
        }
    }
}

- (void)Session:(CHMailSession *)session fetchMailinFolder:(CHMailFolderModel *)folder error:(NSError *)error {
    if (self.listDelegate) {
        if ([self.listDelegate respondsToSelector:@selector(fetchMailIn:)]) {
            [self.listDelegate fetchMailIn:folder];
        }
    }
}

- (void)Session:(CHMailSession *)session fetchFolder:(NSString *)folder Status:(MCOIMAPFolderStatus *)status error:(NSError *)error {
    
}

- (void)Session:(CHMailSession *)session saveMail:(CHMailLetterModel *)mail toFolder:(NSString *)folder complete:(NSError *)error {
    
}



@end
