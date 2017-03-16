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
#import "CHMailListTableViewCell.h"

@interface CHMailListTableViewController ()<CHMailManagerListProtocol,CHMailListCellProtocol>
{
    
}
@end

@implementation CHMailListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CHMailListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"mailListCell"];
//    self.tableView.gest
    self.tableView.rowHeight = 100;
    [CHMailManager sharedManager].listDelegate = self;
    [[CHMailManager sharedManager] fetchMailInFolder:self.model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MailManagerDeleagte

- (void)fetchMailIn:(CHMailFolderModel *)folder {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}




#pragma mark MailCellDelegate

- (void)Action:(CHMailAction)action ForMailAt:(NSIndexPath *)indexPath {
    switch (action) {
        case MailActionRead:
            NSLog(@"read");
            break;
        case MailActionUnRead:
            NSLog(@"unread");
            break;
        case MailActionMore:
            NSLog(@"more");
            break;
        case MailActionStar:
            NSLog(@"star");
            break;
        case MailActionDelete:
            NSLog(@"delete");
            break;
    }
}

- (BOOL)MailUnReadAt:(NSIndexPath *)indexPath {
    CHMailLetterModel * letter = self.model.mails[indexPath.row];
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.model.mails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHMailListTableViewCell *cell = (CHMailListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"mailListCell" forIndexPath:indexPath];
    CHMailLetterModel * letter = self.model.mails[indexPath.row];
    cell.mailFromLabel.text = letter.from.displayName;
    cell.mailSubjectLabel.text = letter.subject;
    cell.mailBodyLabel.text = letter.textBody;
    cell.mailDateLabel.text = letter.receivedDateDes;
    cell.mailListDelegate = self;
    cell.cellIndexPath = indexPath;
    
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
