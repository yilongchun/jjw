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
#import "Util.h"

@interface RegisterViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    UITextField *nickNameTextField;
    UITextField *accountTextField;
    UITextField *codeTextField;
    UITextField *schoolTF;
    UIButton *gradeBtn;
    UITextField *passwordField;
    UITextField *passwordField2;
    UIButton *getCodeBtn;
    
    NSMutableArray *gradeArray;
    NSInteger gradeSelected;
    UIView *maskView;
    UIView *popView;
    UIPickerView *picker1;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"用户注册";
    
    gradeArray = [NSMutableArray array];
    
    
    
    [self initUI];
}

-(void)loadGradeData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/grade"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            [gradeArray addObjectsFromArray:array];
            
            [gradeBtn setTitle:[gradeArray objectAtIndex:0] forState:UIControlStateNormal];
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}

-(void)initUI{
    
    self.view.backgroundColor = RGB(245, 245, 245);
    
    UIView *loginContentView = [[UIView alloc] initWithFrame:CGRectMake(5,  64 + 5 , Main_Screen_Width - 10, 450)];
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
    nickNameTextField.placeholder = @"请输入昵称";
    [loginContentView addSubview:nickNameTextField];
    
    if (_nickName) {
        nickNameTextField.text = _nickName;
    }
    
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(nickNameLabel.frame) + 30, 0, 0)];
    accountLabel.text = @"手机号码:";
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
    accountTextField.placeholder = @"请输入手机号码";
    accountTextField.keyboardType = UIKeyboardTypePhonePad;
    [loginContentView addSubview:accountTextField];
    
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(accountLabel.frame) + 30, 0, 0)];
    codeLabel.text = @"验证码:";
    codeLabel.font = SYSTEMFONT(15);
    [codeLabel sizeToFit];
    [loginContentView addSubview:codeLabel];
    
    codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame) + 20, CGRectGetMinY(codeLabel.frame) - 8, CGRectGetWidth(loginContentView.frame) - CGRectGetMaxX(accountLabel.frame) - 50, CGRectGetHeight(codeLabel.frame) + 18)];
    ViewBorderRadius(codeTextField, 5, 1, BORDER_COLOR);
    codeTextField.font = SYSTEMFONT(15);
    codeTextField.secureTextEntry = YES;
    codeTextField.backgroundColor = RGB(251, 251, 251);
    UIView *leftBView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    codeTextField.leftView = leftBView;
    codeTextField.leftViewMode = UITextFieldViewModeAlways;
    codeTextField.placeholder = @"请输入验证码";
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [loginContentView addSubview:codeTextField];
    
    //学校
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(codeLabel.frame) + 30, 0, 0)];
    schoolLabel.text = @"学校:";
    schoolLabel.font = SYSTEMFONT(15);
    [schoolLabel sizeToFit];
    [loginContentView addSubview:schoolLabel];
    
    schoolTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame) + 20, CGRectGetMinY(schoolLabel.frame) - 8, CGRectGetWidth(loginContentView.frame) - CGRectGetMaxX(accountLabel.frame) - 50, CGRectGetHeight(schoolLabel.frame) + 18)];
    ViewBorderRadius(schoolTF, 5, 1, BORDER_COLOR);
    schoolTF.font = SYSTEMFONT(15);
    schoolTF.backgroundColor = RGB(251, 251, 251);
    UIView *leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    schoolTF.leftView = leftView4;
    schoolTF.leftViewMode = UITextFieldViewModeAlways;
    [loginContentView addSubview:schoolTF];
    
    //年级
    UILabel *gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(schoolLabel.frame) + 30, 0, 0)];
    gradeLabel.text = @"年级:";
    gradeLabel.font = SYSTEMFONT(15);
    [gradeLabel sizeToFit];
    [loginContentView addSubview:gradeLabel];
    
    gradeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    gradeBtn.tag = 2;
    [gradeBtn setFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame) + 20, CGRectGetMinY(gradeLabel.frame) - 8, 100, 33)];
    [gradeBtn setTitle:@"" forState:UIControlStateNormal];
    [gradeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    gradeBtn.titleLabel.font = SYSTEMFONT(14);
    [gradeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [ageBtn sizeToFit];
    //    ageBtn.backgroundColor = [UIColor lightGrayColor];
    ViewBorderRadius(gradeBtn, 5, 1, RGB(240, 240, 240));
    [loginContentView addSubview:gradeBtn];
    
    
    
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
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(gradeLabel.frame) + 30, 0, 0)];
    passwordLabel.text = @"密码:";
    passwordLabel.font = SYSTEMFONT(15);
    [passwordLabel sizeToFit];
    [loginContentView addSubview:passwordLabel];
    
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordLabel.frame) + 20, CGRectGetMinY(passwordLabel.frame) - 8, CGRectGetWidth(loginContentView.frame) - CGRectGetMaxX(passwordLabel.frame) - 50, CGRectGetHeight(passwordLabel.frame) + 18)];
    ViewBorderRadius(passwordField, 5, 1, BORDER_COLOR);
    passwordField.font = SYSTEMFONT(15);
    passwordField.secureTextEntry = YES;
    passwordField.backgroundColor = RGB(251, 251, 251);
    leftBView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    passwordField.leftView = leftBView;
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    passwordField.placeholder = @"请输入密码";
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
    passwordField2.placeholder = @"请输入确认密码";
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
    xieyi.text = @"我同意《讲解王用户注册协议》";
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
    
    [self loadGradeData];
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
//    if (![self validateEmail:accountTextField.text]) {
//        [self showHintInView:self.view hint:@"邮箱格式不正确"];
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
    [param setObject:accountTextField.text forKey:@"mobile"];
    [param setObject:passwordField.text forKey:@"pwd"];
    [param setObject:passwordField2.text forKey:@"pwd2"];
    [param setObject:codeTextField.text forKey:@"code"];
    if (_other_id != nil) {
        [param setObject:_other_id forKey:@"other_id"];
    }
    [param setObject:schoolTF.text forKey:@"school"];
    [param setObject:gradeBtn.currentTitle forKey:@"grade"];
    
    NSString *url = [NSString stringWithFormat:@"%@",@"http://testapi.jjw-school.com/sign/register"];
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
                
                
//                NSNotification *notification =[NSNotification notificationWithName:@"rlogin" object:nil userInfo:@{@"username":accountTextField.text,@"password":passwordField.text}];
//                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
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

