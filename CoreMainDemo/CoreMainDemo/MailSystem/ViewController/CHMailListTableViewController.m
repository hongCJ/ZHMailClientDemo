//
//  CHMailListTableViewController.m
//  CoreMainDemo
//
//  Created by 郑红 on 01/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailListTableViewController.h"
#import "CHMailManager.h"
#import "CHMailDetailViewController.h"

@interface CHMailListTableViewController ()<CHMailManagerListProtocol>
{
    
}
@end

@implementation CHMailListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mailListCell"];
    [CHMailManager sharedManager].listDelegate = self;
    [[CHMailManager sharedManager] fetchMailInFolder:self.model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMailIn:(CHMailFolderModel *)folder {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.model.mails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mailListCell" forIndexPath:indexPath];
    CHMailLetterModel * letter = self.model.mails[indexPath.row];
    cell.textLabel.text = letter.subject;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CHMailLetterModel * letter = self.model.mails[indexPath.row];

    CHMailDetailViewController * detailVc = [[CHMailDetailViewController alloc] init];
    detailVc.letter = letter;
    detailVc.folder = self.model;
    [self.navigationController pushViewController:detailVc animated:YES];
}


@end
