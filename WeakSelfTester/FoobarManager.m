//
//  FoobarManager.m
//  WeakSelfTester
//
//  Created by 田中 裕也 on 2014/09/05.
//  Copyright (c) 2014年 Yuya Tanaka. All rights reserved.
//

#import "FoobarManager.h"

@implementation FoobarManager

- (void)fetchAsyncStrongWithBlock:(void (^)(NSArray *foobars))callback {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *foobars = [self parseResponse:@{@"foo": @"bar"}];
        NSLog(@"self: %@", self);
        callback(foobars);
    });
}

- (void)fetchAsyncWeakWithBlock:(void (^)(NSArray *foobars))callback {
    __weak typeof(self) weakSelf = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *foobars = [weakSelf parseResponse:@{@"foo": @"bar"}];
        NSLog(@"weakSelf: %@", weakSelf);
        callback(foobars);
    });
}

- (NSArray *)parseResponse:(id)response {
    return @[@"foo", @"bar"];
}

@end
