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
@end
