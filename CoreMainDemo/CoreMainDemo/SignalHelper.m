//
//  SignalHelper.m
//  CoreMainDemo
//
//  Created by 郑红 on 03/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "SignalHelper.h"
#include <sys/signal.h>

static void signalHander(int signal) {
    NSLog(@"%d",signal);
}

@implementation SignalHelper

+ (void)start {
    //注册程序由于abort()函数调用发生的程序中止信号
    signal(SIGABRT, signalHander);
    
    //注册程序由于非法指令产生的程序中止信号
    signal(SIGILL, signalHander);
    
    //注册程序由于无效内存的引用导致的程序中止信号
    signal(SIGSEGV, signalHander);
    
    //注册程序由于浮点数异常导致的程序中止信号
    signal(SIGFPE, signalHander);
    
    //注册程序由于内存地址未对齐导致的程序中止信号
    signal(SIGBUS, signalHander);
    
    //程序通过端口发送消息失败导致的程序中止信号
    signal(SIGPIPE, signalHander);
    
    signal(SIGQUIT, signalHander);
}



@end
