//
//  CHSIngleAccountManager.m
//  CoreMainDemo
//
//  Created by 郑红 on 21/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailSession.h"
#import "CHMailFolderModel.h"
#import "CHMailServerModel.h"
#import "CHMailCacheManager.h"



@interface CHMailSession ()<MCOHTMLRendererDelegate>
{
    MCOSMTPSession * smtpSession;
    MCOIMAPSession * imapSession;
    dispatch_queue_t sessionQueue;
    
    NSArray<CHMailFolderModel*> * folderArray;
}


@end

@implementation CHMailSession

- (instancetype)initWithAccount:(CHMailAccountModel *)account {
    self = [super init];
    if (self) {
        _mailAccount = account;
        smtpSession = [[MCOSMTPSession alloc] init];
        smtpSession.hostname = account.server.smtpHost;
        smtpSession.port = account.server.smtpPort;
        smtpSession.username = account.userName;
        smtpSession.password = account.password;
        smtpSession.connectionType = MCOConnectionTypeTLS;
        [smtpSession setCheckCertificateEnabled:false];
        
        imapSession = [[MCOIMAPSession alloc] init];
        imapSession.hostname = account.server.imapHost;
        imapSession.port = account.server.imapPort;
        imapSession.username = account.userName;
        imapSession.password = account.password;
        imapSession.connectionType = MCOConnectionTypeTLS;
        [imapSession setCheckCertificateEnabled:false];
        
        sessionQueue = dispatch_queue_create([account.email UTF8String], DISPATCH_QUEUE_SERIAL);
        
        smtpSession.dispatchQueue = sessionQueue;
        imapSession.dispatchQueue = sessionQueue;
        
        _identifier = account.email;
    }
    return self;
}

- (CHMailFolderModel*)folderByPath:(NSString*)path {
    if (folderArray.count == 0) {
        return nil;
    }
    CHMailFolderModel * model = nil;
    for (CHMailFolderModel * temp in folderArray) {
        if ([temp.path isEqualToString:path]) {
            model = temp;
            break;
        }
    }
    return model;
}

- (void)loginAccount {
    MCOSMTPOperation * login = [smtpSession loginOperation];
    [login start:^(NSError * _Nullable error) {
        NSString * err = nil;
        BOOL isSuccess = YES;
        if (error) {
            err = [NSString stringWithFormat:@"login account failure: %@\n", error];
            isSuccess = NO;
            self.hasAccountLogin = NO;
        } else {
            [self checkAccount];
            self.hasAccountLogin = YES;
        }
        if (self.sessionDelegate) {
            if ([self.sessionDelegate respondsToSelector:@selector(Session:LoginComplete:)]) {
                [self.sessionDelegate Session:self LoginComplete:error];
            }
        }
    }];
}

- (void)checkAccount {
    MCOIMAPOperation *imapOperation = [imapSession checkAccountOperation];
    [imapOperation start:^(NSError * __nullable error) {
        if (error == nil) {
            self.hasAccountChecked = YES;
        }
        else {
            self.hasAccountChecked = NO;
        }
    }];
    
}

- (void)sendMail:(CHMailLetterModel *)model {
    NSData * data = [self dataFromMailModel:model];
    MCOSMTPSendOperation *sendOperation = [smtpSession sendOperationWithData:data];
    [sendOperation start:^(NSError *error) {
        if (self.sessionDelegate) {
            if ([self.sessionDelegate respondsToSelector:@selector(Session:sendMailComplete:)]) {
                [self.sessionDelegate Session:self sendMailComplete:error];
            }
        }
    }];
}

- (NSData *)dataFromMailModel:(CHMailLetterModel*)model {
    MCOMessageBuilder * builder = [[MCOMessageBuilder alloc] init];
    builder.header.from = [MCOAddress addressWithDisplayName:_mailAccount.displayName mailbox:_mailAccount.email];
    builder.header.to = model.to;
    builder.header.cc = model.cc;
    builder.header.bcc = model.bcc;
    builder.header.subject = model.subject;
    builder.textBody = model.htmlBody;
    builder.header.replyTo = model.replyTo;
    
    for (MCOAttachment* attachment in model.sendInlineFile) {
        [builder addRelatedAttachment:attachment];
    }
    
    for (MCOAttachment* attachment in model.sendFile) {
        [builder addAttachment:attachment];
    }
    
    NSData * rfc822Data =[builder data];
    
    return rfc822Data;
}

