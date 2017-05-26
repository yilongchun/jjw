//
//  TeacherCollectionViewCell.h
//  jjw
//
//  Created by ylc on 2017/5/26.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *education;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *weike;
@property (weak, nonatomic) IBOutlet UILabel *des;


@end
