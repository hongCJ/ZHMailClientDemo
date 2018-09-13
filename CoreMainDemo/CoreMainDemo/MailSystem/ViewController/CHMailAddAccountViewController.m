//
//  CHMailAddAccountViewController.m
//  CoreMainDemo
//
//  Created by 郑红 on 21/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailAddAccountViewController.h"
#import "CHMailManager.h"
@interface CHMailAddAccountViewController ()
@property (strong, nonatomic) IBOutlet UITextField *displayNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;


@end

@implementation CHMailAddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.server) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addAccount:(id)sender {
    NSString * email = self.emailTextField.text;
    if (email.length == 0) {
        return;
    }
    if ([email ch_Email] == NO) {
        return;
    }
    NSString * password = self.passwordTextField.text;
    if (password.length == 0) {
        return;
    }

    [[CHMailManager sharedManager] addMailAccount:self.server email:email password:password displayName:self.displayNameTextField.text description:self.descriptionTextField.text];
    [SVProgressHUD showWithStatus:@"正在添加"];
    [[CHMailManager sharedManager] setCHMailAddAccountBlock:^(NSString * err) {
        if (err) {
            [SVProgressHUD showErrorWithStatus:err];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
               [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
