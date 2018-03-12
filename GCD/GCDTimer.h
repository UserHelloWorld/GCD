//
//  GCDTimer.h
//  GCDTimer
//
//  Created by apple on 12/03/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 定时器类
 */
@interface GCDTimer : NSObject

+ (GCDTimer *)instance;

/** 开始定时 */
- (void)startTimer:(int)time block:(dispatch_block_t)block;


/**
 开始定时
  @param time 倒计时总时间
 @param complete 计时时间
 */
//- (void)startTimer:(int)time block:(void (^) (int t))complete;


- (void)stopTimer;


@end
