//
//  CHSendMailViewController.m
//  CoreMainDemo
//
//  Created by 郑红 on 20/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHSendMailViewController.h"
#import "CHMailManager.h"
#import <mailcore2-ios/MailCore/MCOAddress.h>
@interface CHSendMailViewController ()<CHMailManagerSendLetterProtocol>
@property (strong, nonatomic) IBOutlet UITextField *toTextField;

@property (strong, nonatomic) IBOutlet UITextField *ccTextField;

@property (strong, nonatomic) IBOutlet UITextField *subjectTextField;

@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation CHSendMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAction:(id)sender {
    CHMailLetterModel * model = [[CHMailLetterModel alloc] init];
    
    NSArray * toArr = [self.toTextField.text componentsSeparatedByString:@";"];
    NSMutableArray * to = [[NSMutableArray alloc] init];
    for (NSString * str in toArr) {
        MCOAddress * address = [MCOAddress addressWithMailbox:str];
        [to addObject:address];
    }
    model.to = [to copy];
    
    model.subject = self.subjectTextField.text;
    
    NSArray * ccArr = [self.ccTextField.text componentsSeparatedByString:@";"];
    NSMutableArray * cc = [[NSMutableArray alloc] init];
    for (NSString * str in ccArr) {
        MCOAddress * address = [MCOAddress addressWithMailbox:str];
        [cc addObject:address];
    }
    model.cc = [cc copy];
    model.htmlBody = self.contentTextView.text;
    
    
    [[CHMailManager sharedManager] sendMail:model byAccount:self.account];
    [CHMailManager sharedManager].sendLetterDelegate = self;
}

- (void)sendLetterComplete:(NSError *)error {
    if (error) {
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}


@end
