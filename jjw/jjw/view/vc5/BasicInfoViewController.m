//
//  BasicInfoViewController.m
//  jjw
//
//  Created by ylc on 2017/4/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "BasicInfoViewController.h"
#import "JZNavigationExtension.h"
#import "NSDictionary+Category.h"
#import "UIImage+Color.h"
#import "NSObject+Blocks.h"
#import "Util.h"

#define SELECTED_IMAGE @"RadioButton-Selected"
#define UNSELECTED_IMAGE @"RadioButton-Unselected"

@interface BasicInfoViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSDictionary *data_list;
    UITextField *phoneTF;
    UITextField *codeTF;
    UITextField *emailTF;
    UITextField *nameTF;
    UITextField *nicknameTF;
    UITextField *schoolTF;
//    UITextField *gradeTF;
    UIButton *gradeBtn;
    UIButton *manBtn;
    UIButton *womanBtn;
    UIButton *otherBtn;
    
    UIButton *ageBtn;
    NSMutableArray *ageArray;
    NSMutableArray *gradeArray;
    NSInteger ageSelected;
    NSInteger gradeSelected;
    UIView *maskView;
    UIView *popView;
    UIPickerView *picker1;
    int sexSelect;
    
    
    UIButton *getCodeBtn;
}

@end

@implementation BasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.title = @"基本资料";
    
    self.view.backgroundColor = RGB(245, 245, 245);
    
//    self.navigationItem.hidesBackButton = YES;
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    if (ageArray == nil) {
        ageArray = [NSMutableArray array];
        for (int i = 6; i < 61; i++) {
            [ageArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    gradeArray = [NSMutableArray array];
    [self loadGradeData];
    
    [self initUI];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [ud objectForKey:LOGINED_USER];
    NSString *MOBILE = [user objectForKey:@"MOBILE"];
    if (MOBILE != nil && ![MOBILE isEqualToString:@""]) {
        
    }else{
        if (_showAlert) {
            _showAlert = NO;
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"为了您的账号安全和方便找回密码，请先绑定您的手机号！绑定后可用手机号登录使用平台学习！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

//-(void)back{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSDictionary *user = [ud objectForKey:LOGINED_USER];
//    NSString *MOBILE = [user objectForKey:@"MOBILE"];
//    if (MOBILE != nil && ![MOBILE isEqualToString:@""]) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self showHintInView:self.view hint:@"请完善手机号码"];
//    }
//}

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
        }
            
       
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}

-(void)loadData{
    
    [self showHudInView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/get_user_info"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            data_list = [[result objectForKey:@"data_list"] cleanNull];
            
            NSString *mobile = [data_list objectForKey:@"MOBILE"];
            NSString *email = [data_list objectForKey:@"EMAIL"];
            NSString *userName = [data_list objectForKey:@"USER_NAME"];
            NSString *showName = [data_list objectForKey:@"SHOW_NAME"];
            NSString *school = [data_list objectForKey:@"school"];
            
            if (mobile != nil && ![mobile isEqualToString:@""]) {
                phoneTF.text = mobile;
                phoneTF.userInteractionEnabled = NO;
            }else{
                phoneTF.userInteractionEnabled = YES;
                
            }
            emailTF.text = email == nil ? @"" :email;
            nameTF.text = userName == nil ? @"" : userName;
            nicknameTF.text = showName == nil ? @"" : showName;
            schoolTF.text = school == nil ? @"" : school;
            
            NSNumber *sex = [data_list objectForKey:@"SEX"];
            
            [self selectSexBtn:[sex intValue]];
            
            NSNumber *age = [data_list objectForKey:@"AGE"];
            ageSelected = [age integerValue];
            [ageBtn setTitle:[NSString stringWithFormat:@"%d岁",[age intValue]] forState:UIControlStateNormal];
            
            NSString *grade = [data_list objectForKey:@"grade"];
            if (grade == nil) {
                grade = gradeArray[0];
            }
            [gradeBtn setTitle:grade forState:UIControlStateNormal];
            
            DLog(@"%@",result);

        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
    
}



-(void)initUI{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width - 20, 0)];
    contentView.backgroundColor = [UIColor whiteColor];
    ViewBorderRadius(contentView, 0, 1, RGB(223, 223, 223));
    [_myScrollView addSubview:contentView];
    
    //手机
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 0, 0)];
    phoneLabel.text = @"手机:";
    phoneLabel.font = SYSTEMFONT(15);
    [phoneLabel sizeToFit];
    [contentView addSubview:phoneLabel];
    
    phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame) + 20, CGRectGetMinY(phoneLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(phoneLabel.frame) - 50, CGRectGetHeight(phoneLabel.frame) + 18)];
    ViewBorderRadius(phoneTF, 5, 1, BORDER_COLOR);
    phoneTF.font = SYSTEMFONT(15);
    phoneTF.backgroundColor = RGB(251, 251, 251);
    UIView *leftAView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    phoneTF.leftView = leftAView0;
    phoneTF.leftViewMode = UITextFieldViewModeAlways;
    //    emailTF.userInteractionEnabled = NO;
    [contentView addSubview:phoneTF];
    
    CGFloat maxY = CGRectGetMaxY(phoneTF.frame);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [ud objectForKey:LOGINED_USER];
    NSString *MOBILE = [user objectForKey:@"MOBILE"];
    if (MOBILE != nil && ![MOBILE isEqualToString:@""]) {
        
    }else{
        //验证码
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(phoneTF.frame) + 20, 0, 0)];
        codeLabel.text = @"验证码:";
        codeLabel.font = SYSTEMFONT(15);
        [codeLabel sizeToFit];
        [contentView addSubview:codeLabel];
        
        codeTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codeLabel.frame) + 20, CGRectGetMinY(codeLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(codeLabel.frame) - 50, CGRectGetHeight(codeLabel.frame) + 18)];
        ViewBorderRadius(codeTF, 5, 1, BORDER_COLOR);
        codeTF.font = SYSTEMFONT(15);
        codeTF.backgroundColor = RGB(251, 251, 251);
        UIView *leftAView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
        codeTF.leftView = leftAView;
        codeTF.leftViewMode = UITextFieldViewModeAlways;
        //    emailTF.userInteractionEnabled = NO;
        [contentView addSubview:codeTF];
        
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
        codeTF.rightViewMode = UITextFieldViewModeAlways;
        codeTF.rightView = rightView;
        
        maxY = CGRectGetMaxY(codeTF.frame);
    }
    
    
    
    
    //邮箱
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, maxY + 20, 0, 0)];
    accountLabel.text = @"邮箱:";
    accountLabel.font = SYSTEMFONT(15);
    [accountLabel sizeToFit];
    [contentView addSubview:accountLabel];
    
    emailTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame) + 20, CGRectGetMinY(accountLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(accountLabel.frame) - 50, CGRectGetHeight(accountLabel.frame) + 18)];
    ViewBorderRadius(emailTF, 5, 1, BORDER_COLOR);
    emailTF.font = SYSTEMFONT(15);
    emailTF.backgroundColor = RGB(251, 251, 251);
    UIView *leftAView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    emailTF.leftView = leftAView;
    emailTF.leftViewMode = UITextFieldViewModeAlways;
