//
//  NewsDetailViewController.h
//  jjw
//
//  Created by ylc on 2017/5/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController

@property(nonatomic, strong) NSString *newsId;
@property(nonatomic,weak) IBOutlet UIWebView *myWebView;

@end
