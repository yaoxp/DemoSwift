//
//  ObserverMainRunloop.h
//  iostest
//
//  Created by YaoXinpan on 2022/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObserverMainRunloop : NSObject
+ (instancetype)instance;
- (void)startMonitor;
- (void)stopMonitor;
@end

NS_ASSUME_NONNULL_END
