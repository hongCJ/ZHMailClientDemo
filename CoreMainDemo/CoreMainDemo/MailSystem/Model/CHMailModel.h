//
//  CHMailModel.h
//  CoreMainDemo
//
//  Created by 郑红 on 24/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHMailAccountModel;
@interface CHMailModel : NSObject

@property (nonatomic,strong) CHMailAccountModel *mailAccount;

@property (nonatomic,copy) NSArray *mailFolder;

@property (nonatomic,assign) NSInteger startIndex;

@property (nonatomic,assign) NSInteger count;

@property (nonatomic,assign) BOOL showFolder;;


- (id)initWithAccount:(CHMailAccountModel*)account folder:(NSArray*)folder;


@end
