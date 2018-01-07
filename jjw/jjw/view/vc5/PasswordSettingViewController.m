//
//  PasswordSettingViewController.m
//  jjw
//
//  Created by ylc on 2017/4/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "PasswordSettingViewController.h"
#import "JZNavigationExtension.h"
#import "UIImage+Color.h"
#import "NSObject+Blocks.h"
#import "Util.h"

@interface PasswordSettingViewController (){
    UITextField *accountTextField;
    UITextField *codeTextField;
//    UITextField *oldPwdTF;
    UITextField *newPwdTF;
    UITextField *newPwdTF2;
    UIButton *getCodeBtn;
}

@end

@implementation PasswordSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.title = @"重置密码";
    
    self.view.backgroundColor = RGB(245, 245, 245);
    
    [self initUI];
}

-(void)initUI{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 64 + 10, Main_Screen_Width - 20, 0)];
    contentView.backgroundColor = [UIColor whiteColor];
    ViewBorderRadius(contentView, 0, 1, RGB(223, 223, 223));
    [self.view addSubview:contentView];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 0, 0)];
    accountLabel.text = @"手机号码:";
    accountLabel.font = SYSTEMFONT(15);
    [accountLabel sizeToFit];
    [contentView addSubview:accountLabel];
    
    accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame) + 20, CGRectGetMinY(accountLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(accountLabel.frame) - 50, CGRectGetHeight(accountLabel.frame) + 18)];
    ViewBorderRadius(accountTextField, 5, 1, BORDER_COLOR);
    accountTextField.font = SYSTEMFONT(15);
    accountTextField.backgroundColor = RGB(251, 251, 251);
    UIView *leftAView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    accountTextField.leftView = leftAView2;
    accountTextField.leftViewMode = UITextFieldViewModeAlways;
    accountTextField.placeholder = @"请输入手机号码";
    accountTextField.keyboardType = UIKeyboardTypePhonePad;
    [contentView addSubview:accountTextField];
    
//    //旧密码
//    UILabel *oldPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 0, 0)];
//    oldPwdLabel.text = @"旧密码:";
//    oldPwdLabel.font = SYSTEMFONT(15);
//    [oldPwdLabel sizeToFit];
//    [contentView addSubview:oldPwdLabel];
//    
//    oldPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(oldPwdLabel.frame) + 20, CGRectGetMinY(oldPwdLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(oldPwdLabel.frame) - 50, CGRectGetHeight(oldPwdLabel.frame) + 18)];
//    ViewBorderRadius(oldPwdTF, 5, 1, BORDER_COLOR);
//    oldPwdTF.font = SYSTEMFONT(15);
//    oldPwdTF.backgroundColor = RGB(251, 251, 251);
//    UIView *leftAView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
//    oldPwdTF.leftView = leftAView;
//    oldPwdTF.leftViewMode = UITextFieldViewModeAlways;
//    oldPwdTF.secureTextEntry = YES;
//    [contentView addSubview:oldPwdTF];
    
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(accountTextField.frame) + 20, 0, 0)];
    codeLabel.text = @"验证码:";
    codeLabel.font = SYSTEMFONT(15);
    [codeLabel sizeToFit];
    [contentView addSubview:codeLabel];
    
    codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame) + 20, CGRectGetMinY(codeLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(accountLabel.frame) - 50, CGRectGetHeight(codeLabel.frame) + 18)];
    ViewBorderRadius(codeTextField, 5, 1, BORDER_COLOR);
    codeTextField.font = SYSTEMFONT(15);
    codeTextField.secureTextEntry = YES;
    codeTextField.backgroundColor = RGB(251, 251, 251);
    UIView *leftBView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    codeTextField.leftView = leftBView;
    codeTextField.leftViewMode = UITextFieldViewModeAlways;
    codeTextField.placeholder = @"请输入验证码";
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [contentView addSubview:codeTextField];
    
    getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 100, 40)];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:RGBA(204 ,45 ,45, 1) forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:RGBA(204, 204, 204, 1) forState:UIControlStateHighlighted];
    [getCodeBtn setTitleColor:RGBA(204, 204, 204, 1) forState:UIControlStateDisabled];//计时
    //    [getCodeBtn setTitleColor:RGB(5,198,232) forState:UIControlStateHighlighted];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [getCodeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 105, 40)];
    [rightView addSubview:getCodeBtn];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 1, 20)];
    label.backgroundColor = RGBA(204, 204, 204, 1);
    ViewBorderRadius(label, 1, 1, RGBA(204, 204, 204, 1));
    [rightView addSubview:label];
    codeTextField.rightViewMode = UITextFieldViewModeAlways;
    codeTextField.rightView = rightView;
    
    //新密码
    UILabel *newPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(codeTextField.frame) + 20, 0, 0)];
    newPwdLabel.text = @"新密码:";
    newPwdLabel.font = SYSTEMFONT(15);
    [newPwdLabel sizeToFit];
    [contentView addSubview:newPwdLabel];
    
    newPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame) + 20, CGRectGetMinY(newPwdLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(accountLabel.frame) - 50, CGRectGetHeight(newPwdLabel.frame) + 18)];
    ViewBorderRadius(newPwdTF, 5, 1, BORDER_COLOR);
    newPwdTF.font = SYSTEMFONT(15);
    newPwdTF.backgroundColor = RGB(251, 251, 251);
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    newPwdTF.leftView = leftView2;
    newPwdTF.leftViewMode = UITextFieldViewModeAlways;
    newPwdTF.secureTextEntry = YES;
    newPwdTF.placeholder = @"请输入新密码";
    [contentView addSubview:newPwdTF];
    
    
    //新密码2
    UILabel *newPwd2Label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(newPwdTF.frame) + 20, 0, 0)];
    newPwd2Label.text = @"确认密码:";
    newPwd2Label.font = SYSTEMFONT(15);
    [newPwd2Label sizeToFit];
    [contentView addSubview:newPwd2Label];
    
    newPwdTF2 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame) + 20, CGRectGetMinY(newPwd2Label.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(newPwd2Label.frame) - 50, CGRectGetHeight(newPwd2Label.frame) + 18)];
    ViewBorderRadius(newPwdTF2, 5, 1, BORDER_COLOR);
    newPwdTF2.font = SYSTEMFONT(15);
    newPwdTF2.backgroundColor = RGB(251, 251, 251);
    UIView *leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    newPwdTF2.leftView = leftView3;
    newPwdTF2.leftViewMode = UITextFieldViewModeAlways;
    newPwdTF2.secureTextEntry = YES;
    newPwdTF2.placeholder = @"请输入确认密码";
    [contentView addSubview:newPwdTF2];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(newPwdTF2.frame) + 20, CGRectGetWidth(contentView.frame) - 60, 35)];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = BOLDSYSTEMFONT(15);
    [submitBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(submitBtn, 5, 0, [UIColor whiteColor]);
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:submitBtn];
    
    CGRect frame = contentView.frame;
    frame.size.height = CGRectGetMaxY(submitBtn.frame) + 20;
    [contentView setFrame:frame];
    
}

