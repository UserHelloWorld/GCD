//
//  ViewController1.m
//  GCD
//
//  Created by apple on 13/03/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController1.h"
#import "GCDTimer.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[GCDTimer instance] startTimer:10 block:^{
//        NSLog(@"%@",[NSThread currentThread]);
//    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self groupGCD];
}


- (void)groupGCD {
    
    dispatch_group_t group = dispatch_group_create(); // 创建组
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_queue_t queue = dispatch_queue_create("11", DISPATCH_QUEUE_SERIAL);

    
    // 一定要注意
    // enter 和 leave 必须成对出现，否则不会执行 notify方法
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        sleep(3);
        NSLog(@"111=%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        sleep(3);
        NSLog(@"222=%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        sleep(3);
        NSLog(@"333=%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    // 所有组任务完成之后才会执行这个notify方法
    dispatch_group_notify(group, queue, ^{
        NSLog(@"所有任务执行完成=%@",[NSThread currentThread]);
    });
}



@end
