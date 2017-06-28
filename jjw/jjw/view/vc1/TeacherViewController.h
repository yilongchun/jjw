//
//  TeacherViewController.h
//  jjw
//
//  Created by ylc on 2017/5/26.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (strong, nonatomic) NSString *top_search_key;

@end
