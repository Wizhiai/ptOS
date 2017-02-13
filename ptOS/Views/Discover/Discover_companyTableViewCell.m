//
//  Discover_companyTableViewCell.m
//  ptOS
//
//  Created by 周瑞 on 16/9/12.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "Discover_companyTableViewCell.h"

@implementation Discover_companyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.m_ImageView, 30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
