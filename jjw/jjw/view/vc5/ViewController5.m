//
//  ViewController5.m
//  jjw
//
//  Created by Stephen Chin on 2017/3/30.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "ViewController5.h"
#import "JZNavigationExtension.h"
#import "UIImage+Color.h"
#import "PaidRecordViewController.h"
#import "ShoppingCartViewController.h"
#import "MyClassViewController.h"
#import "PackageClassViewController.h"
#import "StudyRecordViewController.h"
#import "MyOrdersViewController.h"
#import "MyCollectViewController.h"
#import "MyQueAnsViewController.h"
#import "BasicInfoViewController.h"
#import "MyHeaderImageViewController.h"
#import "PasswordSettingViewController.h"
#import "PasswordSettingViewController2.h"
#import "NSDictionary+Category.h"
#import "UIImageView+AFNetworking.h"
#import "RechargeViewController.h"
#import "RegisterViewController.h"
#import "ChongzhiViewController.h"
#import "Util.h"
#import "UIViewController+RegisterRandomAccount.h"
#import "SysMsgViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ViewController5 (){
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *yue;
    
    
    UITextField *accountTextField;
    UITextField *passwordField;
    
    NSDictionary *userInfo;
}

@end

@implementation ViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.jz_navigationBarBackgroundAlpha = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfo) name:@"loadUserInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rlogin:) name:@"rlogin" object:nil];
    
    
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=[UIColor whiteColor];
    [titleText setFont:[UIFont boldSystemFontOfSize:17.0]];
    [titleText setText:@"个人中心"];
    [titleText sizeToFit];
    self.navigationItem.titleView=titleText;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    userInfo = [ud objectForKey:LOGINED_USER];
    if (userInfo) {
        [self loadUserInfo];
    }else{
        
        [self showHudInView:self.view];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSSet *set = [NSSet setWithObject:@"text/html"];
        [manager.responseSerializer setAcceptableContentTypes:set];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_open"];
        [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self hideHud];
            NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *code = [dic objectForKey:@"code"];
            if ([code isEqualToString:@"200"]) {
                NSDictionary *result = [dic objectForKey:@"result"];
                NSNumber *code = [result objectForKey:@"code"];
                if ([code boolValue]) {
                    [self initUI:[code boolValue]];
                }else{
                    [self initUI:[code boolValue]];
                }
            }else{
                [self initUI:YES];
            }
            DLog(@"%@",dic);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self hideHud];
            DLog(@"%@",error.description);
            [self initUI:YES];
        }];
    }
    
    
    
    
}

