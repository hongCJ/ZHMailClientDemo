//
//  CHMailLetterModel.m
//  CoreMainDemo
//
//  Created by 郑红 on 20/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailLetterModel.h"


@implementation CHMailLetterModel

- (id)initWithMessage:(MCOIMAPMessage *)message {
    self = [super init];
    if (self) {
        _uid = message.uid;
        MCOMessageHeader * header = message.header;
        _from = header.from;
        _to = header.to;
        _cc = header.cc;
        _bcc = header.bcc;
        _subject = header.subject;
        _sendDate = header.date;
        _recievedDate = header.receivedDate;
        _replyTo = header.replyTo;
        _body = @"";
        _file = @[];
        _inlineFile = @[];
        _folder = @"";
        
        _htmlImgToLocalFile = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.from forKey:@"from"];
    [aCoder encodeObject:self.to forKey:@"to"];
    [aCoder encodeObject:self.cc forKey:@"cc"];
    [aCoder encodeObject:self.bcc forKey:@"bcc"];
    [aCoder encodeObject:self.replyTo forKey:@"replyTo"];
    [aCoder encodeObject:self.file forKey:@"file"];
    [aCoder encodeObject:self.inlineFile forKey:@"inlineFile"];
    [aCoder encodeObject:self.subject forKey:@"subject"];
    [aCoder encodeObject:self.body forKey:@"body"];
    [aCoder encodeObject:self.sendDate forKey:@"sendDate"];
    [aCoder encodeObject:self.recievedDate forKey:@"reveiveDate"];
    [aCoder encodeObject:@(self.uid) forKey:@"uid"];
    [aCoder encodeObject:self.folder forKey:@"folder"];
    [aCoder encodeObject:self.htmlImgToLocalFile forKey:@"htmlImgToLocalFile"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _from = [aDecoder decodeObjectForKey:@"from"];
        _to = [aDecoder decodeObjectForKey:@"to"];
        _cc = [aDecoder decodeObjectForKey:@"cc"];
        _bcc = [aDecoder decodeObjectForKey:@"bcc"];
        _replyTo = [aDecoder decodeObjectForKey:@"replyTo"];
        _file = [aDecoder decodeObjectForKey:@"file"];
        _inlineFile = [aDecoder decodeObjectForKey:@"inlineFile"];
        _subject = [aDecoder decodeObjectForKey:@"subject"];
        _body = [aDecoder decodeObjectForKey:@"body"];
        
        _sendDate = [aDecoder decodeObjectForKey:@"sendDate"];
        _recievedDate = [aDecoder decodeObjectForKey:@"reveiveDate"];
        _uid = [[aDecoder decodeObjectForKey:@"uid"] unsignedIntValue];
        _folder = [aDecoder decodeObjectForKey:@"folder"];
        
        _htmlImgToLocalFile = [aDecoder decodeObjectForKey:@"htmlImgToLocalFile"];
    }
    return self;
}
@end
