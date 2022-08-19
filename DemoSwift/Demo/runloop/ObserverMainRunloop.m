//
//  ObserverMainRunloop.m
//  iostest
//
//  Created by YaoXinpan on 2022/6/21.
//

#import "ObserverMainRunloop.h"
#import <objc/runtime.h>
#import "BSBacktraceLogger.h"

// 卡顿时间 ms
#define STUCKMONITORRATE 300

#define MY_DEBUG

#ifdef MY_DEBUG
//#define XPLog(fmt,...)  NSLog((@"%s [Line %d]" fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#define XPLog(fmt,...)  NSLog((fmt),##__VA_ARGS__)
#else
#define XPLog(...)
#endif

@interface ObserverMainRunloop ()
@property (nonatomic, assign) CFRunLoopObserverRef runLoopObserver;
@property (nonatomic, assign) CFRunLoopActivity runLoopActivity;
@property (nonatomic, strong) dispatch_semaphore_t dispatchSemaphore;
@property (nonatomic, assign) NSInteger timeCount;
@end

@implementation ObserverMainRunloop

+ (instancetype)instance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)startMonitor {
    XPLog(@"start monitor");
    [self stopMonitor];
    [self initMonitor];
}

- (void)stopMonitor {
    if (self.runLoopObserver) {
        XPLog(@"stop monitor");
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.runLoopObserver, kCFRunLoopCommonModes);
        CFRelease(self.runLoopObserver);
        self.runLoopObserver = NULL;
    }
}

- (void)initMonitor {
    // 创建一个信号量，保证同步操作
    self.dispatchSemaphore = dispatch_semaphore_create(0); //! Dispatch Semaphore保证同步
    // 创建一个观察者
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    self.runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                   kCFRunLoopAllActivities,
                                                   YES,
                                                   0,
                                                   &runLoopObserverCallback,
                                                   &context);
    // 将观察者添加到主线程runloop的common模式下的观察中
    CFRunLoopAddObserver(CFRunLoopGetMain(), self.runLoopObserver, kCFRunLoopCommonModes);
    [self monitorMainRunloop];
}

static void runLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    ObserverMainRunloop *observerObj = (__bridge ObserverMainRunloop*)info;
    observerObj.runLoopActivity = activity;
    
    dispatch_semaphore_t semaphore = observerObj.dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
    
    switch (activity) {
        case kCFRunLoopAfterWaiting:
//            XPLog(@"RunLoopAfterWaiting");
            break;
        case kCFRunLoopBeforeTimers:
//            XPLog(@"RunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
//            XPLog(@"RunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
//            XPLog(@"RunLoopBeforeWaiting");
            break;
        default:
            break;
    }
    
}

- (void)monitorMainRunloop {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            long semaphoreWait = dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, STUCKMONITORRATE * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self.runLoopObserver) {
                    return;
                }
                if (self.runLoopActivity == kCFRunLoopAfterWaiting ||
                    self.runLoopActivity == kCFRunLoopBeforeSources) {
                    // 在执行time或者source时
                    if (self.timeCount == 0) {
//                        XPLog(@"timecount == 0");
                        self.timeCount += 1;
                        // 防止重复采集
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                            // 此时主线程卡顿，采集主线程的调用栈信息
                            XPLog(@"采集");
                            BSLOG_MAIN;
                        });
                    }
                }
            } else {
//                XPLog(@"timecount = 0");
                self.timeCount = 0;
            }
        }
    });
}

@end
