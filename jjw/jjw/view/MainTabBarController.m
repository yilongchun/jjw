//
//  MainTabBarController.m
//  jjw
//
//  Created by Stephen Chin on 2017/3/30.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "MainTabBarController.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "ViewController4.h"
#import "ViewController5.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ViewController1 *vc1 = [ViewController1 new];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"b_ico_01"] imageWithRenderingMode:UIImageRenderingModeAutomatic] tag:1];
    vc1.tabBarItem = item1;
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    
    ViewController2 *vc2 = [ViewController2 new];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"课程" image:[[UIImage imageNamed:@"b_ico_02"] imageWithRenderingMode:UIImageRenderingModeAutomatic]tag:2];
    vc2.tabBarItem = item2;
    
    ViewController3 *vc3 = [ViewController3 new];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"点播" image:[[UIImage imageNamed:@"b_ico_03"] imageWithRenderingMode:UIImageRenderingModeAutomatic]tag:3];
    vc3.tabBarItem = item3;
    
    ViewController4 *vc4 = [ViewController4 new];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"搜题" image:[[UIImage imageNamed:@"b_ico_04"] imageWithRenderingMode:UIImageRenderingModeAutomatic]tag:4];
    vc4.tabBarItem = item4;
    
    ViewController5 *vc5 = [ViewController5 new];
    UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"b_ico_05"] imageWithRenderingMode:UIImageRenderingModeAutomatic]tag:5];
    vc5.tabBarItem = item5;
    
    self.viewControllers = @[nc1,vc2,vc3,vc4,vc5];
//    self.tabBar.backgroundColor = [UIColor redColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTab:) name:@"setTab" object:nil];
}

- (void)setTab:(NSNotification *)text{
    NSLog(@"%@",text.userInfo);
    self.selectedIndex = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