-(void)initUI:(BOOL)flag{
//    self.jz_navigationBarBackgroundAlpha = 1;
//    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    
    _loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    _loginView.backgroundColor = RGB(245, 245, 245);
    
    self.navigationItem.rightBarButtonItem = nil;
    
//    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
//    
//    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(2, 6, 60, 28)];
//    [btn1 setTitle:@"高中" forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn1.titleLabel.font = SYSTEMFONT(13);
//    [btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
//    ViewBorderRadius(btn1, 5, 0, [UIColor whiteColor]);
//    [navView addSubview:btn1];
//    
//    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame) + 10, 6, 60, 28)];
//    [btn2 setTitle:@"课程" forState:UIControlStateNormal];
//    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn2.titleLabel.font = SYSTEMFONT(13);
//    [btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
//    ViewBorderRadius(btn2, 5, 0, [UIColor whiteColor]);
//    [navView addSubview:btn2];
//    
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn2.frame) + 10, 6, Main_Screen_Width - CGRectGetMaxX(btn2.frame) - 28, 28)];
//    ViewRadius(searchBar, 5);
//    [navView addSubview:searchBar];
//    self.navigationItem.titleView = navView;
    
    
    
    
//    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 42)];
//    topLabel.backgroundColor = [UIColor whiteColor];
//    topLabel.font = SYSTEMFONT(17);
//    topLabel.textColor = [UIColor blackColor];
//    topLabel.text = @"  用户登录";
//    ViewBorderRadius(topLabel, 0, 1, RGB(223, 223, 223));
//    [_loginView addSubview:topLabel];
    
    UIView *loginContentView = [[UIView alloc] initWithFrame:CGRectMake(5, 64+ 5, Main_Screen_Width - 10, 400)];
    loginContentView.backgroundColor = [UIColor whiteColor];
    ViewBorderRadius(loginContentView, 0, 1, BORDER_COLOR);
    [_loginView addSubview:loginContentView];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 0, 0)];
    accountLabel.text = @"账号:";
    accountLabel.font = SYSTEMFONT(15);
    [accountLabel sizeToFit];
    [loginContentView addSubview:accountLabel];
    
    accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame) + 20, CGRectGetMinY(accountLabel.frame) - 8, CGRectGetWidth(loginContentView.frame) - CGRectGetMaxX(accountLabel.frame) - 50, CGRectGetHeight(accountLabel.frame) + 18)];
    ViewBorderRadius(accountTextField, 5, 1, BORDER_COLOR);
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTextField.font = SYSTEMFONT(15);
    accountTextField.backgroundColor = RGB(251, 251, 251);
    UIView *leftAView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    accountTextField.leftView = leftAView;
    accountTextField.placeholder = @"请输入账号";
    accountTextField.leftViewMode = UITextFieldViewModeAlways;
    [loginContentView addSubview:accountTextField];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(accountLabel.frame) + 30, 0, 0)];
    passwordLabel.text = @"密码:";
    passwordLabel.font = SYSTEMFONT(15);
    [passwordLabel sizeToFit];
    [loginContentView addSubview:passwordLabel];
    
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordLabel.frame) + 20, CGRectGetMinY(passwordLabel.frame) - 8, CGRectGetWidth(loginContentView.frame) - CGRectGetMaxX(passwordLabel.frame) - 50, CGRectGetHeight(passwordLabel.frame) + 18)];
    ViewBorderRadius(passwordField, 5, 1, BORDER_COLOR);
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.font = SYSTEMFONT(15);
    passwordField.secureTextEntry = YES;
    passwordField.backgroundColor = RGB(251, 251, 251);
    UIView *leftBView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    passwordField.leftView = leftBView;
    passwordField.placeholder = @"请输入密码";
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    [loginContentView addSubview:passwordField];
    
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(passwordLabel.frame), CGRectGetMaxY(passwordLabel.frame) + 20, CGRectGetWidth(loginContentView.frame) - CGRectGetMinX(passwordLabel.frame) * 2, 35)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = SYSTEMFONT(15);
    [loginBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(loginBtn, 5, 0, [UIColor whiteColor]);
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginContentView addSubview:loginBtn];
    
    if (flag) {//游客登录
        loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(passwordLabel.frame), CGRectGetMaxY(loginBtn.frame) + 10, CGRectGetWidth(loginContentView.frame) - CGRectGetMinX(passwordLabel.frame) * 2, 35)];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn setTitle:@"游客登录" forState:UIControlStateNormal];
        loginBtn.titleLabel.font = SYSTEMFONT(15);
        [loginBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
        ViewBorderRadius(loginBtn, 5, 0, [UIColor whiteColor]);
        [loginBtn addTarget:self action:@selector(youkelogin) forControlEvents:UIControlEventTouchUpInside];
        [loginContentView addSubview:loginBtn];
    }
    
    UIButton *regBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(passwordLabel.frame), CGRectGetMaxY(loginBtn.frame) + 20, 0, 0)];
    [regBtn setTitleColor:RGB(0, 149, 229) forState:UIControlStateNormal];
    [regBtn setTitle:@"用户注册" forState:UIControlStateNormal];
    regBtn.titleLabel.font = SYSTEMFONT(15);
    [regBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [regBtn sizeToFit];
    [loginContentView addSubview:regBtn];
    
    UIButton *forgetPwdBtn = [[UIButton alloc] init];
    [forgetPwdBtn setTitleColor:RGB(0, 149, 229) forState:UIControlStateNormal];
    [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPwdBtn.titleLabel.font = SYSTEMFONT(15);
    [forgetPwdBtn addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
    [forgetPwdBtn sizeToFit];
    forgetPwdBtn.frame = CGRectMake(CGRectGetWidth(loginContentView.frame) - CGRectGetWidth(forgetPwdBtn.frame) - 30, CGRectGetMaxY(loginBtn.frame) + 20, CGRectGetWidth(forgetPwdBtn.frame), CGRectGetHeight(forgetPwdBtn.frame));
//    [forgetPwdBtn setFrame:CGRectMake(CGRectGetWidth(loginContentView.frame) - CGRectGetWidth(forgetPwdBtn.frame), CGRectGetMaxY(loginBtn.frame) + 20, CGRectGetWidth(forgetPwdBtn.frame), CGRectGetHeight(forgetPwdBtn.frame)];
    [loginContentView addSubview:forgetPwdBtn];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(regBtn.frame) + 15, CGRectGetWidth(loginContentView.frame), 15)];
    label2.text = @"第三方快捷登录";
    label2.textColor = RGB(102, 102, 102);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = SYSTEMFONT(14);
    [loginContentView addSubview:label2];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(loginBtn.frame) + 30, CGRectGetMaxY(label2.frame) + 15, CGRectGetWidth(loginBtn.frame) - 60, 1)];
    line.backgroundColor = RGB(223, 223, 223);
    [loginContentView addSubview:line];
    
    UIImage *qqImage = [UIImage imageNamed:@"qq.jpeg"];
    UIButton *qqBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(loginContentView.frame) - qqImage.size.width - 20, CGRectGetMaxY(line.frame) + 15, qqImage.size.width, qqImage.size.height)];
    [qqBtn setImage:qqImage forState:UIControlStateNormal];
    ViewBorderRadius(qqBtn, qqImage.size.height/2, 0, [UIColor whiteColor]);
    [qqBtn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginContentView addSubview:qqBtn];
    
    UIImage *wxImage = [UIImage imageNamed:@"wx.jpeg"];
    UIButton *wxBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(loginContentView.frame) + 20, CGRectGetMaxY(line.frame) + 15, wxImage.size.width, wxImage.size.height)];
    [wxBtn setImage:wxImage forState:UIControlStateNormal];
    ViewBorderRadius(wxBtn, wxImage.size.height/2, 0, [UIColor whiteColor]);
    [wxBtn addTarget:self action:@selector(wxLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginContentView addSubview:wxBtn];
    
    self.view = _loginView;
    
//    if (DEBUG) {
//        accountTextField.text = @"zy@92yc.com";
//        passwordField.text = @"123456";
//    }
    
    
}

