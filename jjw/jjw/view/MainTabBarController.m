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
#import "NSObject+Blocks.h"
#import "DetailViewController.h"
#import "ClassDetailViewController.h"
#import "MyNavigationController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    ViewController1 *vc1 = [ViewController1 new];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"b_ico_01"] imageWithRenderingMode:UIImageRenderingModeAutomatic] tag:1];
    vc1.tabBarItem = item1;
    MyNavigationController *nc1 = [[MyNavigationController alloc] initWithRootViewController:vc1];
    
    
    ViewController2 *vc2 = [ViewController2 new];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"课程" image:[[UIImage imageNamed:@"b_ico_02"] imageWithRenderingMode:UIImageRenderingModeAutomatic]tag:2];
    vc2.tabBarItem = item2;
    MyNavigationController *nc2 = [[MyNavigationController alloc] initWithRootViewController:vc2];
    
    ViewController3 *vc3 = [ViewController3 new];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"点播" image:[[UIImage imageNamed:@"b_ico_03"] imageWithRenderingMode:UIImageRenderingModeAutomatic]tag:3];
    vc3.tabBarItem = item3;
    MyNavigationController *nc3 = [[MyNavigationController alloc] initWithRootViewController:vc3];
    
    ViewController4 *vc4 = [ViewController4 new];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"搜题" image:[[UIImage imageNamed:@"b_ico_04"] imageWithRenderingMode:UIImageRenderingModeAutomatic]tag:4];
    vc4.tabBarItem = item4;
    MyNavigationController *nc4 = [[MyNavigationController alloc] initWithRootViewController:vc4];
    
    ViewController5 *vc5 = [ViewController5 new];
    UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"b_ico_05"] imageWithRenderingMode:UIImageRenderingModeAutomatic]tag:5];
    vc5.tabBarItem = item5;
    MyNavigationController *nc5 = [[MyNavigationController alloc] initWithRootViewController:vc5];
    
    self.viewControllers = @[nc1,nc2,nc3,nc4,nc5];
//    self.tabBar.backgroundColor = [UIColor redColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTab:) name:@"setTab" object:nil];
}

- (void)setTab:(NSNotification *)text{
    NSLog(@"%@",text.userInfo);
    NSDictionary *info = [text userInfo];
    NSNumber *index = [info objectForKey:@"a"];
    self.selectedIndex = [index integerValue];
    
    NSString *searchValue = [info objectForKey:@"searchValue"];
    if (searchValue && ![searchValue isEqualToString:@""]) {
        NSNotification *notification =[NSNotification notificationWithName:@"searchClass" object:nil userInfo:@{@"searchValue":[info objectForKey:@"searchValue"]}];
        [self performBlock:^{
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } afterDelay:0.5];
        
    }
    NSDictionary *param = [info objectForKey:@"param"];
    if (param != nil) {
        NSNotification *notification =[NSNotification notificationWithName:@"bixiuClick" object:nil userInfo:@{@"param":param}];
        [self performBlock:^{
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } afterDelay:1];
    }
    NSDictionary *param2 = [info objectForKey:@"param2"];
    if (param2 != nil) {
        NSNotification *notification =[NSNotification notificationWithName:@"bixiuClick" object:nil userInfo:@{@"param2":param2}];
        [self performBlock:^{
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } afterDelay:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)shouldAutorotate{
//    return self.selectedViewController.shouldAutorotate;
//}

// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate{
    UIViewController *vc = self.viewControllers[self.selectedIndex];
    if ([vc isMemberOfClass:[MyNavigationController class]]) {
        UIViewController *topVC = ((UINavigationController *)vc).topViewController;
        if ([topVC isMemberOfClass:[DetailViewController class]] || [topVC isMemberOfClass:[ClassDetailViewController class]]) {
            
            BOOL isPresented = ((ClassDetailViewController *)topVC).isPresented;
            
            DLog(@"yes %d",isPresented);
            return isPresented;
        }
    }
    DLog(@"no");
    return NO;
}

// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIViewController *vc = self.viewControllers[self.selectedIndex];
    if ([vc isMemberOfClass:[MyNavigationController class]]){
        UINavigationController *nav = (UINavigationController *)vc;
        if ([nav.topViewController isMemberOfClass:[DetailViewController class]] || [nav.topViewController isMemberOfClass:[ClassDetailViewController class]]) {
            DLog(@"全屏");
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }else { // 其他页面支持转屏方向
            DLog(@"竖屏");
            return UIInterfaceOrientationMaskPortrait;
        }
    }
    DLog(@"竖屏");
    return UIInterfaceOrientationMaskPortrait;
}

@end
