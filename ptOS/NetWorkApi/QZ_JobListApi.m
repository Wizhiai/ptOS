//
//  QZ_JobListApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/20.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_JobListApi.h"
#import "QZ_JobModel.h"
@implementation QZ_JobListApi
{
    NSString *_page;
    NSString *_sort;
    NSString *_coordinate;
}
- (id)initWithPage:(NSString *)page withSort:(NSString *)sort withCoordinate:(NSString *)coordinate {
    self = [super init];
    if (self) {
        _page = page;
        _sort = sort;
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getQZZWList";
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setCustomString:_page forKey:@"page"];
    [argument setCustomString:_sort forKey:@"sort"];
    [argument setCustomString:_coordinate forKey:@"coordinate"];
    return argument;
}

- (NSArray *)getJobsList {
    NSData *data= [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(dict)
    {
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [dataDict objectForKey:@"dataList"];
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dic in array)
            {
                QZ_JobModel *model = [[QZ_JobModel alloc]initWithDic:dic];
                [result addObject:model];
            }
            return result;
        }
    }
    return nil;
}



@end
