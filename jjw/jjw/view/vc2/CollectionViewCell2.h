//
//  CollectionViewCell2.h
//  jjw
//
//  Created by Stephen Chin on 2017/4/1.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell2 : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lessionNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *playTimesLabel;

@end
