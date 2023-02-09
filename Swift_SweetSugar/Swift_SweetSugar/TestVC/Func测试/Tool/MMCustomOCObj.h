//
//  MMCustomOCObj.h
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/2/25.
//  Copyright © 2022 Mumu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMCustomOCObj : NSObject
@property (nonatomic, strong) NSMutableArray *words;

- (void)receiveError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
