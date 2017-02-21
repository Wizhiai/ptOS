//
//  PublishSpeechViewController.m
//  ptOS
//
//  Created by 吕康 on 17/2/20.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "PublishSpeechViewController.h"

#import "AFHTTPRequestOperation.h"
#import "FX_PublishTZApi.h"
#import "AJPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AJPhotoBrowserViewController.h"
#import "OSSManager.h"

@interface PublishSpeechViewController ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate>


@property (nonatomic,strong)FX_PublishTZApi *publishApi;

//录音存储路径
@property (nonatomic, strong)NSURL *tmpFile;
//录音
@property (nonatomic, strong)AVAudioRecorder *recorder;
//播放
@property (nonatomic, strong)AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;

@property (nonatomic, strong)AVAudioSession * audioSession;

@property (nonatomic, strong)UILongPressGestureRecognizer *longPressGesture;
@end

@implementation PublishSpeechViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布圈子";
    _isRecoding = NO;
    [self initUI];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
}

#pragma mark - customFuncs



- (void)initUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"    发表" forState:UIControlStateNormal];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //录音按钮
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(startRecord:)];
    [self.record addGestureRecognizer:self.longPressGesture];
    
//    [self.record addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];
    
    [self.record addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchDragExit];
    
    [self.playBtn addTarget:self action:@selector(palyRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    self.locationLabel.text = [GlobalData sharedInstance].location; //显示当前定位
    
}

//录音
- (void)startRecord:(UIButton *)sender {
    
    self.audioSession = [AVAudioSession sharedInstance];

        _isRecoding= YES;
        [self.audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        [self.audioSession setActive:YES error:nil];
        [self.record setTitle:@"松开停止" forState:UIControlStateNormal];
        
        NSDictionary *setting = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithFloat: 44100.0],AVSampleRateKey, [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey, [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey, [NSNumber numberWithInt: 2], AVNumberOfChannelsKey, [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey, [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,nil]; //然后直接把文件保存成.wav就好了
        _tmpFile = [NSURL fileURLWithPath:
                   [NSTemporaryDirectory() stringByAppendingPathComponent:
                    [NSString stringWithFormat: @"%@.%@",
                     @"kanglv",
                     @"caf"]]];
        self.recorder = [[AVAudioRecorder alloc] initWithURL:_tmpFile settings:setting error:nil];
        [ self.recorder setDelegate:self];
        [ self.recorder prepareToRecord];
        [ self.recorder record];
    
}

//停止录音后

- (void)endRecord:(UIButton *)sender {
   
    _isRecoding = NO;
    [self.audioSession setActive:NO error:nil];
    [ self.recorder stop];
    [self.record setTitle:@"按住说两句" forState:UIControlStateNormal];
    
}


//播放录音

- (void)palyRecord:(UIButton *)sender {
//    [self.record setTitle:@"按住说两句" forState:UIControlStateNormal];
    
    NSError *error;
    self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:_tmpFile
                                                      error:&error];
    
    self.player.volume=1;
    if (error) {
        NSLog(@"error:%@",[error description]);
        return;
    }
    //准备播放
    [self.player prepareToPlay];
    //播放
    [self.player play];
}

- (void)next {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    
    
   
}

- (void)publishApiNetWithImgUrl:(NSString *)url {
    
    if(self.publishApi&& !self.publishApi.requestOperation.isFinished)
    {
        [self.publishApi stop];
    }
    self.publishApi.sessionDelegate = self;
    NSString *isQYQ = @"0";
    if (self.switchBtn.isOn) {
        isQYQ = @"1";
    }
    [self.publishApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        FX_PublishTZApi *result = (FX_PublishTZApi *)request;
        if(result.isCorrectResult)
        {
            //            [XHToast showCenterWithText:@"发表成功"];
            [NotificationCenter postNotificationName:@"publish_refresh" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}














@end
