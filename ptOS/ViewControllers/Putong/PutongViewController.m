//
//  PutongViewController.m
//  ptOS
//
//  Created by 周瑞 on 16/8/30.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "PutongViewController.h"
#import "PT_QiuzhiViewController.h"
#import "AFHTTPRequestOperation.h"
#import "PT_MsgNumApi.h"
#import "PT_ClearMsgNumApi.h"
#import "PT_MsgNumModel.h"

@interface PutongViewController ()
@property (nonatomic,strong)PT_MsgNumApi *msgNumApi;
@property (nonatomic,strong)PT_ClearMsgNumApi *clearMsgNumApi;


@end

@implementation PutongViewController



#pragma mark - lifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"扑通"];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self msgNumApiNet];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - customFuncs
- (void)initUI {
    ZRViewRadius(self.msgNumLabel, 11);
    ZRViewRadius(self.bottomView1, 10);
    self.timeLabel.hidden = YES;
    self.detailLabel.hidden = YES;
    self.msgNumLabel.hidden = YES;
}

- (IBAction)QZBtnPress:(id)sender {
    if (!isValidStr([GlobalData sharedInstance].selfInfo.sessionId))
    {
        [self presentLoginCtrl];
        return;
    }
    [self clearMsgNumApiNet];
    PT_QiuzhiViewController *ctrl = [[PT_QiuzhiViewController alloc]init];
    [self.navigationController pushViewController:ctrl animated:YES];
}


#pragma mark - NetworkApis 
- (void)msgNumApiNet {
    if(self.msgNumApi && !self.msgNumApi.requestOperation.isFinished)
    {
        [self.msgNumApi stop];
    }
    
    self.msgNumApi.sessionDelegate = self;
    self.msgNumApi = [[PT_MsgNumApi alloc]init];
    self.msgNumApi.netLoadingDelegate = self;
    [self.msgNumApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        PT_MsgNumApi *result = (PT_MsgNumApi *)request;
        if(result.isCorrectResult)
        {
            self.timeLabel.hidden = NO;
            self.detailLabel.hidden = NO;
            self.msgNumLabel.hidden = NO;
            PT_MsgNumModel *model = [result getMsgNumModel];
            self.detailLabel.text = model.content;
            if ([model.content isEqualToString:@""]) {
                self.detailLabel.text = @"暂无新的消息";
            }
            self.timeLabel.text = model.time;
            
            self.msgNumLabel.text = model.number;
            if ([model.number isEqualToString:@"0"]) {
                self.msgNumLabel.hidden = YES;
            }
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (void)clearMsgNumApiNet {
    if(self.clearMsgNumApi && !self.clearMsgNumApi.requestOperation.isFinished)
    {
        [self.clearMsgNumApi stop];
    }
    
    self.clearMsgNumApi.sessionDelegate = self;
    self.clearMsgNumApi = [[PT_ClearMsgNumApi alloc]init];
    self.clearMsgNumApi.netLoadingDelegate = self;
    [self.clearMsgNumApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        PT_ClearMsgNumApi *result = (PT_ClearMsgNumApi *)request;
        if(result.isCorrectResult)
        {
            
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - delegate


#pragma mark - lazyViews
@end
