//
//  OCLockBenchmark.m
//  DemoSwift
//
//  Created by yaoxinpan on 2018/12/18.
//  Copyright © 2018 yaoxp. All rights reserved.
//

#import "OCLockBenchmark.h"
#import <pthread.h>
//#import <libkern/OSAtomic.h>
#import <QuartzCore/QuartzCore.h>

@implementation OCLockBenchmark

+ (instancetype)sharedBenchmark {
    static OCLockBenchmark *benchmark;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        benchmark = [[OCLockBenchmark alloc] init];
    });
    
    return benchmark;
}

- (void) startTestLock:(NSInteger)count enableLog:(BOOL)log {
    NSTimeInterval begin, end, time;


    {
        pthread_mutex_t lock;
        pthread_mutex_init(&lock, NULL);
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            pthread_mutex_lock(&lock);
            pthread_mutex_unlock(&lock);
        }
        end = CACurrentMediaTime();
        pthread_mutex_destroy(&lock);
        time = (end - begin) * 1000;
        if (log) {
            printf("OC    pthread_mutex_t:    %8.2f ms\n", time);
        }
    }
    
    {
        dispatch_semaphore_t lock =  dispatch_semaphore_create(1);
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_signal(lock);
        }
        end = CACurrentMediaTime();
        time = (end - begin) * 1000;
        if (log) {
            printf("OC    DispatchSemaphore:  %8.2f ms\n", time);
        }
        
    }
    
    {
        NSCondition *lock = [NSCondition new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        time = (end - begin) * 1000;
        if (log) {
            printf("OC    NSCondition:        %8.2f ms\n", time);
        }
        
    }
    
    {
        NSLock *lock = [NSLock new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        time = (end - begin) * 1000;
        if (log) {
            printf("OC    NSLock:             %8.2f ms\n", time);
        }
    }
    
    {
        NSRecursiveLock *lock = [NSRecursiveLock new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        time = (end - begin) * 1000;
        if (log) {
            printf("OC    NSRecursiveLock:    %8.2f ms\n", time);
        }
        
    }
    
    {
        NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:1];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        time = (end - begin) * 1000;
        if (log) {
            printf("OC    NSConditionLock:    %8.2f ms\n", time);
        }
        
    }
    
    {
        NSObject *lock = [NSObject new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            @synchronized(lock) {}
        }
        end = CACurrentMediaTime();
        time = (end - begin) * 1000;
        if (log) {
            printf("OC    @synchronized:      %8.2f ms\n", time);
        }
        
    }
}


@end
