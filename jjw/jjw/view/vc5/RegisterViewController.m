//
//  RegisterViewController.m
//  jjw
//
//  Created by ylc on 2017/6/18.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "RegisterViewController.h"
#import "JZNavigationExtension.h"
#import "UIImage+Color.h"
#import "NSObject+Blocks.h"
#import "WebViewController.h"

@interface RegisterViewController (){
    UITextField *nickNameTextField;
    UITextField *accountTextField;
    UITextField *passwordField;
    UITextField *passwordField2;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"用户注册";
    [self initUI];
}

-(void)initUI{
    
    self.view.backgroundColor = RGB(245, 245, 245);
    
    UIView *loginContentView = [[UIView alloc] initWithFrame:CGRectMake(5,  64 + 5 , Main_Screen_Width - 10, 350)];
    loginContentView.backgroundColor = [UIColor whiteColor];
    ViewBorderRadius(loginContentView, 0, 1, BORDER_COLOR);
    [self.view addSubview:loginContentView];
    
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 0, 0)];
    nickNameLabel.text = @"昵称:";
    nickNameLabel.font = SYSTEMFONT(15);
    [nickNameLabel sizeToFit];
    [loginContentView addSubview:nickNameLabel];
    
    nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickNameLabel.frame) + 50, CGRectGetMinY(nickNameLabel.frame) - 8, CGRectGetWidth(loginContentView.frame) - CGRectGetMaxX(nickNameLabel.frame) - 50-30, CGRectGetHeight(nickNameLabel.frame) + 18)];
    ViewBorderRadius(nickNameTextField, 5, 1, BORDER_COLOR);
    nickNameTextField.font = SYSTEMFONT(15);
    nickNameTextField.backgroundColor = RGB(251, 251, 251);
    UIView *leftAView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    nickNameTextField.leftView = leftAView;
    nickNameTextField.leftViewMode = UITextFieldViewModeAlways;
    [loginContentView addSubview:nickNameTextField];
    
    
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(nickNameLabel.frame) + 30, 0, 0)];
    accountLabel.text = @"邮箱:";
    accountLabel.font = SYSTEMFONT(15);
    [accountLabel sizeToFit];
    [loginContentView addSubview:accountLabel];
    
    accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame) + 20, CGRectGetMinY(accountLabel.frame) - 8, CGRectGetWidth(loginContentView.frame) - CGRectGetMaxX(accountLabel.frame) - 50, CGRectGetHeight(accountLabel.frame) + 18)];
    ViewBorderRadius(accountTextField, 5, 1, BORDER_COLOR);
    accountTextField.font = SYSTEMFONT(15);
    accountTextField.backgroundColor = RGB(251, 251, 251);
    UIView *leftAView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    accountTextField.leftView = leftAView2;
    accountTextField.leftViewMode = UITextFieldViewModeAlways;
    [loginContentView addSubview:accountTextField];
    
    UILabel *accountTips = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(accountLabel.frame) + 30, Main_Screen_Width - 10 - 60, 0)];
    accountTips.font = SYSTEMFONT(15);
    accountTips.text = @"请输入注册邮箱号 ";
    [accountTips sizeToFit];
    [loginContentView addSubview:accountTips];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(accountTips.frame) + 30, 0, 0)];
    passwordLabel.text = @"密码:";
    passwordLabel.font = SYSTEMFONT(15);
    [passwordLabel sizeToFit];
    [loginContentView addSubview:passwordLabel];
    
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordLabel.frame) + 20, CGRectGetMinY(passwordLabel.frame) - 8, CGRectGetWidth(loginContentView.frame) - CGRectGetMaxX(passwordLabel.frame) - 50, CGRectGetHeight(passwordLabel.frame) + 18)];
    ViewBorderRadius(passwordField, 5, 1, BORDER_COLOR);
    passwordField.font = SYSTEMFONT(15);
    passwordField.secureTextEntry = YES;
    passwordField.backgroundColor = RGB(251, 251, 251);
    UIView *leftBView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    passwordField.leftView = leftBView;
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    [loginContentView addSubview:passwordField];
    
    UILabel *passwordLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(passwordLabel.frame) + 30, 0, 0)];
    passwordLabel2.text = @"确认密码:";
    passwordLabel2.font = SYSTEMFONT(15);
    [passwordLabel2 sizeToFit];
    [loginContentView addSubview:passwordLabel2];
    
    passwordField2 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordLabel2.frame) + 20, CGRectGetMinY(passwordLabel2.frame) - 8, CGRectGetWidth(loginContentView.frame) - CGRectGetMaxX(passwordLabel2.frame) - 50, CGRectGetHeight(passwordLabel2.frame) + 18)];
    ViewBorderRadius(passwordField2, 5, 1, BORDER_COLOR);
    passwordField2.font = SYSTEMFONT(15);
    passwordField2.secureTextEntry = YES;
    passwordField2.backgroundColor = RGB(251, 251, 251);
    UIView *leftBView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    passwordField2.leftView = leftBView2;
    passwordField2.leftViewMode = UITextFieldViewModeAlways;
    [loginContentView addSubview:passwordField2];
    
    
    CGRect c1 = accountTextField.frame;
    c1.origin.x = passwordField2.frame.origin.x;
    c1.size.width = passwordField2.frame.size.width;
    [accountTextField setFrame:c1];
    
    CGRect c2 = passwordField.frame;
    c2.origin.x = passwordField2.frame.origin.x;
    c2.size.width = passwordField2.frame.size.width;
    [passwordField setFrame:c2];
    
    
    UILabel *xieyi = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(passwordLabel2.frame) + 30, 0, 0)];
    xieyi.text = @"我同意《微课堂视频视频网站使用协议》";
    xieyi.font = SYSTEMFONT(13);
    xieyi.textColor = RGB(0, 150, 230);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showXieyi)];
    xieyi.userInteractionEnabled = YES;
    [xieyi addGestureRecognizer:tap];
    [xieyi sizeToFit];
    [loginContentView addSubview:xieyi];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(passwordLabel2.frame), CGRectGetMaxY(xieyi.frame) + 20, CGRectGetWidth(loginContentView.frame) - CGRectGetMinX(passwordLabel.frame) * 2, 35)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = SYSTEMFONT(15);
    [loginBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(loginBtn, 5, 0, [UIColor whiteColor]);
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginContentView addSubview:loginBtn];
}

