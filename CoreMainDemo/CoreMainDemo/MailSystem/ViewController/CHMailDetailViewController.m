//
//  CHMailDetailViewController.m
//  CoreMainDemo
//
//  Created by 郑红 on 22/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailDetailViewController.h"
#import "CHMailManager.h"
#import "CHMailFolderModel.h"

static NSString * mainJavascript = @"\
var imageElements = function() {\
    var imageNodes = document.getElementsByTagName('img');\
    return [].slice.call(imageNodes);\
};\
\
var findCIDImageURL = function() {\
    var images = imageElements();\
    \
    var imgLinks = [];\
    for (var i = 0; i < images.length; i++) {\
        var url = images[i].getAttribute('src');\
        if (url.indexOf('cid:') == 0 || url.indexOf('x-mailcore-image:') == 0)\
            imgLinks.push(url);\
    }\
    return JSON.stringify(imgLinks);\
};\
\
var replaceImageSrc = function(info) {\
    var images = imageElements();\
    \
    for (var i = 0; i < images.length; i++) {\
        var url = images[i].getAttribute('src');\
        if (url.indexOf(info.URLKey) == 0) {\
            images[i].setAttribute('src', info.LocalPathKey);break;\
        } }};\
";

@interface CHMailDetailViewController ()<CHMailManagerContentProtocol,UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *mailWebView;

@end

@implementation CHMailDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.letter.htmlBody.length == 0) {
        [[CHMailManager sharedManager] fetchMailContent:self.letter infolder:self.folder];
        [CHMailManager sharedManager].contentDelegate = self;
    } else {
        [self loadPage];
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLocalImage:) name:@"html_img_url_done" object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"html_img_url_done" object:nil];
}

- (void)loadLocalImage:(NSNotification*)notification {
    uint32_t uid = [notification.object unsignedIntValue];
    if (uid == self.letter.uid) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _loadImages];
        });
       
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchMail:(CHMailLetterModel *)letter {
    [self loadPage];
   
    
}
- (void)loadPage {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString * html = [NSMutableString string];
        [html appendFormat:@"<html><head><script>%@</script></head>"
         @"<body>%@</body><iframe src='x-mailcore-msgviewloaded:' style='width: 0px; height: 0px; border: none;'>"
         @"</iframe></html>", mainJavascript, self.letter.htmlBody];
        [self.mailWebView loadHTMLString:html baseURL:nil];
        
    });
}

#pragma mark - webview
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURLRequest *responseRequest = [self webView:webView resource:nil willSendRequest:request redirectResponse:nil fromDataSource:nil];
    
    if(responseRequest == request) {
        return YES;
    } else {
        [webView loadRequest:responseRequest];
        return NO;
    }
}

- (NSURLRequest *)webView:(UIWebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(id)dataSource {
    
    if ([[[request URL] scheme] isEqualToString:@"x-mailcore-msgviewloaded"]) {
        [self _loadImages];
    }
    return request;
}


// 加载网页中的图片
- (void) _loadImages {
    if (self.letter.htmlImgToLocalFile.allKeys.count == 0) {
        return;
    }
    [self.letter.htmlImgToLocalFile enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSDictionary * args =@{@"URLKey": obj,@"LocalPathKey": key};
        NSData * json = [NSJSONSerialization dataWithJSONObject:args options:0 error:nil];
        NSString * jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        
        NSString * replaceScript = [NSString stringWithFormat:@"replaceImageSrc(%@)", jsonString];
        [self.mailWebView stringByEvaluatingJavaScriptFromString:replaceScript];

    }];

}



@end
