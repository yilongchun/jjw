//
//  RechargeViewController.m
//  jjw
//
//  Created by ylc on 2017/6/12.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "RechargeViewController.h"
#import "UIImage+Color.h"
#import "JZNavigationExtension.h"
#import "OpenShareHeader.h"
#import "NSObject+Blocks.h"

@interface RechargeViewController ()

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.jz_navigationBarBackgroundAlpha = 1;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.title = @"充值";
    
    ViewBorderRadius(_topView, 0, 1, RGB(223, 223, 223));
    ViewBorderRadius(_contentView, 0, 1, RGB(223, 223, 223));
    
    [_submitBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 133, 204) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ViewBorderRadius(_submitBtn, 5, 0, [UIColor whiteColor]);
    [_submitBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

-(void)pay{
    
    if ([_moneyTextField.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请填写金额"];
        return;
    }
    if (![self isPureInt:_moneyTextField.text]) {
        [self showHintInView:self.view hint:@"请填写数字"];
        return;
    }
    [self.view endEditing:YES];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"支付方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self payByWeixin];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action4];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)payByWeixin{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (!userInfo) {
        [self showHintInView:self.view hint:@"请先登录"];
        return;
    }
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"wechat" forKey:@"pay_type"];
    [param setObject:_moneyTextField.text forKey:@"money"];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/pay_recharge/index"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSString *link = [result objectForKey:@"wechat_link"];
            
            [OpenShare WeixinPay:link Success:^(NSDictionary *message) {
                DLog(@"微信支付成功:\n%@",message);
                [self showHintInView:self.view hint:@"支付成功"];
                 [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loadUserInfo" object:nil userInfo:nil]];
                [self performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                } afterDelay:1.5];
                
               
            } Fail:^(NSDictionary *message, NSError *error) {
                DLog(@"微信支付失败:\n%@\n%@",message,error);
                NSString *ret = [message objectForKey:@"ret"];
                if ([ret isEqualToString:@"-2"]) {
                    [self showHintInView:self.view hint:@"支付取消"];
                }else{
                    [self showHintInView:self.view hint:@"支付失败"];
                }
                
            }];
            
            //            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
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
