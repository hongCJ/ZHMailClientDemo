//
//  CHMailListTableViewController.h
//  CoreMainDemo
//
//  Created by 郑红 on 01/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHMailFolderModel;
@interface CHMailListTableViewController : UITableViewController

@property (nonatomic,strong) CHMailFolderModel *model;

@end