//    emailTF.userInteractionEnabled = NO;
    [contentView addSubview:emailTF];
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(emailTF.frame) + 20, 0, 0)];
    nameLabel.text = @"姓名:";
    nameLabel.font = SYSTEMFONT(15);
    [nameLabel sizeToFit];
    [contentView addSubview:nameLabel];
    
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 20, CGRectGetMinY(nameLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(nameLabel.frame) - 50, CGRectGetHeight(nameLabel.frame) + 18)];
    ViewBorderRadius(nameTF, 5, 1, BORDER_COLOR);
    nameTF.font = SYSTEMFONT(15);
    nameTF.backgroundColor = RGB(251, 251, 251);
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    nameTF.leftView = leftView2;
    nameTF.leftViewMode = UITextFieldViewModeAlways;
    [contentView addSubview:nameTF];

    
    //昵称
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(nameTF.frame) + 20, 0, 0)];
    nickLabel.text = @"昵称:";
    nickLabel.font = SYSTEMFONT(15);
    [nickLabel sizeToFit];
    [contentView addSubview:nickLabel];
    
    nicknameTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickLabel.frame) + 20, CGRectGetMinY(nickLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(nickLabel.frame) - 50, CGRectGetHeight(nickLabel.frame) + 18)];
    ViewBorderRadius(nicknameTF, 5, 1, BORDER_COLOR);
    nicknameTF.font = SYSTEMFONT(15);
    nicknameTF.backgroundColor = RGB(251, 251, 251);
    UIView *leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    nicknameTF.leftView = leftView3;
    nicknameTF.leftViewMode = UITextFieldViewModeAlways;
    [contentView addSubview:nicknameTF];
    
    //学校
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(nicknameTF.frame) + 20, 0, 0)];
    schoolLabel.text = @"学校:";
    schoolLabel.font = SYSTEMFONT(15);
    [schoolLabel sizeToFit];
    [contentView addSubview:schoolLabel];
    
    schoolTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(schoolLabel.frame) + 20, CGRectGetMinY(schoolLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(schoolLabel.frame) - 50, CGRectGetHeight(schoolLabel.frame) + 18)];
    ViewBorderRadius(schoolTF, 5, 1, BORDER_COLOR);
    schoolTF.font = SYSTEMFONT(15);
    schoolTF.backgroundColor = RGB(251, 251, 251);
    UIView *leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    schoolTF.leftView = leftView4;
    schoolTF.leftViewMode = UITextFieldViewModeAlways;
    [contentView addSubview:schoolTF];
    
    //年级
    UILabel *gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(schoolTF.frame) + 20, 0, 0)];
    gradeLabel.text = @"年级:";
    gradeLabel.font = SYSTEMFONT(15);
    [gradeLabel sizeToFit];
    [contentView addSubview:gradeLabel];
    
    gradeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    gradeBtn.tag = 2;
    [gradeBtn setFrame:CGRectMake(CGRectGetMaxX(gradeLabel.frame) + 20, CGRectGetMinY(gradeLabel.frame) - 8, 100, 33)];
    [gradeBtn setTitle:@"" forState:UIControlStateNormal];
    [gradeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    gradeBtn.titleLabel.font = SYSTEMFONT(14);
    [gradeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [ageBtn sizeToFit];
    //    ageBtn.backgroundColor = [UIColor lightGrayColor];
    ViewBorderRadius(gradeBtn, 5, 1, RGB(240, 240, 240));
    [contentView addSubview:gradeBtn];

    //性别
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(gradeBtn.frame) + 18, 0, 0)];
    sexLabel.text = @"性别:";
    sexLabel.font = SYSTEMFONT(15);
    [sexLabel sizeToFit];
    [contentView addSubview:sexLabel];
    
    manBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sexLabel.frame) + 20, CGRectGetMinY(sexLabel.frame), 50, 21)];
    [manBtn setImage:[UIImage imageNamed:UNSELECTED_IMAGE] forState:UIControlStateNormal];
    [manBtn setTitle:@" 男" forState:UIControlStateNormal];
    [manBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    manBtn.titleLabel.font = SYSTEMFONT(14);
    manBtn.tag = 1;
    [manBtn addTarget:self action:@selector(setSexValue:) forControlEvents:UIControlEventTouchUpInside];
    [manBtn sizeToFit];
    [contentView addSubview:manBtn];
    
    womanBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(manBtn.frame) + 10, CGRectGetMinY(sexLabel.frame), 50, 21)];
    [womanBtn setImage:[UIImage imageNamed:UNSELECTED_IMAGE] forState:UIControlStateNormal];
    [womanBtn setTitle:@" 女" forState:UIControlStateNormal];
    [womanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    womanBtn.titleLabel.font = SYSTEMFONT(14);
    womanBtn.tag = 2;
    [womanBtn addTarget:self action:@selector(setSexValue:) forControlEvents:UIControlEventTouchUpInside];
    [womanBtn sizeToFit];
    [contentView addSubview:womanBtn];
    
    otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(womanBtn.frame) + 10, CGRectGetMinY(sexLabel.frame), 50, 21)];
    [otherBtn setImage:[UIImage imageNamed:UNSELECTED_IMAGE] forState:UIControlStateNormal];
    [otherBtn setTitle:@" 保密" forState:UIControlStateNormal];
    [otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    otherBtn.titleLabel.font = SYSTEMFONT(14);
    otherBtn.tag = 0;
    [otherBtn addTarget:self action:@selector(setSexValue:) forControlEvents:UIControlEventTouchUpInside];
    [otherBtn sizeToFit];
    [contentView addSubview:otherBtn];

    //年龄
    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(sexLabel.frame) + 25, 0, 0)];
    ageLabel.text = @"年龄:";
    ageLabel.font = SYSTEMFONT(15);
    [ageLabel sizeToFit];
    [contentView addSubview:ageLabel];
    
    ageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    ageBtn.tag = 1;
    [ageBtn setFrame:CGRectMake(CGRectGetMaxX(ageLabel.frame) + 20, CGRectGetMinY(ageLabel.frame) - 8, 100, 33)];
    [ageBtn setTitle:@"6岁" forState:UIControlStateNormal];
    [ageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ageBtn.titleLabel.font = SYSTEMFONT(14);
    [ageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [ageBtn sizeToFit];
//    ageBtn.backgroundColor = [UIColor lightGrayColor];
    ViewBorderRadius(ageBtn, 5, 1, RGB(240, 240, 240));
    [contentView addSubview:ageBtn];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(ageBtn.frame) + 20, CGRectGetWidth(contentView.frame) - 60, 35)];
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
    
    [self loadData];
}

