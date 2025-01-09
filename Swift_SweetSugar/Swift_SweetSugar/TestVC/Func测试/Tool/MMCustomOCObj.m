//
//  MMCustomOCObj.m
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/2/25.
//  Copyright © 2022 Mumu. All rights reserved.
//

#import "MMCustomOCObj.h"

@implementation MMCustomOCObj


- (void)receiveError:(NSError *)error {
    NSLog(@"error->%@",error);
}

- (void)asserttest {
    NSAssert(true, @"出错了");
//    NSAssert(false, @"出错了");

    NSLog(@"error->");

    [[NSAssertionHandler currentHandler] handleFailureInFunction:@"sdfsdf" file:@"sdfsdf" lineNumber:999 description:@"sdfs"];
}

- (void)callBlock {
    if (self.EmptyBlock) {
        self.EmptyBlock();
    }
}

- (NSArray *)createNSArray {
    NSArray *arr = @[@"1",@"2",@"3",@"4"];
    return arr;
}






- (void)test {
    NSLog(@"1");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"2");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"3");
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"4");
        });
        
        NSLog(@"5");
    });
    
    NSLog(@"6");
}


@end
