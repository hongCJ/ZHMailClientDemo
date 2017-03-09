//
//  CHMailListViewController.m
//  CoreMainDemo
//
//  Created by 郑红 on 21/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailFolderListViewController.h"
#import "CHMailListTableViewCell.h"
#import "CHMailManager.h"
#import "NSString+Server.h"
#import "CHMailSession.h"
#import "CHMailAccountManager.h"
#import "CHSendMailViewController.h"
#import "CHMailFolderModel.h"

#import "CHMailDetailViewController.h"
#import "CHMailModel.h"
#import "CHMailServerTableViewController.h"

#import "CHMailListTableViewController.h"

#import "CHMailCacheManager.h"

@interface CHMailFolderListViewController ()<UITableViewDataSource,UITableViewDelegate,CHMailManagerFolderProtocol>
{
    NSMutableArray * accountArray;
    
}

@property (strong, nonatomic) UITableView *MailTableView;

@end

@implementation CHMailFolderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    accountArray = [[NSMutableArray alloc] init];
    
    
    self.MailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 667) style:UITableViewStylePlain];
    self.MailTableView.delegate = self;
    self.MailTableView.dataSource = self;
    [self.view addSubview:self.MailTableView];
    [self.MailTableView registerNib:[UINib nibWithNibName:@"CHMailListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"mailLisrCell"];
    [CHMailManager sharedManager].folderDelegate = self;
    [[CHMailManager sharedManager] fetchAllFolder];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendMail)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccount)];
    
}

- (void)addAccount {
    [self.navigationController popViewControllerAnimated:YES];
//    
//    CHMailServerTableViewController * acountVC = [[CHMailServerTableViewController alloc] init];
//    [self.navigationController pushViewController:acountVC animated:YES];
}

- (void)sendMail {
    if (accountArray.count == 0) {
        return;
    }
    CHSendMailViewController * sendVC = [[CHSendMailViewController alloc] init];
    CHMailModel * model = accountArray[0];
    sendVC.account = model.mailAccount;
    [self.navigationController pushViewController:sendVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers count] == 1) {
        for (CHMailModel * model in accountArray) {
            [CHMailCacheManager cacheMail:model];
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark mailManagerDelegate

- (void)fetchFolder:(NSArray *)folder inAccount:(CHMailAccountModel *)account {
    
    CHMailModel * model = [[CHMailModel alloc] initWithAccount:account folder:folder];
    [accountArray addObject:model];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.MailTableView reloadData];
    });
}

#pragma mark TableViewDelegate

#pragma mark TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return accountArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CHMailModel * model = accountArray[section];
    return model.mailFolder.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHMailListTableViewCell * mailCell = (CHMailListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"mailLisrCell" forIndexPath:indexPath];
    CHMailModel * model = accountArray[indexPath.section];
    CHMailFolderModel * folder = model.mailFolder[indexPath.row];
    mailCell.textLabel.text = folder.displayName;
    
    return mailCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CHMailModel * model = accountArray[indexPath.section];
   
    CHMailListTableViewController * listVc = [[CHMailListTableViewController alloc] init];
    listVc.model = model.mailFolder[indexPath.row];
//    listVc.account = model.mailAccount;
    
    [self.navigationController pushViewController:listVc animated:YES];
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 50)];
    UILabel * label = [[UILabel alloc] initWithFrame:header.frame];
    CHMailModel* folder = accountArray[section];
    label.text = folder.mailAccount.displayName;
    [header addSubview:label];
    return header;
}


@end
