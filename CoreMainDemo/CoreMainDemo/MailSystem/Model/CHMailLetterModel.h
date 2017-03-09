//
//  CHMailLetterModel.h
//  CoreMainDemo
//
//  Created by 郑红 on 20/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCOAddress;
@class MCOIMAPMessage;



@interface CHMailLetterModel : NSObject<NSCoding>

/*
 for both send and receive
 */

@property (nonatomic,copy) MCOAddress *from;
@property (nonatomic,copy) NSArray<MCOAddress*> *to;
@property (nonatomic,copy) NSArray<MCOAddress*> *cc;
@property (nonatomic,copy) NSArray<MCOAddress*> *bcc;
@property (nonatomic,copy) NSArray<MCOAddress*> *replyTo;
@property (nonatomic,copy) NSString *subject;
@property (nonatomic,copy) NSString *body;

/*
 for send
 */

@property (nonatomic,copy) NSArray<MCOAttachment*> *sendFile;
@property (nonatomic,copy) NSArray<MCOAttachment*> *sendInlineFile;

/*
 for receive
 */
@property (nonatomic,copy) NSMutableDictionary<NSString*,NSString*> *htmlImgToLocalFile;

@property (nonatomic,copy) NSArray<NSString*> *file;// fileName
@property (nonatomic,copy) NSArray<NSString*> *inlineFile;

@property (nonatomic,strong) NSDate *sendDate;
@property (nonatomic,strong) NSDate *recievedDate;
@property (nonatomic,assign) uint32_t uid;
@property (nonatomic,copy) NSString *folder;


- (id)initWithMessage:(MCOIMAPMessage*)message;

@end
