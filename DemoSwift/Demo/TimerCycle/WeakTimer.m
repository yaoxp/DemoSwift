//
//  WeakTimer.m
//  TimerTest
//
//  Created by YaoXinpan on 2021/6/3.
//  Copyright © 2021 YaoXinpan. All rights reserved.
//

#import "WeakTimer.h"

@interface WeakTimer ()
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) id target;
@end

@implementation WeakTimer
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    WeakTimer *timer = [WeakTimer new];
    timer.selector = aSelector;
    timer.target = aTarget;
    timer.timer = [NSTimer timerWithTimeInterval:ti target:timer selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
    return timer.timer;
}
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    WeakTimer *timer = [WeakTimer new];
    timer.selector = aSelector;
    timer.target = aTarget;
    timer.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:timer selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
    return timer.timer;
}

- (void)fire:(NSTimer *)timer {
    if (self.target && [self.target respondsToSelector:self.selector]) {
        IMP imp = [self.target methodForSelector:self.selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self.target, self.selector);
    } else {
        [self.timer invalidate];
    }
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}
@end
