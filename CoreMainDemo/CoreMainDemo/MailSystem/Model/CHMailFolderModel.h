//
//  CHMailFolderModel.h
//  CoreMainDemo
//
//  Created by 郑红 on 22/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHMailFolderModel : NSObject<NSCoding>

@property (nonatomic,copy) NSString *accountEmail;


@property (nonatomic,copy) NSString *path;

@property (nonatomic,copy) NSString *displayName;

@property (nonatomic,copy) NSArray *mails;


@property (nonatomic, assign) uint32_t uidNext;

@property (nonatomic, assign) uint32_t uidValidity;

@property (nonatomic, assign) uint32_t recentCount;

@property (nonatomic,assign) int unReadCount;
@property (nonatomic,assign) int totalCount;
//@property (nonatomic,assign) int unFecthed;

@property (nonatomic,assign) MCOIMAPFolderFlag flags;


- (void)addMails:(NSArray*)mails;

- (CHMailLetterModel *)letterUid:(uint32_t)uid;

@end
