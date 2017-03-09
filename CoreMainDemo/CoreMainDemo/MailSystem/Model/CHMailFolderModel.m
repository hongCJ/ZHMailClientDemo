//
//  CHMailFolderModel.m
//  CoreMainDemo
//
//  Created by 郑红 on 22/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailFolderModel.h"

@interface CHMailFolderModel ()

@end

@implementation CHMailFolderModel

- (id)init {
    self = [super init];
    if (self) {
        _mails = @[];
        _accountEmail = @"";
        _path = @"";
        _displayName = @"";
        _uidNext = 0;
        _uidValidity = 0;
        _recentCount = 0;
        _unReadCount = 0;
        _totalCount = 0;
        _flags = MCOIMAPFolderFlagAll;
    }
    return self;
}


- (void)addMails:(NSArray *)mails {
    self.mails  = [self.mails arrayByAddingObjectsFromArray:mails];
}

- (CHMailLetterModel *)letterUid:(uint32_t)uid {
    CHMailLetterModel * model = nil;
    for (CHMailLetterModel * temp in self.mails) {
        if (temp.uid == uid) {
            model = temp;
            break;
        }
    }
    return model;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accountEmail forKey:@"accountEmail"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.displayName forKey:@"displayName"];
    [aCoder encodeObject:self.mails forKey:@"mails"];
    [aCoder encodeObject:@(self.uidNext) forKey:@"uidNext"];
    [aCoder encodeObject:@(self.uidValidity) forKey:@"uidValidity"];
    [aCoder encodeObject:@(self.recentCount)forKey:@"recentCount"];
    [aCoder encodeObject:@(self.unReadCount) forKey:@"unReadCount"];
    [aCoder encodeObject:@(self.totalCount)forKey:@"totalCount"];
    [aCoder encodeObject:@(self.flags) forKey:@"flags"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _accountEmail = [aDecoder decodeObjectForKey:@"accountEmail"];
        _path = [aDecoder decodeObjectForKey:@"path"];
        _displayName = [aDecoder decodeObjectForKey:@"displayName"];
        _mails = [aDecoder decodeObjectForKey:@"mails"];
        _uidNext = [[aDecoder decodeObjectForKey:@"uidNext"] unsignedIntValue];
        _uidValidity = [[aDecoder decodeObjectForKey:@"uidValidity"] unsignedIntValue];
        _recentCount = [[aDecoder decodeObjectForKey:@"recentCount"] unsignedIntValue];
        _unReadCount = [[aDecoder decodeObjectForKey:@"unReadCount"] intValue];
        _totalCount = [[aDecoder decodeObjectForKey:@"totalCount"] intValue];
        _flags = [[aDecoder decodeObjectForKey:@"flags"] integerValue];
    }
    return self;
}

@end