- (void)fetchFolderStatus {
    for (CHMailFolderModel * folder in folderArray) {
        [self fetchFolderStatus:folder.path];
    }
}

- (void)fetchFolderStatus:(NSString *)folder {
    MCOIMAPFolderStatusOperation * statusOp = [imapSession folderStatusOperation:folder];
    [statusOp start:^(NSError * _Nullable error, MCOIMAPFolderStatus * _Nullable status) {
        CHMailFolderModel * model = [self folderByPath:folder];
        model.recentCount = status.recentCount;
//        model.uidNext = status.uidNext;//
        model.uidValidity = status.uidValidity;
        model.unReadCount = status.unseenCount;
        model.totalCount = status.messageCount;
        
        if (self.sessionDelegate) {
            if ([self.sessionDelegate respondsToSelector:@selector(Session:fetchFolder:Status:error:)]) {
                [self.sessionDelegate Session:self fetchFolder:folder Status:status error:error];
            }
        }
    }];
}

- (void)fetchAllFolder {
    
    folderArray = [CHMailCacheManager getAllFolderIn:self.mailAccount];
    if (folderArray.count != 0) {
        [self fetchFolderFinish:nil];
        return;
    }
    
    MCOIMAPFetchFoldersOperation * imapFetchFolder = [imapSession fetchAllFoldersOperation];
    [imapFetchFolder start:^(NSError * _Nullable error, NSArray * _Nullable folders) {
        
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        for (MCOIMAPFolder * folder in folders) {
            CHMailFolderModel * model = [[CHMailFolderModel alloc] init];
            model.path = folder.path;
            model.displayName = folder.path;
            model.flags = folder.flags;
            model.accountEmail = self.mailAccount.email;
            [arr addObject:model];
        }
        folderArray = [arr copy];
        
        [self fetchFolderFinish:error];
        
        [self fetchFolderStatus];
        
    }];
}

- (void)fetchFolderFinish:(NSError*)error {
    if (self.sessionDelegate) {
        if ([self.sessionDelegate respondsToSelector:@selector(Session:fecthFolderList:error:)]) {
            [self.sessionDelegate Session:self fecthFolderList:folderArray error:error];
        }
    }
}


- (void)fetchMailInFolder:(NSString *)folder {
    CHMailFolderModel * model = [self folderByPath:folder];
    
    MCOIMAPMessagesRequestKind requestKind = (MCOIMAPMessagesRequestKind)(MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure | MCOIMAPMessagesRequestKindInternalDate | MCOIMAPMessagesRequestKindHeaderSubject | MCOIMAPMessagesRequestKindFlags);
  
    uint32_t nextUid = model.uidNext;
    if (nextUid == 0) {
        nextUid = 1;
    }
    
    MCORange  mailRange = MCORangeMake(nextUid, UINT64_MAX);
    
    MCOIndexSet *numbers = [MCOIndexSet indexSetWithRange:mailRange];
    MCOIMAPFetchMessagesOperation * imapMessageFetch = [imapSession fetchMessagesOperationWithFolder:folder requestKind:requestKind uids:numbers];
    
    [imapMessageFetch start:^(NSError * _Nullable error, NSArray * _Nullable messages, MCOIndexSet * _Nullable vanishedMessages) {
        NSMutableArray * mailArray = [[NSMutableArray alloc] init];
        
        for (MCOIMAPMessage * me in messages) {
            CHMailLetterModel * mail = [[CHMailLetterModel alloc] initWithMessage:me];
            mail.folder = folder;
            model.uidNext = me.uid + 1;
            [mailArray addObject:mail ];
            
            [self fetchMailByUid:mail.uid folder:folder];
        }
        NSArray * reverseArray = [[mailArray.copy reverseObjectEnumerator] allObjects];
        [model addMails:reverseArray];
        
        if (self.sessionDelegate) {
            if ([self.sessionDelegate respondsToSelector:@selector(Session:fetchMailinFolder:error:)]) {
                [self.sessionDelegate Session:self fetchMailinFolder:model error:error];
            }
        }
    }];
}


