//
//  ViewController.m
//  ASRLocalSDKDemo
//
//  Created by 邱威 on 2019/2/25.
//  Copyright © 2019 qiuwei. All rights reserved.
//

#import "ViewController.h"
#import "Worker.h"

@interface ViewController ()<WorkerDelegate>

@property (nonatomic, strong) Worker *worker;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UITextView *resultTV;
@property (weak, nonatomic) IBOutlet UITextField *targetTF;
@property (weak, nonatomic) IBOutlet UILabel *responseTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *logTV;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *tmpDataSource;

@property (nonatomic, copy) NSString *logText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.startButton.layer.cornerRadius = 60;
    self.startButton.layer.masksToBounds = YES;

    self.logText = @"";

    self.tmpDataSource = [NSMutableArray arrayWithArray:self.dataSource];

    NSString *target = self.tmpDataSource[0];
    self.targetTF.text = target;
}

- (IBAction)startButtonClicked:(id)sender {
    self.worker = [[Worker alloc] init];
    self.worker.delegate = self;
    [self.worker start];

    __weak __typeof(self) weakSelf = self;

    [self.startButton setEnabled:NO];
    [self.startButton setTitle:@"正在识别" forState:UIControlStateDisabled];

    self.logText = [NSString stringWithFormat:@"%@\n【%@】 开始语音识别", self.logText, [self getDate]];
    self.logTV.text = self.logText;

    self.worker.resultHandler = ^(NSString * _Nonnull result, BOOL isFinal, NSTimeInterval time) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isFinal) {
                weakSelf.logText = [NSString stringWithFormat:@"%@\n【%@】 **最终结果**：%@\n", weakSelf.logText, [weakSelf getDate], result];
                weakSelf.logText = [NSString stringWithFormat:@"%@\n【%@】 语音识别结束", weakSelf.logText, [weakSelf getDate]];
                weakSelf.logText = [NSString stringWithFormat:@"%@\n=========================分割线=======================\n", weakSelf.logText];

                weakSelf.logTV.text = weakSelf.logText;

                weakSelf.responseTimeLabel.text = [NSString stringWithFormat:@"%.2f", time];
                [weakSelf.startButton setTitle:@"开始识别" forState:0];
                [weakSelf.startButton setEnabled:YES];
            } else {
                weakSelf.logText = [NSString stringWithFormat:@"%@\n【%@】 部分结果：%@\n", weakSelf.logText, [weakSelf getDate], result];
                weakSelf.logTV.text = weakSelf.logText;
                [weakSelf.startButton setEnabled:NO];
            }
            weakSelf.resultTV.text = [result lowercaseString];
        });
    };
}


- (IBAction)nextButtonClicked:(UIButton *)sender {
    [self.tmpDataSource removeObjectAtIndex:0];
    if (self.tmpDataSource.count > 0) {
        NSString *target = self.tmpDataSource[0];
        self.targetTF.text = target;
    } else {
        sender.enabled = NO;
    }
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

- (NSArray *)dataSource {
    if (!_dataSource) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"word" ofType:@"plist"];
        NSArray *datas = [NSArray arrayWithContentsOfFile:path];

        _dataSource = datas;
    }

    return _dataSource;
}

#pragma mark - WorkerDelegate

- (void)onFullFinal:(NSString *)result {
    NSLog(@"full: %@", result);
}

@end
