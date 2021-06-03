//
//  OCTimerLeakViewController.m
//  DemoSwift
//
//  Created by yaoxp on 2021/6/2.
//  Copyright © 2021 yaoxp. All rights reserved.
//

#import "OCTimerLeakViewController.h"
#import "WeakTimer.h"

@interface OCTimerLeakViewController ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger counter;
@end

@implementation OCTimerLeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.grayColor;
    self.counter = 0;

//    [self func1];
//    [self func2];
    [self func3];
}

- (void)dealloc
{
    NSLog(@"### %s: dealloc", __FILE_NAME__);
    [self.timer invalidate];
    self.timer = nil;
}

/// 会泄露
- (void)func1 {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:true];
}

/// 不会泄露
- (void)func2 {
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
        // 不会内存泄露
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf timerAction];
    }];
}

- (void)func3 {
    self.timer = [WeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction {
    self.counter++;
    NSLog(@"### %s: %ld", __FILE_NAME__, (long)self.counter);
}

@end
