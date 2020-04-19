//
//  EduLocalSpeechRecognizer.h
//  kaldi-ios-local-demo
//
//  Created by 邱威 on 2019/2/27.
//  Copyright © 2019 qiuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EduLocalSpeechRecognitionResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface EduLocalSpeechRecognizer : NSObject

@property (nonatomic, assign) BOOL openVad;

@property (nonatomic, copy) void (^logHandler)(NSString *log);

- (void)startRecognizerWithResultHandler:(void (^)(EduLocalSpeechRecognitionResult* __nullable result, EduLocalSpeechError *error, BOOL final))resultHandler;

@end

NS_ASSUME_NONNULL_END
