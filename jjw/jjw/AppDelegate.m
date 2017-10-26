//
//  AppDelegate.m
//  jjw
//
//  Created by Stephen Chin on 2017/3/30.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "IQKeyboardManager.h"
#import "OpenShareHeader.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加”-ObjC”

#import "PolyvSettings.h"
#import "PolyvUtil.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [OpenShare connectWeixinWithAppId:@"wxc01e48ca5fe9c5c5"];
    [OpenShare connectAlipay];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    [self registerPolyvSDK];
    [self registerShareSDK];
    
    MainTabBarController *vc = [[MainTabBarController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)registerPolyvSDK{
    // 配置下载目录
    [PolyvSettings.sharedInstance setDownloadDir:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/plvideo/a"]];
    // 配置日志等级
    [PolyvSettings.sharedInstance setLogLevel:PLVLogLevelAll];
    // 开启 HttpDNS 功能
    [PolyvSettings.sharedInstance setHttpDNSEnable:YES];
    
    // 配置sdk加密串
    // NSString *appKey = @"你的SDK加密串";
    NSString *appKey = @"eA/RHzHpIWtF8lhXn4FlylGDfBipwgmTN4gytUxK2zDoBXVeqah2WJXvucD1PitlnS4plLfG+OHJFEnRb30CC1wMcPC59FEz0RhIag9e5//Y0F4vkxehFK2O4JrCsmU+14qSWAq8Y/xA3/mKNFjc6g==";
    // 使用默认加密秘钥和加密向量解密 SDK加密串
    NSArray *config = [PolyvUtil decryptUserConfig:[appKey dataUsingEncoding:NSUTF8StringEncoding]];
    [[PolyvSettings sharedInstance] initVideoSettings:[config objectAtIndex:1] Readtoken:[config objectAtIndex:2] Writetoken:[config objectAtIndex:3] UserId:[config objectAtIndex:0]];
    
    // 配置sdk加密串示例(使用网络接口)
    /*
     NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://demo.polyv.net/demo/appkey.php"]];
     NSArray*config =[PolyvUtil decryptUserConfig:data];
     if ([config count]!=4) {
     NSLog(@"加载token失败");
     }else{
     [[PolyvSettings sharedInstance] setDownloadDir:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/plvideo/a"]];
     [[PolyvSettings sharedInstance] initVideoSettings:[config objectAtIndex:1] Readtoken:[config objectAtIndex:2] Writetoken:[config objectAtIndex:3] UserId:[config objectAtIndex:0]];
     }
     */
}

-(void)registerShareSDK{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeCopy),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxc01e48ca5fe9c5c5"
                                       appSecret:@"bacea975d1aa133842c82c482f3fc3df"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106383012"
                                      appKey:@"2bNw8yAw8QJhy0NR"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                   break;
                   }
                   }];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //第二步：添加回调
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    //这里可以写上其他OpenShare不支持的客户端的回调，比如支付宝等。
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //重载设置
    [[PolyvSettings sharedInstance]  reloadSettings];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
