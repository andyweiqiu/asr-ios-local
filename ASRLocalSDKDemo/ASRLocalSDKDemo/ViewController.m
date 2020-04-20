//
//  ViewController.m
//  ASRLocalSDKDemo
//
//  Created by 邱威 on 2019/2/25.
//  Copyright © 2019 qiuwei. All rights reserved.
//

#import "ViewController.h"
#import "EduLocalSpeechRecognizer.h"
#import "EduLocalTranscription.h"

@interface ViewController ()

@property (nonatomic, strong) EduLocalSpeechRecognizer *speechRecognizer;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UITextView *resultTV;
@property (weak, nonatomic) IBOutlet UITextView *logTV;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *tmpDataSource;

@property (nonatomic, copy) NSString *logText;

@property (nonatomic, assign) BOOL isRecognitionFinal;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.startButton.layer.cornerRadius = 60;
    self.startButton.layer.masksToBounds = YES;

    self.logText = @"";

    self.speechRecognizer = [[EduLocalSpeechRecognizer alloc] init];
}

- (IBAction)startButtonClicked:(id)sender {

    self.logText = @"";
    self.logTV.text = self.logText;

//    self.speechRecognizer.openVad = NO;
    [self.startButton setEnabled:NO];
    [self.startButton setTitle:@"正在识别" forState:UIControlStateDisabled];

    self.logText = [NSString stringWithFormat:@"%@\n【%@】 开始语音识别", self.logText, [self getDate]];
    self.logTV.text = self.logText;

    self.isRecognitionFinal = NO;

    __weak __typeof(self) weakSelf = self;

    [self.speechRecognizer startRecognizerWithResultHandler:^(EduLocalSpeechRecognitionResult * _Nullable result, EduLocalSpeechError * _Nonnull error, BOOL final) {

            dispatch_async(dispatch_get_main_queue(), ^{
                if (error.errorCode == EduLocalSpeechErrorCodeError) {
                    NSLog(@"%@", error.errorMessage);
                    weakSelf.resultTV.text = [NSString stringWithFormat:@"【error: %@】", error.errorMessage];
                    [weakSelf.startButton setTitle:@"开始识别" forState:0];
                    [weakSelf.startButton setEnabled:YES];
                    return ;
                }

                if (final) {
                    weakSelf.logText = [NSString stringWithFormat:@"%@\n【%@】 **最终结果**：%@\n", weakSelf.logText, [weakSelf getDate], [result.bestTranscription.formattedString lowercaseString]];
                    weakSelf.logText = [NSString stringWithFormat:@"%@\n【%@】 语音识别结束", weakSelf.logText, [weakSelf getDate]];
                    weakSelf.logText = [NSString stringWithFormat:@"%@\n=========================分割线=======================\n", weakSelf.logText];

                    weakSelf.logTV.text = weakSelf.logText;

    //                weakSelf.responseTimeLabel.text = [NSString stringWithFormat:@"%.2f", result.endSpeechToFinalResultTime];
                    [weakSelf.startButton setTitle:@"开始识别" forState:0];
                    [weakSelf.startButton setEnabled:YES];

                    if (!self.isRecognitionFinal) {
    //                    NSString *target = [[[self.targetTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@" "] lastObject];
    //                    float score = [weakSelf getSocre2:target trans:result.transcriptions];
    //                    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f", score];
                    }

                } else {
                    weakSelf.logText = [NSString stringWithFormat:@"%@\n【%@】 部分结果：%@\n", weakSelf.logText, [weakSelf getDate], [result.bestTranscription.formattedString lowercaseString]];
                    weakSelf.logTV.text = weakSelf.logText;
                    [weakSelf.startButton setEnabled:NO];

                    if (!self.isRecognitionFinal) {
    //                    NSString *target = [[[self.targetTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@" "] lastObject];
    //                    BOOL flag = [self has:target trans:@[result.bestTranscription]];
    //                    if (flag) {
    //                        weakSelf.logText = [NSString stringWithFormat:@"%@\n【%@】 中间结果已匹配到\n", weakSelf.logText, [self getDate]];
    //                        weakSelf.logTV.text = weakSelf.logText;
    //
    //                        weakSelf.isRecognitionFinal = YES;
    ////                        weakSelf.scoreLabel.text = @"5.0";
    //                    }
                    }
                }
                weakSelf.resultTV.text = [result.bestTranscription.formattedString lowercaseString];
            });

        }];

        self.speechRecognizer.logHandler = ^(NSString * _Nonnull log) {
            weakSelf.logText = [NSString stringWithFormat:@"%@\n【%@】 %@", weakSelf.logText, [weakSelf getDate], log];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.logTV.text = weakSelf.logText;
            });
        };

}

- (IBAction)clearButtonClicked:(id)sender {
    self.logText = @"";
    self.logTV.text = self.logText;
}

- (NSString *)getDate {
    NSDate *date= [NSDate date];

    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];

    NSString *dateStr;
    dateStr=[formater stringFromDate:date];

    return dateStr;
}

#pragma mark - WorkerDelegate

- (void)onFullFinal:(NSString *)result {
    NSLog(@"full: %@", result);
}

@end
