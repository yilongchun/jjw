//
//  TeacherHomeViewController.h
//  jjw
//
//  Created by ylc on 2017/4/16.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherHomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSString *teacherId;

@end
