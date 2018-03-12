//
//  GCDTimer.m
//  GCDTimer
//
//  Created by apple on 12/03/18.
//  Copyright © 2018年 apple. All rights reserved.
//



#import "GCDTimer.h"

@interface GCDTimer ()

@property (strong, nonatomic) dispatch_source_t timer;

@end

@implementation GCDTimer

+ (GCDTimer *)instance {
    return [[GCDTimer alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    }
    return self;
}

- (void)startTimer:(int)time block:(dispatch_block_t)block
{
    __block int countdown = 0;
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        countdown ++;
//        NSLog(@"%@",[NSThread currentThread]);
        if (time == countdown) {
            dispatch_source_cancel(self.timer);
        }
        if (block) {
            block();
        }
    });
    dispatch_resume(self.timer);
}

- (void)stopTimer
{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        NSLog(@"cancel");
    }
    NSLog(@"走了");
}

- (void)dealloc
{
    NSLog(@"%s %d",__func__,__LINE__);
}


@end
