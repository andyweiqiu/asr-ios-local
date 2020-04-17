//
//  EduLocalSpeechRecognitionResult.h
//  kaldi-ios-local-demo
//
//  Created by 邱威 on 2019/2/27.
//  Copyright © 2019 qiuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EduLocalTranscription;

typedef NS_ENUM(NSInteger,EduLocalSpeechErrorCode) {
    EduLocalSpeechErrorCodeOK = 0,   // 正常
    EduLocalSpeechErrorCodeError = 1 // 错误
};

//typedef NS_ENUM(NSInteger,EduLocalSpeechStatusCode) {
//    EduLocalSpeechStatusCodeOK = 0,          // 正常返回
//    EduLocalSpeechStatusCodeSERTimeout = 1,  // 服务器超时返回
//    EduLocalSpeechStatusCodeSDKError = 2,    // SDK内部异常返回
//    EduLocalSpeechStatusCodeSERError = 3     // 服务器数据异常返回
//};

@interface EduLocalSpeechError : NSObject

// 错误码
@property (nonatomic, assign) EduLocalSpeechErrorCode errorCode;
// 错误信息
@property (nonatomic, copy) NSString *errorMessage;
// 状态码（返回的结果正常返回或者是服务器超时返回默认结果格式，不包含识别结果文本）
//@property (nonatomic, assign) EduLocalSpeechStatusCode statusCode;

@end

@interface EduLocalSpeechRecognitionResult : NSObject

@property (nullable, nonatomic, readonly, strong) EduLocalTranscription *bestTranscription;

// Hypotheses for possible transcriptions, sorted in decending order of confidence (more likely first)
@property (nonatomic, readonly, strong) NSArray<EduLocalTranscription *> *transcriptions;

// True if the hypotheses will not change; speech processing is complete.
@property (nonatomic, readonly, getter=isFinal) BOOL final;

// The response time, from no audio input to final result
@property (nonatomic, readonly, assign) NSTimeInterval endSpeechToFinalResultTime;

@end

NS_ASSUME_NONNULL_END
