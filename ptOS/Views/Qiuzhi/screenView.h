//
//  screenView.h
//  ptOS
//
//  Created by 吕康 on 17/2/13.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface screenView : BaseView
- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)string;

//筛选条件数组
@property (strong , nonatomic)NSMutableArray *conditionArr;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end
