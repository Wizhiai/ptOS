//
//  QZ_JobSearchApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "QZ_JobSearchApi.h"
#import "QZ_JobModel.h"

@implementation QZ_JobSearchApi

{
    NSString *_page;
    NSString *_sort;
    NSString *_coordinate;
    NSString *_keyword;
}
- (id) initWithPage:(NSString *)page withSort:(NSString *)sort withKeyword:(NSString *)keyword withCoordinate:(NSString *)coordinate {
    self = [super init];
    if (self) {
        _page = page;
        _sort = sort;
        _coordinate = coordinate;
        _keyword = keyword;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"getQZZWSearchList";
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setCustomString:_page forKey:@"page"];
    [argument setCustomString:_sort forKey:@"sort"];
    [argument setCustomString:_coordinate forKey:@"coordinate"];
    [argument setCustomString:_keyword forKey:@"keyword"];
    return argument;
}

- (NSArray *)getJobSearchList {
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
