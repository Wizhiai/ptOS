//
//  screenView.m
//  ptOS
//
//  Created by 吕康 on 17/2/13.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "screenView.h"
#import "JLSliderView.h"

@implementation screenView



- (void)awakeFromNib {
    [super awakeFromNib];
}


- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)string
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:nil options:nil] lastObject];
    if (self) {
        [self setFrame:frame];
        self.conditionArr = [NSMutableArray arrayWithObjects:@"15", nil];
        
        self.salary.text = @"(不限)";
        self.sliderView = [[JLSliderView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, 40) sliderType:JLSliderTypeCenter];
        
        [self addSubview:self.sliderView];
        
        
    }
    return self;
}

//用于转换数组中的信息
- (void)chooseBtnClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            break;
        case 7:
            break;
        case 8:
            break;
        case 9:
            break;
        case 10:
            break;
        case 11:
            break;
        case 12:
            break;
            
        default:
            break;
    }
}


//选择条件
- (IBAction)btnClicked:(UIButton *)sender {
    
    //点击后背景色改变
    if(sender.selected ){
        //将条件加入数组
        
           [self.conditionArr removeObject:[NSString stringWithFormat:@"%ld",sender.tag]];
         sender.backgroundColor = [UIColor whiteColor];
        sender.selected = NO;
    } else {
        //将筛选条件移出
         [self.conditionArr addObject:[NSString stringWithFormat:@"%ld",sender.tag]];
         sender.backgroundColor = [UIColor colorWithRed:112/255.0 green:124/255.0 blue:248/255.0 alpha:1];
       
        sender.selected = YES;
    }
}

//确定按钮呗点击
- (IBAction)sureBtnClicked:(id)sender {
    
    NSLog(@"1111hhhhhhh");
    NSLog(@"%@",self.conditionArr);
    //需要将所选条件拼接完整，具体看服务端借口规则
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.conditionArr,@"0", nil];
    //发一个通知，提示
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sure" object:self userInfo:conditionDic];
    
    
}


@end
