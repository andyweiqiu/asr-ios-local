//
//  Worker.h
//
//  Created by 邱威 on 2019/2/17.
//  Copyright © 2019 qiuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WorkerDelegate <NSObject>

@optional
- (void)onPartial:(NSString *)result;
- (void)onFinal:(NSString *)result;
- (void)onFullFinal:(NSString *)result;

@end

typedef void (^ResultHandler) (NSString *result, BOOL isFinal, NSTimeInterval time);

@interface Worker : NSObject

@property (nonatomic, weak) id<WorkerDelegate> delegate;

@property (nonatomic, strong) ResultHandler resultHandler;

- (void)start;

@end

NS_ASSUME_NONNULL_END