-(void)youkelogin{
    NSString *randomAccount = [Util generateRandomString];
    [self registerRandomAccount:randomAccount];
}

-(void)thirdPartLogin:(SSDKUser *)user type:(NSString *)type{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.uid forKey:@"openid"];
    [param setObject:type forKey:@"type"];
    [param setObject:user.nickname forKey:@"name"];
    
    NSString *url = [NSString stringWithFormat:@"%@",@"http://testapi.jjw-school.com/sign/other_register"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            
            
            
            NSDictionary *result = [[dic objectForKey:@"result"] cleanNull];
            NSNumber *other_id = [result objectForKey:@"other_id"];
            if (other_id != nil) {
                RegisterViewController *vc = [[RegisterViewController alloc] init];
                vc.other_id = other_id;
                vc.nickName = user.nickname;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else{//绑定手机号码
                
                userInfo = [result cleanNull];
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:userInfo forKey:LOGINED_USER];
                
                [self loadUserInfo];
                
            }
            
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}

-(void)wxLogin{
    [self showHudInView:self.view];
    [ShareSDK authorize:SSDKPlatformTypeWechat settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        // 处理回调
        if (state == SSDKResponseStateSuccess)
        {
            NSLog(@"uid=%@",user.uid);
            NSLog(@"%@",user.credential);
            NSLog(@"token=%@",user.credential.token);
            NSLog(@"nickname=%@",user.nickname);
            
            [self thirdPartLogin:user type:@"wechat"];
        }
        else
        {
            [self hideHud];
            NSLog(@"%@",error);
        }
    }];
}