-(void)submit{
    
//    if ([oldPwdTF.text isEqualToString:@""]) {
//        [self showHintInView:self.view hint:@"请输入旧密码"];
//        return;
//    }
    if ([accountTextField.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请输入手机号码"];
        return;
    }
    if (![Util valiMobile:accountTextField.text]) {
        [self showHintInView:self.view hint:@"请输入正确的手机号码"];
        return;
    }
    if ([codeTextField.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请输入验证码"];
        return;
    }
    if ([newPwdTF.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请输入新密码"];
        return;
    }
    if ([newPwdTF2.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请再次输入新密码"];
        return;
    }
    if (![newPwdTF.text isEqualToString:newPwdTF2.text]) {
        [self showHintInView:self.view hint:@"两次密码不一致"];
        return;
    }
    
    [self.view endEditing:YES];
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:accountTextField.text forKey:@"mobile"];
    [param setObject:codeTextField.text forKey:@"code"];
    [param setObject:newPwdTF.text forKey:@"pwd"];
    [param setObject:newPwdTF2.text forKey:@"pwd2"];
    NSString *url = [NSString stringWithFormat:@"%@",@"http://testapi.jjw-school.com/sign/reset_pwd"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.5];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取验证码
-(void)getCode{
    
    if (![Util valiMobile:accountTextField.text]) {
        [self showHintInView:self.view hint:@"请输入正确的手机号码"];
        return;
    }
    
    [self.view endEditing:YES];
    [self showHudInView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:accountTextField.text forKey:@"mobile"];
    [param setObject:@"set_pwd" forKey:@"action"];
    
    NSString *url = [NSString stringWithFormat:@"%@",@"http://testapi.jjw-school.com/sign/get_code"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        NSString *msg = [responseObject objectForKey:@"msg"];
        NSString *code = [responseObject objectForKey:@"code"];
        [self showHintInView:self.view hint:msg];
        if ([code isEqualToString:@"200"]) {
            [self startTime];
        }
        
        //        NSDictionary *num = [responseObject cleanNull];
        //        DLog(@"%@",num);
        //        //        NSDictionary *num = [dic objectForKey:@"number"];
        //        if (num) {
        //            NSString *coding = [num objectForKey:@"coding"];
        //            if (coding && ![coding isEqualToString:@""]) {
        //                codeNum = coding;
        //                [self showHintInView:self.view hint:@"验证码发送成功"];
        //                [self startTime];
        //            }else{
        //                [self showHintInView:self.view hint:@"验证码发送失败"];
        //            }
        //        }else{
        //            [self showHintInView:self.view hint:@"验证码发送失败"];
        //        }
        DLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self showHintInView:self.view hint:error.localizedDescription];
    }];
}

#pragma mark - 倒计时
-(void)startTime{
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                getCodeBtn.titleLabel.text = @"获取验证码";
                [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                //                [_codeBtn setBackgroundColor:[UIColor whiteColor]];
                getCodeBtn.userInteractionEnabled = YES;
                getCodeBtn.enabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                //                [UIView beginAnimations:nil context:nil];
                //                [UIView setAnimationDuration:1];
                getCodeBtn.titleLabel.text = [NSString stringWithFormat:@"%@秒后重试",strTime];
                [getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重试",strTime] forState:UIControlStateNormal];
                //                [_codeBtn setBackgroundColor:[UIColor lightGrayColor]];
                //                [UIView commitAnimations];
                getCodeBtn.userInteractionEnabled = NO;
                getCodeBtn.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
