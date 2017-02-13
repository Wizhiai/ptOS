//
//  QZ_JobListApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/20.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface QZ_JobListApi : BaseNetApi

- (id) initWithPage:(NSString *)page withSort:(NSString *)sort withCoordinate:(NSString *)coordinate;

- (NSArray *)getJobsList;


@end