-(void)qqLogin{
    [self showHudInView:self.view];
    [ShareSDK authorize:SSDKPlatformTypeQQ settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        // 处理回调
        if (state == SSDKResponseStateSuccess)
        {
            NSLog(@"uid=%@",user.uid);
            NSLog(@"%@",user.credential);
            NSLog(@"token=%@",user.credential.token);
            NSLog(@"nickname=%@",user.nickname);
            
            [self thirdPartLogin:user type:@"qq"];
        }
        else
        {
            [self hideHud];
            NSLog(@"%@",error);
        }
    }];
}

-(void)rlogin:(NSNotification *)text{
    accountTextField.text = [text.userInfo objectForKey:@"username"];
    passwordField.text = [text.userInfo objectForKey:@"password"];
    
    
    [self.view endEditing:YES];
    
//    sleep(3);
//    
    [self showHudInView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:accountTextField.text forKey:@"email"];
    [param setObject:passwordField.text forKey:@"pwd"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_login/login_do"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            
            userInfo = [[result objectForKey:@"data_list"] cleanNull];
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:userInfo forKey:LOGINED_USER];
            
            
            DLog(@"%@",result);
            [self setTableHeaderView];
            [_userCenterView setFrame:CGRectMake(0, 64, Main_Screen_Width, self.view.frame.size.height-64-49)];
            [_userCenterView removeFromSuperview];
            [self.view addSubview:_userCenterView];
            //            self.navigationItem.titleView = nil;
            //            self.jz_navigationBarBackgroundAlpha = 1;
            
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
            [rightItem setTintColor:[UIColor whiteColor]];
            self.navigationItem.rightBarButtonItem = rightItem;
            
            
            [self showHintInView:self.view hint:@"请完善信息"];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
    
}

//登录
-(void)login{
    
    if ([accountTextField.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请输入账号"];
        return;
    }
    if ([passwordField.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请输入密码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self showHudInView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:accountTextField.text forKey:@"account"];
    [param setObject:passwordField.text forKey:@"pwd"];
    
    NSString *url = [NSString stringWithFormat:@"%@",@"http://testapi.jjw-school.com/sign/login"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            
            userInfo = [[result objectForKey:@"data_list"] cleanNull];
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:userInfo forKey:LOGINED_USER];
            
            [self loadUserInfo];
            
            
//            DLog(@"%@",result);
//            [self setTableHeaderView];
//            self.view = _userCenterView;
//            
////            self.navigationItem.titleView = nil;
////            self.jz_navigationBarBackgroundAlpha = 1;
//            
//            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
//            [rightItem setTintColor:[UIColor whiteColor]];
//            self.navigationItem.rightBarButtonItem = rightItem;
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
    
//    self.jz_navigationBarBackgroundHidden = YES;
//    self.title = @"个人中心";
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
}

-(void)logout{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要退出登录吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud removeObjectForKey:LOGINED_USER];
        [self showHudInView:self.view];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSSet *set = [NSSet setWithObject:@"text/html"];
        [manager.responseSerializer setAcceptableContentTypes:set];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_open"];
        [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self hideHud];
            NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *code = [dic objectForKey:@"code"];
            if ([code isEqualToString:@"200"]) {
                NSDictionary *result = [dic objectForKey:@"result"];
                NSNumber *code = [result objectForKey:@"code"];
                if ([code boolValue]) {
                    [self initUI:[code boolValue]];
                }else{
                    [self initUI:[code boolValue]];
                }
            }else{
                [self initUI:YES];
            }
            DLog(@"%@",dic);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self hideHud];
            DLog(@"%@",error.description);
            [self initUI:YES];
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    

}

