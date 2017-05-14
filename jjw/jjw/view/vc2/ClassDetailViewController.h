//
//  ClassDetailViewController.h
//  jjw
//
//  Created by ylc on 2017/4/11.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, strong) NSDictionary *info;

@end
