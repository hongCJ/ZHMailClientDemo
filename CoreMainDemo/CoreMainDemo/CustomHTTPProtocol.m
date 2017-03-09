//
//  CustomHTTPProtocol.m
//  SearchProject
//
//  Created by 郑红 on 03/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CustomHTTPProtocol.h"
#import "CustomRequest.h"

static NSString * should_Request = @"com.should_Request";

@interface CustomHTTPProtocol ()<NSURLSessionDataDelegate>
{
    
}

@property (nonatomic,strong) NSURLSession *mySession;
@property (nonatomic,strong) NSURLRequest *myRequest;

@property (nonatomic,strong) NSURLSessionDataTask *task;


@end

@implementation CustomHTTPProtocol

+ (CustomRequest*)sharedRequest {
    static dispatch_once_t onceToken;
    static CustomRequest * request;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.protocolClasses = @[self];
        request = [[CustomRequest alloc] initWithConfiguration:configuration];
    });
    return request;
}


+ (void)start {
    [NSURLProtocol registerClass:self];
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSLog(@"111");
    BOOL shouldAccept;
    NSURL * url;
    NSString * host;
    NSString * scheme;
    shouldAccept = (request != nil);
    if (shouldAccept) {
        url = [request URL];
        host = [url host];
        if ([host containsString:@"baidu"]) {
            shouldAccept = NO;
        }
        
    }
    
    if (shouldAccept) {
        BOOL isOk = ([[self class] propertyForKey:should_Request inRequest:request] == nil);
        shouldAccept = isOk;
    }
    if (shouldAccept) {
        scheme = [[url scheme] lowercaseString];
        shouldAccept = (scheme != nil);
        
    }
    
//    if (shouldAccept) {
//        shouldAccept = NO && [scheme isEqual:@"http"];
//        if ( ! shouldAccept ) {
//            shouldAccept = YES && [scheme isEqual:@"https"];
//        }
//        
//    }
    
    return shouldAccept;
}


+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest *)request {
    NSLog(@"44");
    assert(request != nil);
    return request;
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    NSLog(@"33");
    assert(request != nil);
    // cachedResponse may be nil
    assert(client != nil);
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}

- (void)startLoading {
    NSLog(@"11");
    assert(self.task == nil);
    NSMutableURLRequest * request = [self.request mutableCopy];
    NSLog(@"%@",request.URL.absoluteString);
    
    [[self class] setProperty:@YES forKey:should_Request inRequest:request];
    self.task = [[[self class] sharedRequest ] dataTaskWithRequest:request delegate:self];
    
    [self.task resume];
}

- (void)stopLoading {
    NSLog(@"22");
    if (self.task != nil) {
        [self.task cancel];
        self.task = nil;
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error == nil) {
        [[self client] URLProtocolDidFinishLoading:self];
    } else if ([error.domain isEqual:NSURLErrorDomain] && (error.code == NSURLErrorCancelled)) {
        
    } else {
        [[self client] URLProtocol:self didFailWithError:error];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler {
    completionHandler(proposedResponse);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSMutableURLRequest *    redirectRequest;
    
    assert([[self class] propertyForKey:should_Request inRequest:newRequest] != nil);
    
    redirectRequest = [newRequest mutableCopy];
    [[self class] removePropertyForKey:should_Request inRequest:redirectRequest];
    
    
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    
    [self.task cancel];
    
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}
@end
