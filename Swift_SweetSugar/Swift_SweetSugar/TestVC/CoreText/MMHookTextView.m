//
//  MMHookTextView.m
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/3/1.
//  Copyright © 2023 Mumu. All rights reserved.
//

#import "MMHookTextView.h"
#import "ObjcUtil.h"

bool _objc_rootIsDeallocating(id _Nonnull obj);

@implementation MMHookTextView

@end

@implementation UITouch (FixCrashOnInputKeyboard)

static BOOL (*originalImpl)(id, SEL, UIResponder*, UIResponder*, UIEvent* ) = nil;

- (BOOL)_wantsForwardingFromResponder:(UIResponder *)arg1 toNextResponder:(UIResponder *)arg2 withEvent:(UIEvent *)arg3 {
    NSString* responderClassName = NSStringFromClass([arg2 class]);
    if ([responderClassName isEqualToString:@"_UIRemoteInputViewController"]) {
        if (_objc_rootIsDeallocating(arg2)) {
            NSLog(@"BingGo a deallocating object ...%@", responderClassName);
            return true;
        }
    }
    
    BOOL retVal = FALSE;
    if (originalImpl == nil) {
        ObjcSeeker *seeker = [[ObjcSeeker alloc] init];
        seeker.seekSkipCount = 1;
        seeker.isSeekBackward = FALSE;
        seeker.seekType = ObjcSeekerTypeInstance;
        [seeker seekOriginalMethod:self selector:_cmd];
        originalImpl = (BOOL (*)(id, SEL, UIResponder*, UIResponder*, UIEvent* ))seeker.impl;
    }
    
    if (originalImpl != nil) {
        retVal = originalImpl(self, _cmd, arg1, arg2, arg3);
    }
    return retVal;
}
@end
