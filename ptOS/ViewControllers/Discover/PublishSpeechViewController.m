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
#import "UITextView+JKPlaceHolder.h"
#import "UITextView+JKSelect.h"
#import "OSSManager.h"

@interface PublishSpeechViewController ()<AJPhotoPickerProtocol,AJPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    BOOL _hasPic;
}



@property (nonatomic,strong)FX_PublishTZApi *publishApi;

@end

@implementation PublishSpeechViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布圈子";
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [NotificationCenter removeObserver:self];
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
    
//    self.addressLabel.text = [GlobalData sharedInstance].location;
    
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
//    if (self.swich.isOn) {
//        isQYQ = @"1";
//    }
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


//- (IBAction)addressBtn:(id)sender {
//    self.addressLabel.text = [GlobalData sharedInstance].location;
//}













@end
