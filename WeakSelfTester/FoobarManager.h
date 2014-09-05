//
//  FoobarManager.h
//  WeakSelfTester
//
//  Created by 田中 裕也 on 2014/09/05.
//  Copyright (c) 2014年 Yuya Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoobarManager : NSObject

- (void)fetchAsyncStrongWithBlock:(void (^)(NSArray *foobars))callback;
- (void)fetchAsyncWeakWithBlock:(void (^)(NSArray *foobars))callback;

@end
