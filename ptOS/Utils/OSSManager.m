//
//  OSSManager.m
//  lxt
//
//  Created by 周瑞 on 16/7/16.
//  Copyright © 2016年 SM. All rights reserved.
//

#import "OSSManager.h"
#import "GlobalData.h"
#import "SVProgressHUD.h"





OSSClient *client;
@implementation OSSManager

static OSSManager *manager = nil;

+ (OSSManager *)sharedManager {
    if (manager == nil) {
        manager = [[self alloc]init];
    }
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initOSSClientWithEndPoint:@"http://oss-cn-shanghai.aliyuncs.com"];
    }
    return self;
}

- (void)initOSSClientWithEndPoint:(NSString *)endPoint{
    
//    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
//        // 构造请求访问您的业务server
//        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"getOSSToken?bucketName=bd-header"];
//        NSURL * url = [NSURL URLWithString:urlString];
//        NSURLRequest * request = [NSURLRequest requestWithURL:url];
//        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
//        NSURLSession * session = [NSURLSession sharedSession];
//        
//        // 发送请求
//        NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
//                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                        if (error) {
//                                                            [tcs setError:error];
//                                                            return;
//                                                        }
//                                                        [tcs setResult:data];
//                                                    }];
//        [sessionTask resume];
//        
//        // 需要阻塞等待请求返回
//        [tcs.task waitUntilFinished];
//        
//        // 解析结果
//        if (tcs.task.error) {
//            NSLog(@"get token error: %@", tcs.task.error);
//            return nil;
//        } else {
//            // 返回数据是json格式，需要解析得到token的各个字段
//            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
//                                                                    options:kNilOptions
//                                                                      error:nil];
//            NSDictionary *dic = object[@"data"];
//            OSSFederationToken * token = [OSSFederationToken new];
//            token.tAccessKey = [dic objectForKey:@"AccessKeyId"];
//            token.tSecretKey = [dic objectForKey:@"AccessKeySecret"];
//            token.tToken = [dic objectForKey:@"SecurityToken"];
//            token.expirationTimeInGMTFormat = [dic objectForKey:@"Expiration"];
//            NSLog(@"get token: %@", token);
//            return token;
//        }
//    }];
//    client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential];
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"LTAIa5LV30aGeTNB" secretKey:@"XDvjqc0UuP5iJSybqCLwgFaCjbzMb1"];
    
    client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential];
}

// 异步上传
- (void)uploadObjectAsyncWithData:(NSData *)data andFileName:(NSString *)name andBDName:(NSString *)bdName andIsSuccess:(OSSBlock)block andProgressBlock:(ProgressBlock)progressBlock {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    
    // required fields
    put.bucketName = bdName;
    put.objectKey = name;

    put.uploadingData = data;

    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        CGFloat n = totalByteSent * 1.0 / (totalBytesExpectedToSend * 1.0);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD showProgress:n];
        });
        
        progressBlock(bytesSent,totalByteSent,totalBytesExpectedToSend);
        
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", put.objectKey);
        BOOL isSuccess;
        if (!task.error) {
            [SVProgressHUD dismiss];
            NSLog(@"upload object success!");
            isSuccess = YES;
            block(isSuccess,nil);
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            [SVProgressHUD dismiss];
//             [SVProgressHUD showErrorWithStatus:@"上传失败"];
            isSuccess = NO;
            block(isSuccess,nil);
        }
        return nil;
    }];
}


//异步下载
- (void)downloadObjectAsyncWithFileName:(NSString *)fileName andBDName:(NSString *)bdName andGetImage:(OSSBlock)block {
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = bdName;
    request.objectKey = fileName;
    
    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    
    OSSTask * getTask = [client getObject:request];
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"download object success!");
            OSSGetObjectResult * getResult = task.result;
            
            NSLog(@"download dota length: %lu", [getResult.downloadedData length]);
            BOOL isSuccess;
            if (getResult.downloadedData != nil) {
                isSuccess = YES;
                UIImage *image = [UIImage imageWithData:getResult.downloadedData];
                block(isSuccess,image);
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"headerImage_now" object:nil];
            }else {
                isSuccess = NO;
                block(isSuccess,nil);
            }
        } else {
            NSLog(@"download object failed, error: %@" ,task.error);
        }
        return nil;
    }];
}

@end
