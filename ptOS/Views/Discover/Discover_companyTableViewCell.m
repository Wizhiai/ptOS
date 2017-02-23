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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(80, 60);
    layout.minimumLineSpacing = 10;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    [self.disPlayCollectionView setCollectionViewLayout:layout];
    self.disPlayCollectionView.dataSource =  self;
    self.disPlayCollectionView.delegate = self;
    self.disPlayCollectionView.showsHorizontalScrollIndicator = NO;
    [self.disPlayCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    if(indexPath.row>5){
        cell.backgroundColor  = [UIColor whiteColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"hhhh");
}

    


@end
