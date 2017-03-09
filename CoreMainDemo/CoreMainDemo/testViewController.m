//
//  testViewController.m
//  CoreMainDemo
//
//  Created by 郑红 on 03/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "testViewController.h"

static void exceptionHander(NSException * exception) {
    NSLog(@"%@--%@",exception.name,exception.reason);
}

@interface testViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) IBOutlet UITextField *myTextField;

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    // Do any additional setup after loading the view.
    NSSetUncaughtExceptionHandler(exceptionHander);
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (IBAction)search:(id)sender {
    NSString * text = self.myTextField.text;
    NSString * path = [@"https://" stringByAppendingString:text];
    
    NSURL * url = [NSURL URLWithString:path];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    [self.myWebView loadRequest:request];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