//- (BOOL) validateEmail:(NSString *)email
//{
//    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    return [emailTest evaluateWithObject:email];
//}

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
    [param setObject:@"register" forKey:@"action"];
    
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

-(void)cancel{
    [self hidePopView];
}

-(void)ok{
    
    [self hidePopView];
}

-(void)hidePopView{
    
    [UIView animateWithDuration:0.15 animations:^{
        if (maskView) {
            maskView.alpha = 0;
        }
        if (popView) {
            [popView setFrame:CGRectMake(15, Main_Screen_Height, Main_Screen_Width-30, 300)];
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [maskView removeFromSuperview];
            [popView removeFromSuperview];
        }
    }];
}

-(void)btnClick:(UIButton *)btn{
    
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
    maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopView)];
    [maskView addGestureRecognizer:tap];
    [self.view.window addSubview:maskView];
    
    popView = [[UIView alloc] initWithFrame:CGRectMake(15, Main_Screen_Height, Main_Screen_Width-30, 300)];
    popView.backgroundColor = [UIColor whiteColor];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setFrame:CGRectMake(0, 0, 60, 50)];
    cancelBtn.tag = 10;
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [popView addSubview:cancelBtn];
    UIButton *okBtn =  [UIButton buttonWithType:UIButtonTypeSystem];
    [okBtn setFrame:CGRectMake(Main_Screen_Width - 30 - 60, 0, 60, 50)];
    okBtn.tag = 20;
    [okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [popView addSubview:okBtn];
    ViewRadius(popView, 10);
    [self.view.window addSubview:popView];
    
    
    
    if (picker1 == nil) {
        picker1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width-30, 250)];
        picker1.dataSource = self;
        picker1.delegate = self;
        
    }
    [popView addSubview:picker1];
    
    if (btn.tag == 2) {
        picker1.tag = 2;
        [picker1 reloadAllComponents];
        [picker1 selectRow:gradeSelected inComponent:0 animated:NO];
        
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        maskView.alpha = 1;
        [popView setFrame:CGRectMake(15, Main_Screen_Height - 300 -15, Main_Screen_Width-30, 300)];
    }];
    
    
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 2) {
        gradeSelected = row;
        NSString *grade = [gradeArray objectAtIndex:gradeSelected];
        [gradeBtn setTitle:grade forState:UIControlStateNormal];
    }
    
    
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 2) {
        gradeSelected = row;
        NSString *grade = [gradeArray objectAtIndex:gradeSelected];
        return grade;
    }
    return @"";
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 2) {
        return gradeArray.count;
    }
    return 0;
}

@end
