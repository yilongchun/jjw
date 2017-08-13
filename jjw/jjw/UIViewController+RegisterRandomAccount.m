//
//  UIViewController+RegisterRandomAccount.m
//  jjw
//
//  Created by ylc on 2017/8/10.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "UIViewController+RegisterRandomAccount.h"
#import "NSObject+Blocks.h"
#import "NSDictionary+Category.h"

@implementation UIViewController (RegisterRandomAccount)

-(void)registerRandomAccount:(NSString *)randomStr{
    [self.view endEditing:YES];
    
    [self showHudInView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:randomStr forKey:@"nick_name"];
    [param setObject:[NSString stringWithFormat:@"%@@jjw.com",randomStr] forKey:@"email"];
    [param setObject:randomStr forKey:@"pwd"];
    [param setObject:randomStr forKey:@"pwd2"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_register/user_register_do"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        DLog(@"%@",dic);
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            //            NSDictionary *result = [dic objectForKey:@"result"];
            
//            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            
            [self randomAccountLogin:randomStr];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}

-(void)randomAccountLogin:(NSString *)randomStr{
    [self.view endEditing:YES];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%@@jjw.com",randomStr] forKey:@"email"];
    [param setObject:randomStr forKey:@"pwd"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_login/login_do"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            
            NSDictionary *userInfo = [[result objectForKey:@"data_list"] cleanNull];
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:userInfo forKey:LOGINED_USER];
            
            [self showHintInView:self.view hint:@"游客登录成功"];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loadUserInfo" object:nil userInfo:nil]];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}

@end
