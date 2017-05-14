//
//  PaidRecordTableViewCell.h
//  jjw
//
//  Created by ylc on 2017/5/10.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaidRecordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
