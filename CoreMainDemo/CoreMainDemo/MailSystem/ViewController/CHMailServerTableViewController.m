//
//  CHMailServerTableViewController.m
//  CoreMainDemo
//
//  Created by 郑红 on 23/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailServerTableViewController.h"
#import "NSString+Server.h"
#import "CHMailServerModel.h"

#import "CHMailAddAccountViewController.h"

@interface CHMailServerTableViewController ()
{
    NSArray * serverArray;
}

@end

@implementation CHMailServerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * path = [NSString mailServerPath];
    NSArray * array = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSMutableArray * serTemp = [[NSMutableArray alloc] init];
    for (NSDictionary * dic in array) {
        CHMailServerModel * model = [[CHMailServerModel alloc] initWithDic:dic];
        [serTemp addObject:model];
    }
    
    serverArray = [serTemp copy];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ServerCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return serverArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServerCell" forIndexPath:indexPath];
    CHMailServerModel * model = serverArray[indexPath.row];
    cell.textLabel.text = model.displayName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= serverArray.count) {
        return;
    }
    
    CHMailServerModel * model = serverArray[indexPath.row];
    CHMailAddAccountViewController * addMailVc = [[CHMailAddAccountViewController alloc] init];
    addMailVc.server = model;
    [self.navigationController pushViewController:addMailVc animated:YES];
    
}


@end