-(void)showXieyi{
    WebViewController *vc = [[WebViewController alloc] init];
    vc.url = @"http://m.jjw-school.com/about/webview/provision";
    vc.title = @"用户协议";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)login{
    [self.view endEditing:YES];
    
    if ([nickNameTextField.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请输入昵称"];
        return;
    }
    if (![self validateEmail:accountTextField.text]) {
        [self showHintInView:self.view hint:@"邮箱格式不正确"];
        return;
    }
    if ([passwordField.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请输入密码"];
        return;
    }
    if (![passwordField.text isEqualToString:passwordField2.text]) {
        [self showHintInView:self.view hint:@"两次密码不一致，请重新输入"];
        return;
    }
    
    [self showHudInView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:nickNameTextField.text forKey:@"nick_name"];
    [param setObject:accountTextField.text forKey:@"email"];
    [param setObject:passwordField.text forKey:@"pwd"];
    [param setObject:passwordField2.text forKey:@"pwd2"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_register/user_register_do"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        DLog(@"%@",dic);
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
//            NSDictionary *result = [dic objectForKey:@"result"];
            
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            
            [self performBlock:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
                NSNotification *notification =[NSNotification notificationWithName:@"rlogin" object:nil userInfo:@{@"username":accountTextField.text,@"password":passwordField.text}];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
            } afterDelay:1.5];
            
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

- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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