-(void)submit{
    
    if ([phoneTF.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请填写手机号码"];
        return;
    }
    if (codeTF) {
        if ([codeTF.text isEqualToString:@""]) {
            [self showHintInView:self.view hint:@"请填写验证码"];
            return;
        }
        
    }
    
    
    
    
    [self.view endEditing:YES];
    [self showHudInView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    [param setObject:nameTF.text forKey:@"user_name"];
    [param setObject:nicknameTF.text forKey:@"nick_name"];
    [param setObject:[NSNumber numberWithInt:sexSelect] forKey:@"gender"];
    [param setObject:emailTF.text forKey:@"email"];
    [param setObject:schoolTF.text forKey:@"school"];
    [param setObject:gradeBtn.currentTitle forKey:@"grade"];
    [param setObject:phoneTF.text forKey:@"mobile"];
    if (codeTF) {
        [param setObject:codeTF.text forKey:@"code"];
    }
    
    
    NSNumber *ageNum = ageArray[ageSelected];
    [param setObject:[ageNum stringValue] forKey:@"age"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/update_user_info"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {

             [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loadUserInfo" object:nil userInfo:nil]];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:1.5];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self showHintInView:self.view hint:error.localizedDescription];
        DLog(@"%@",error.description);
    }];

}

-(void)setSexValue:(UIButton *)btn{
    [self selectSexBtn:(int)btn.tag];
}

-(void)selectSexBtn:(int)sex{
    [manBtn setImage:[UIImage imageNamed:UNSELECTED_IMAGE] forState:UIControlStateNormal];
    [womanBtn setImage:[UIImage imageNamed:UNSELECTED_IMAGE] forState:UIControlStateNormal];
    [otherBtn setImage:[UIImage imageNamed:UNSELECTED_IMAGE] forState:UIControlStateNormal];
    if (sex == 1) {
        [manBtn setImage:[UIImage imageNamed:SELECTED_IMAGE] forState:UIControlStateNormal];
    }else if (sex == 2){
        [womanBtn setImage:[UIImage imageNamed:SELECTED_IMAGE] forState:UIControlStateNormal];
    }else if (sex == 0){
        [otherBtn setImage:[UIImage imageNamed:SELECTED_IMAGE] forState:UIControlStateNormal];
    }
    sexSelect = sex;
}

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
    
    if (btn.tag == 1) {
        picker1.tag = 1;
        [picker1 reloadAllComponents];
        [picker1 selectRow:ageSelected inComponent:0 animated:NO];
        
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        ageSelected = row;
        NSNumber *ageNum = ageArray[ageSelected];
        [ageBtn setTitle:[NSString stringWithFormat:@"%d岁",[ageNum intValue]] forState:UIControlStateNormal];
    }
    if (pickerView.tag == 2) {
        gradeSelected = row;
        NSString *grade = [gradeArray objectAtIndex:gradeSelected];
        [gradeBtn setTitle:grade forState:UIControlStateNormal];
    }
    
    
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        ageSelected = row;
        NSNumber *ageNum = ageArray[ageSelected];
        return [NSString stringWithFormat:@"%d岁",[ageNum intValue]];
    }
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
    if (pickerView.tag == 1) {
        return ageArray.count;
    }
    if (pickerView.tag == 2) {
        return gradeArray.count;
    }
    return 0;
}

//获取验证码
-(void)getCode{
    
    if (![Util valiMobile:phoneTF.text]) {
        [self showHintInView:self.view hint:@"请输入正确的手机号码"];
        return;
    }
    
    [self.view endEditing:YES];
    [self showHudInView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:phoneTF.text forKey:@"mobile"];
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

@end
