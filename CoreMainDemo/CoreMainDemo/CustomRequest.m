//
//  CustomRequest.m
//  CoreMainDemo
//
//  Created by 郑红 on 06/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CustomRequest.h"


@interface TaskInfoObj : NSObject

@property (nonatomic,strong) NSURLSessionDataTask *task;
@property (nonatomic,weak) id<NSURLSessionDataDelegate> delegate;

@property (atomic, strong,) NSThread *                    thread;

- (void)performBlock:(dispatch_block_t)block;

- (id)initWithTask:(NSURLSessionDataTask*)task delegate:(id<NSURLSessionDataDelegate>)delegate;

- (void)invalidate;
@end

@implementation TaskInfoObj

- (id)initWithTask:(NSURLSessionDataTask *)task delegate:(id<NSURLSessionDataDelegate>)delegate {
    self = [super init];
    if (self) {
        _task = task;
        _delegate = delegate;
        _thread = [NSThread currentThread];
    }
    return self;
}
- (void)invalidate
{
    self.delegate = nil;
    self.thread = nil;
}


- (void)performBlock:(dispatch_block_t)block
{
    assert(self.delegate != nil);
    assert(self.thread != nil);
    [self performSelector:@selector(performBlockOnClientThread:) onThread:self.thread withObject:[block copy] waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
}

- (void)performBlockOnClientThread:(dispatch_block_t)block
{
    assert([NSThread currentThread] == self.thread);
    block();
}


@end

@interface CustomRequest ()<NSURLSessionDataDelegate>
{
    
}

@property (nonatomic,strong) NSMutableDictionary *taskInfoDic;
@property (nonatomic,strong) NSURLSession *taskSession;
@property (nonatomic,strong) NSOperationQueue *sessionQueue;

@end


@implementation CustomRequest

- (id)initWithConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (self) {
        _sessionQueue = [[NSOperationQueue alloc] init];
        _taskSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.sessionQueue];
        
        _taskInfoDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}



- (NSURLSessionDataTask*)dataTaskWithRequest:(NSURLRequest *)request delegate:(id<NSURLSessionDataDelegate>)delegate {
    NSURLSessionDataTask * task = [self.taskSession dataTaskWithRequest:request];
    TaskInfoObj * obj = [[TaskInfoObj alloc] initWithTask:task delegate:delegate];
    @synchronized (self) {
        self.taskInfoDic[@(task.taskIdentifier)] = obj;
    }
    return task;
}

- (TaskInfoObj *)taskInfoForTask:(NSURLSessionTask *)task
{
    TaskInfoObj *    result;
    
    assert(task != nil);
    
    @synchronized (self) {
        result = self.taskInfoDic[@(task.taskIdentifier)];
        assert(result != nil);
    }
    return result;
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    TaskInfoObj *    taskInfo;
    
    taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task willPerformHTTPRedirection:response newRequest:newRequest completionHandler:completionHandler];
        }];
    } else {
        completionHandler(newRequest);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    TaskInfoObj *    taskInfo;
    
    taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:didReceiveChallenge:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
        }];
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
    TaskInfoObj *    taskInfo;
    
    taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:needNewBodyStream:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task needNewBodyStream:completionHandler];
        }];
    } else {
        completionHandler(nil);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    TaskInfoObj *    taskInfo;
    
    taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
        }];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    TaskInfoObj *    taskInfo;
    
    taskInfo = [self taskInfoForTask:task];
    
    // This is our last delegate callback so we remove our task info record.
    
    @synchronized (self) {
        [self.taskInfoDic removeObjectForKey:@(taskInfo.task.taskIdentifier)];
    }
    
    // Call the delegate if required.  In that case we invalidate the task info on the client thread
    // after calling the delegate, otherwise the client thread side of the -performBlock: code can
    // find itself with an invalidated task info.
    
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task didCompleteWithError:error];
            [taskInfo invalidate];
        }];
    } else {
        [taskInfo invalidate];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    TaskInfoObj *    taskInfo;
    
    taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
        }];
    } else {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    TaskInfoObj *    taskInfo;
    
    taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:didBecomeDownloadTask:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask didBecomeDownloadTask:downloadTask];
        }];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    TaskInfoObj *    taskInfo;
    
    taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask didReceiveData:data];
        }];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    TaskInfoObj *    taskInfo;
    
    taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:willCacheResponse:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
        }];
    } else {
        completionHandler(proposedResponse);
    }
}

@end