//加载用户信息
-(void)loadUserInfo{
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    userInfo = [ud objectForKey:LOGINED_USER];
   
    
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/index"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            userInfo = [[result objectForKey:@"data_list"] cleanNull];
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:userInfo forKey:LOGINED_USER];
            
            NSString *mobile = [userInfo objectForKey:@"MOBILE"];
            if (mobile == nil || [mobile isEqualToString:@""]) {
                BasicInfoViewController *vc = [[BasicInfoViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            [self setTableHeaderView];
            [_userCenterView setFrame:CGRectMake(0, 64, Main_Screen_Width, self.view.frame.size.height-64-49)];
            [_userCenterView removeFromSuperview];
            [self.view addSubview:_userCenterView];
//            self.navigationItem.titleView = nil;
//            self.jz_navigationBarBackgroundAlpha = 1;
            
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
            [rightItem setTintColor:[UIColor whiteColor]];
            self.navigationItem.rightBarButtonItem = rightItem;
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        DLog(@"%@",error.description);
    }];
    
}

-(void)toPay{
//    RechargeViewController *vc = [[RechargeViewController alloc] init];
    ChongzhiViewController *vc = [[ChongzhiViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//注册用户
-(void)registerUser{
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nc animated:YES completion:nil];
}

//充值密码
-(void)forgetPwd{
    PasswordSettingViewController *vc = [[PasswordSettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setTableHeaderView{
    CGFloat headImageWidth = Main_Screen_Width * 0.25;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10 +headImageWidth + 10 + 45 + 40)];
    tableHeaderView.backgroundColor = RGB(69, 179, 230);
    _myTableView.tableHeaderView = tableHeaderView;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10 + headImageWidth +10)];
    
    NSString *pic = [userInfo objectForKey:@"PIC_IMG"];
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width*0.25, 10, headImageWidth, headImageWidth)];
    [headImageView setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"default_avatar.jpg"]];
    ViewRadius(headImageView, headImageWidth/2);
    [view1 addSubview:headImageView];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [ud objectForKey:LOGINED_USER];
    
    NSString *MOBILE = [user objectForKey:@"MOBILE"];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 10, 20, 0, 0)];
    if (MOBILE != nil) {
        phoneLabel.text = MOBILE;
    }
    
    phoneLabel.textColor = [UIColor whiteColor];
    [phoneLabel sizeToFit];
    [view1 addSubview:phoneLabel];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 10, 20+30, 0, 0)];
    
    NSString *showName = [user objectForKey:@"SHOW_NAME"];
    if (showName == nil || [showName isEqualToString:@""]) {
        nameLabel.text = @"未设置";
    }else{
        nameLabel.text = showName;
    }
    nameLabel.textColor = [UIColor whiteColor];
    [nameLabel sizeToFit];
    [view1 addSubview:nameLabel];
    