- (void)fetchMailByUid:(uint32_t)uid folder:(NSString *)folder {
    
    MCOIMAPFetchContentOperation * fetchContentOp = [imapSession fetchMessageOperationWithFolder:folder uid:uid];
    [fetchContentOp start:^(NSError * error, NSData * data) {
        if ([error code] != MCOErrorNone) {
            return;
        }
        CHMailFolderModel * model = [self folderByPath:folder];
        CHMailLetterModel * letter = [model letterUid:uid];
        
        // 解析邮件内容
        MCOMessageParser * msgPareser = [MCOMessageParser messageParserWithData:data];
        NSString *htmlContent = [msgPareser htmlRenderingWithDelegate:self];
        NSString *textContent = [msgPareser plainTextBodyRenderingAndStripWhitespace:NO];
        letter.textBody = textContent;
        letter.htmlBody = htmlContent;
        
        NSArray * attact = [msgPareser attachments];
        NSArray * inlineAta = [msgPareser htmlInlineAttachments];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (MCOAttachment * obj in attact) {
                NSString * filePath = [NSString fileCache:obj.filename];
                [obj.data writeToFile:filePath atomically:YES];
            }
            for (MCOAttachment * obj in inlineAta) {
                NSString * filePath = [NSString fileCache:obj.filename];
                [obj.data writeToFile:filePath atomically:YES];
            }
        });
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray * imgSrcArray = [htmlContent filterImageSrc];
            if (imgSrcArray.count == 0) {
                return ;
            }
            for (NSString * imgSrc in imgSrcArray) {
                MCOAbstractPart * part = nil;
                NSURL * url = [NSURL URLWithString:imgSrc];
                if ([CHMailSession isCID:url]) {
                    part = [msgPareser partForContentID:[url resourceSpecifier]];
                } else if ([CHMailSession isXMailcoreImage:url]){
                    NSString * specifier = [url resourceSpecifier];
                    NSString * partUniqueID = specifier;
                    part = [msgPareser partForUniqueID:partUniqueID];
                }
                
                if (part == nil) {
                    continue;
                }
                NSString * partUniqueID = [part uniqueID];
                MCOAttachment * attachment = (MCOAttachment *) [msgPareser partForUniqueID:partUniqueID];
                
                NSString * filePath = [NSString fileCache:attachment.filename];
                NSURL * cacheURL = [NSURL fileURLWithPath:filePath];
                
                [letter.htmlImgToLocalFile setObject:imgSrc forKey:cacheURL.absoluteString];
                
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"html_img_url_done" object:@(letter.uid)];
            
        });
        
        
        NSMutableArray * attachArray = [[NSMutableArray alloc] init];
        for (MCOAttachment * obj in attact) {
            [attachArray addObject:obj.filename];
        }
        letter.file = attachArray.copy;
        
        NSMutableArray * inlineAttachArray = [[NSMutableArray alloc] init];
        for (MCOAttachment * obj in inlineAta) {
            [inlineAttachArray addObject:obj.filename];
        }
        letter.inlineFile = inlineAttachArray.copy;
        
        
        
        if (self.sessionDelegate) {
            if ([self.sessionDelegate respondsToSelector:@selector(Session:fetchMailContent:error:)]) {
                [self.sessionDelegate Session:self fetchMailContent:letter error:error];
            }
        }
        
        
    }];
    
}

- (void)saveMail:(CHMailLetterModel *)mail toFolder:(NSString *)folder {
    NSData * data = [self dataFromMailModel:mail];
    MCOIMAPAppendMessageOperation * append = [imapSession appendMessageOperationWithFolder:folder messageData:data flags:MCOMessageFlagDraft];
    [append start:^(NSError * _Nullable error, uint32_t createdUID) {
        if (self.sessionDelegate) {
            if ([self.sessionDelegate respondsToSelector:@selector(Session:saveMail:toFolder:complete:)]) {
                [self.sessionDelegate Session:self saveMail:mail toFolder:folder complete:error];
            }
        }
    }];
}

- (void)deleteMail:(CHMailLetterModel *)mail fromFolder :(NSString *)folder {
    
//    MCOIMAPSearchKindDeleted
}


+ (BOOL) isCID:(NSURL *)url
{
    NSString *theScheme = [url scheme];
    if ([theScheme caseInsensitiveCompare:@"cid"] == NSOrderedSame)
        return YES;
    return NO;
}

+ (BOOL) isXMailcoreImage:(NSURL *)url
{
    NSString *theScheme = [url scheme];
    if ([theScheme caseInsensitiveCompare:@"x-mailcore-image"] == NSOrderedSame)
        return YES;
    return NO;
}




@end
