//
//  OCLockBenchmark.h
//  DemoSwift
//
//  Created by yaoxinpan on 2018/12/18.
//  Copyright © 2018 yaoxp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCLockBenchmark : NSObject

+ (instancetype)sharedBenchmark;

- (void) startTestLock:(NSInteger)count enableLog:(BOOL)log;

@end

NS_ASSUME_NONNULL_END
