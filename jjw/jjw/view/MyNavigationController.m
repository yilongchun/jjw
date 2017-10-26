//
//  MyNavigationController.m
//  jjw
//
//  Created by ylc on 2017/9/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "MyNavigationController.h"
#import "ClassDetailViewController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return NO;
}

//// 哪些页面支持自动转屏
//- (BOOL)shouldAutorotate{
//    UIViewController *topVC = self.navigationController.topViewController;
//    if ([topVC isMemberOfClass:[ClassDetailViewController class]]) {
//
//        BOOL isPresented = ((ClassDetailViewController *)topVC).isPresented;
//
//        DLog(@"yes %d",isPresented);
//        return isPresented;
//    }else{
//        DLog(@"no");
//        return NO;
//    }
//    
//    
//}
//
//// 支持哪些转屏方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    if ( [self.navigationController.topViewController isMemberOfClass:[ClassDetailViewController class]]) {
//        DLog(@"全屏");
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }else { // 其他页面支持转屏方向
//        DLog(@"竖屏");
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}

//// 哪些页面支持自动转屏
//- (BOOL)shouldAutorotate{
////    UIViewController *vc = self.viewControllers[self.selectedIndex];
////    if ([vc isMemberOfClass:[UINavigationController class]]) {
////        UIViewController *topVC = ((UINavigationController *)vc).topViewController;
////        if ([topVC isMemberOfClass:[DetailViewController class]] || [topVC isMemberOfClass:[ClassDetailViewController class]]) {
////            return YES;
////        }
////    }
//    DLog(@"NO");
//    return NO;
//}
//
//// 支持哪些转屏方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
////    UIViewController *vc = self.viewControllers[self.selectedIndex];
////    if ([vc isMemberOfClass:[UINavigationController class]]){
////        UINavigationController *nav = (UINavigationController *)vc;
////        if ([nav.topViewController isMemberOfClass:[DetailViewController class]] || [nav.topViewController isMemberOfClass:[ClassDetailViewController class]]) {
////            return UIInterfaceOrientationMaskAllButUpsideDown;
////        }else { // 其他页面支持转屏方向
////            return UIInterfaceOrientationMaskPortrait;
////        }
////    }
//    DLog(@"UIInterfaceOrientationMaskPortrait");
//    return UIInterfaceOrientationMaskPortrait;
//}

@end
