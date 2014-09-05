WeakSelfTester
==============

Sample objective-c project to explain why use-weakSelf-for-every-block pattern is dangerous.

## weakSelf Pattern

In Objective-C ARC, block retains all variables referenced in its code.
This sometimes causes "retain cycle" i.e. memory leak.

```objective-c
self.callbackBlock = ^(id obj){
  [self render:obj];
}
```

Above code will make retain cycle among `self` and `callbackBlock`,
because they have strong references for each other.

To prevent this, weakSelf pattern is often used among many developpers.

```objective-c
__weak weakSelf = self
self.callbackBlock = ^(id obj){
  [weakSelf render:obj];
}
```

Above code will make strong reference from `self` to `callbackBlock`, but not to self.

## Why weakSelf can be dangerous?

For example, imagine model implementation which fetches data structure from RESTful API.
It perhaps accepts block, uses async fetch methods of HTTP client and returns immediately.
Uses weakSelf to call `parseResponse:` method.

```objective-c
// in FoobarManager

- (void)fetchAsyncWeakWithBlock:(void (^)(NSArray *foobars))callback {
    __weak typeof(self) weakSelf = self;

    // mimicking async fetch from server
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSArray *foobars = [strongSelf parseResponse:@{@"foo": @"bar"}];
        NSLog(@"weakSelf: %@", weakSelf);
        callback(foobars);
    });
}
```

Then, think about caller. You can thrown away after calling some methods of the model.
Instance of `FoobarManager` in below code will not be retained after `getInBackgroundWithWeakSelf` returns.

```objective-c
// in ViewController

- (void)getInBackgroundWithWeakSelf {
    [[FoobarManager new] fetchAsyncWeakWithBlock:^(NSArray *foobars) {
        [self renderFoobarsForWeakSelf:foobars];
    }];
}
```

Now, something bad has happened...
No one retaines `FoobarManager` instance, because `FoobarManager` uses weakSelf.

`__strong typeof(weakSelf) strongSelf = weakSelf; // nil!!`

http://stackoverflow.com/a/20032131/1474113

## What should I do then?

TODO