//    UILabel *logoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame) + 10, 0, 0)];
//    logoutLabel.textColor = [UIColor whiteColor];
//    logoutLabel.text = @"退出登录";
//    [logoutLabel sizeToFit];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout)];
//    logoutLabel.userInteractionEnabled = YES;
//    [logoutLabel addGestureRecognizer:tap];
//    [view1 addSubview:logoutLabel];
    
    [tableHeaderView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame), Main_Screen_Width, 45)];
    view2.backgroundColor = RGB(245, 245, 245);
    UILabel *yueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 0, 0)];
    yueLabel.text = @"账户余额:";
    yueLabel.textColor = RGB(51, 51, 51);
    yueLabel.font = SYSTEMFONT(14);
    [yueLabel sizeToFit];
    [view2 addSubview:yueLabel];
    
    
    NSString *f_money = [userInfo objectForKey:@"f_money"];
    yue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yueLabel.frame) + 3, CGRectGetMinY(yueLabel.frame), 0, 0)];
    yue.textColor = RGB(255, 153, 0);
    yue.font = BOLDSYSTEMFONT(14);
    yue.text = f_money;
    [yue sizeToFit];
    [view2 addSubview:yue];
    
    CGFloat btnWidth = Main_Screen_Width*0.5*0.45;
    UIButton *chongzhiBtn = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width - 10 - btnWidth, 7, btnWidth, 32)];
    [chongzhiBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [chongzhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongzhiBtn.titleLabel.font = BOLDSYSTEMFONT(15);
    [chongzhiBtn setBackgroundImage:[UIImage imageWithColor:RGB(255, 153, 0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [chongzhiBtn addTarget:self action:@selector(toPay) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(chongzhiBtn, 5);
    [view2 addSubview:chongzhiBtn];
    
    [tableHeaderView addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame), Main_Screen_Width, 40)];
    view3.backgroundColor = [UIColor whiteColor];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 1)];
    line.backgroundColor = RGB(223, 223, 223);
    [view3 addSubview:line];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, Main_Screen_Width, 1)];
    line.backgroundColor = RGB(223, 223, 223);
    [view3 addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, Main_Screen_Width, 38)];
    label.text = @"个人中心";
    [view3 addSubview:label];
    [tableHeaderView addSubview:view3];
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
    view.backgroundColor = RGB(163,222,255);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    if (section == 0) {
        label.text = @"我的学习";
    }
    if (section == 1) {
        label.text = @"我的资料";
    }
    
    label.textColor = RGB(51, 51, 51);
    label.font = SYSTEMFONT(14);
    [view addSubview:label];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PaidRecordViewController *vc = [[PaidRecordViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            ShoppingCartViewController *vc = [[ShoppingCartViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {
            MyClassViewController *vc = [[MyClassViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 3) {
            PackageClassViewController *vc = [[PackageClassViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 4) {
            StudyRecordViewController *vc = [[StudyRecordViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 5) {
            MyOrdersViewController *vc = [[MyOrdersViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 6) {
            NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"1"}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        if (indexPath.row == 7) {
            MyCollectViewController *vc = [[MyCollectViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 8) {
            MyQueAnsViewController *vc = [[MyQueAnsViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 9) {
            SysMsgViewController *vc = [[SysMsgViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            BasicInfoViewController *vc = [[BasicInfoViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            MyHeaderImageViewController *vc = [[MyHeaderImageViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {
            PasswordSettingViewController2 *vc = [[PasswordSettingViewController2 alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = RGB(102, 102, 102);
        cell.textLabel.font = SYSTEMFONT(14);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"充值记录";
                break;
            case 1:
                cell.textLabel.text = @"我的购物车";
                break;
            case 2:
                cell.textLabel.text = @"我的课程";
                break;
            case 3:
                cell.textLabel.text = @"打包课程";
                break;
            case 4:
                cell.textLabel.text = @"学习记录";
                break;
            case 5:
                cell.textLabel.text = @"我的订单";
                break;
            case 6:
                cell.textLabel.text = @"选课中心";
                break;
            case 7:
                cell.textLabel.text = @"我的收藏";
                break;
            case 8:
                cell.textLabel.text = @"点播问答";
                break;
            case 9:
                cell.textLabel.text = @"系统消息";
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"基本资料";
                break;
            case 1:
                cell.textLabel.text = @"个人头像";
                break;
            case 2:
                cell.textLabel.text = @"密码设置";
                break;
            default:
                break;
        }
    }
    
    return cell;
}

@end
