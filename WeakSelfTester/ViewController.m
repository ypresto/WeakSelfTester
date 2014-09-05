//
//  ViewController.m
//  WeakSelfTester
//
//  Created by 田中 裕也 on 2014/09/05.
//  Copyright (c) 2014年 Yuya Tanaka. All rights reserved.
//

#import "ViewController.h"
#import "FoobarManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelForSelf;
@property (weak, nonatomic) IBOutlet UILabel *labelForWeakSelf;
@property (weak, nonatomic) IBOutlet UILabel *labelForWeakSelfAndSingleton;
@property (strong, nonatomic) FoobarManager *foobarManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.foobarManager = [FoobarManager new];
}

- (IBAction)onRunTestTapped:(id)sender {
    _labelForSelf.text = @"pending...";
    _labelForWeakSelf.text = @"pending...";
    _labelForWeakSelfAndSingleton.text = @"pending...";
    [self getInBackgroundWithSelf];
    [self getInBackgroundWithWeakSelf];
    [self getInBackgroundWithWeakSelfAndSingletonManager];
}

- (void)renderFoobarsForSelf:(NSArray *)foobars {
    if (foobars) {
        _labelForSelf.text = @"rendered!";
    } else {
        _labelForSelf.text = @"oops... got nil...";
    }
}

- (void)renderFoobarsForWeakSelf:(NSArray *)foobars {
    if (foobars) {
        _labelForWeakSelf.text = @"rendered!";
    } else {
        _labelForWeakSelf.text = @"oops... got nil...";
    }
}

- (void)renderFoobarsForWeakSelfAndSingleton:(NSArray *)foobars {
    if (foobars) {
        _labelForWeakSelfAndSingleton.text = @"rendered!";
    } else {
        _labelForWeakSelfAndSingleton.text = @"oops... got nil...";
    }
}

- (void)getInBackgroundWithSelf {
    [[FoobarManager new] fetchAsyncStrongWithBlock:^(NSArray *foobars) {
        [self renderFoobarsForSelf:foobars];
    }];
}

- (void)getInBackgroundWithWeakSelf {
    [[FoobarManager new] fetchAsyncWeakWithBlock:^(NSArray *foobars) {
        [self renderFoobarsForWeakSelf:foobars];
    }];
}

- (void)getInBackgroundWithWeakSelfAndSingletonManager {
    [self.foobarManager fetchAsyncWeakWithBlock:^(NSArray *foobars) {
        [self renderFoobarsForWeakSelfAndSingleton:foobars];
    }];
}

@end
