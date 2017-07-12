//
//  WebViewController.h
//  jjw
//
//  Created by ylc on 2017/7/12.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property(nonatomic, strong) NSString *url;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end
