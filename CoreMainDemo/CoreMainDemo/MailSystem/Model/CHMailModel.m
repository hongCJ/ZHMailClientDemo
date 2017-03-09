//
//  CHMailModel.m
//  CoreMainDemo
//
//  Created by 郑红 on 24/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailModel.h"
#import "CHMailAccountModel.h"
#import "CHMailFolderModel.h"
#import "CHMailSession.h"
@interface CHMailModel ()<CHMailSessionDelegate>
{
    
}

@property (nonatomic,strong) CHMailSession *session;

@end

@implementation CHMailModel

- (id)initWithAccount:(CHMailAccountModel *)account folder:(NSArray*)folder {
    self = [super init];
    if (self) {
        _mailAccount = account;
        _mailFolder = folder;
    }
    return self;
}

@end
