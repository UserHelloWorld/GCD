//
//  ViewController.m
//  GCD
//
//  Created by apple on 12/03/18.
//  Copyright © 2018年 apple. All rights reserved.
//


/*
 
 同步执行（sync）：
 同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行下一个任务。
 只能在当前线程中执行任务，不具备开启新线程的能力。
 
 
 异步执行（async）：
 异步添加任务到指定的队列中，它不会做任何等待，可以继续执行任务。
 可以在新的线程中执行任务，具备开启新线程的能力。

 并发队列只有值异步函数下才能触发并发功能
 
 异步函数有开启新线程的能力，在串行队列只能开启一条线程，并发队列开启多条
 
*/


#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) dispatch_queue_t queue;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self syncSerial];
    self.queue = dispatch_queue_create("abc", DISPATCH_QUEUE_SERIAL);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self asyncConcurrent];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start");
        dispatch_async(self.queue, ^{
            for (int i = 0; i < 5; i++) {
                NSLog(@"hhh %d %@",i,[NSThread currentThread]);
            }
        });
        [self test];
        dispatch_async(self.queue, ^{
            for (int i = 0; i < 5; i++) {
                NSLog(@"sss %d %@",i,[NSThread currentThread]);
            }
        });
        [self test1];
        [self test2];
        for (int i = 0; i < 100; i++) {
            NSLog(@"end");
        }
    });
}

/*
    fmdb 实现思路
   开启一个串行队列， 只要操作数据，添加一个任务进来；因为串行队列是同步执行，不管是哪个线程的任务，只要添加在这个队列，都是执行完一个任务再执行下一个任务。
 */

- (void)test {
    dispatch_async(self.queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"aaa %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(self.queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"bbb %d %@",i,[NSThread currentThread]);
        }
    });
    
    
}

- (void)test1 {
    dispatch_async(self.queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"ccc %d %@",i,[NSThread currentThread]);
        }
    });
}

- (void)test2 {
    dispatch_async(self.queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"ddd %d %@",i,[NSThread currentThread]);
        }
    });
}

// 同步主队列
- (void)mainQueueSync {
    dispatch_sync(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"aaa %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_sync(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"bbb %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_sync(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"ccc %d %@",i,[NSThread currentThread]);
        }
    });
    
    // 死掉  mainQueueSync走到同步主队列这个地方，由于mainQueueSync还没走完，里面的同步主队列在等mainQueueSync走完，mainQueueSync等里面的同步主队列走完，形成了相互等待，互相锁死
}

// 异步主队列
- (void)mainQueueAsync {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"aaa %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"bbb %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"ccc %d %@",i,[NSThread currentThread]);
        }
    });
    
    // 同步串行执行 主线程中完成
}

// 同步串行队列
- (void)syncSerial {
    dispatch_queue_t queue = dispatch_queue_create("abc", DISPATCH_QUEUE_SERIAL);
    NSLog(@"start");
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"aaa %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"bbb %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"ccc %d %@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"end");
    // 打印的结果为 从上至下依次打印 主线程 立即执行
}

/** 异步串行 */
- (void)asyncSerial {
    dispatch_queue_t queue = dispatch_queue_create("abc",DISPATCH_QUEUE_SERIAL);
    NSLog(@"start");
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"aaa %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"bbb %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"ccc %d %@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"end");
    // 只开启了一个新线程，从上至下串行执行 , 没有立即执行
}

// 同步并行
- (void)syncConcurrent {
    dispatch_queue_t queue = dispatch_queue_create("abc",DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"start");
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"aaa %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"bbb %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"ccc %d %@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"end");
    // 从上至下串行执行（立即执行），主线程中执行
}

// 异步并发
- (void)asyncConcurrent {
    dispatch_queue_t queue = dispatch_queue_create("abc", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"start");
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"aaa %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"bbb %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"ccc %d %@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"end");
    // 开启了新线程 并发的执行，等待了，没有立即执行
}


@end
