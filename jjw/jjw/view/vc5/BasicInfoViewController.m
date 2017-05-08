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

#define SELECTED_IMAGE @"RadioButton-Selected"
#define UNSELECTED_IMAGE @"RadioButton-Unselected"

@interface BasicInfoViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSDictionary *data_list;
    UITextField *emailTF;
    UITextField *nameTF;
    UITextField *nicknameTF;
    UIButton *manBtn;
    UIButton *womanBtn;
    UIButton *otherBtn;
    
    UIButton *ageBtn;
    NSMutableArray *ageArray;
    NSInteger ageSelected;
    UIView *maskView;
    UIView *popView;
    UIPickerView *picker1;
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
    
    if (ageArray == nil) {
        ageArray = [NSMutableArray array];
        for (int i = 0; i < 100; i++) {
            [ageArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    [self initUI];
    
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
            
            NSString *email = [data_list objectForKey:@"EMAIL"];
            NSString *userName = [data_list objectForKey:@"USER_NAME"];
            NSString *showName = [data_list objectForKey:@"SHOW_NAME"];
            
            emailTF.text = email == nil ? @"" :email;
            nameTF.text = userName == nil ? @"" : userName;
            nicknameTF.text = showName == nil ? @"" : showName;
            
            NSNumber *sex = [data_list objectForKey:@"SEX"];
            
            [self selectSexBtn:[sex intValue]];
            
            NSNumber *age = [data_list objectForKey:@"AGE"];
            ageSelected = [age integerValue];
            [ageBtn setTitle:[NSString stringWithFormat:@"%d岁",[age intValue]] forState:UIControlStateNormal];
            
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
    
    //邮箱
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 0, 0)];
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

    //性别
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(nicknameTF.frame) + 18, 0, 0)];
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
    [ageBtn setFrame:CGRectMake(CGRectGetMaxX(ageLabel.frame) + 20, CGRectGetMinY(ageLabel.frame) - 8, 100, 33)];
    [ageBtn setTitle:@"0岁" forState:UIControlStateNormal];
    [ageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ageBtn.titleLabel.font = SYSTEMFONT(14);
    [ageBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
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

-(void)btnClick{
    
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
        picker1.tag = 1;
    }
    [popView addSubview:picker1];
    [picker1 selectRow:ageSelected inComponent:0 animated:NO];
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
        ageSelected = row;
        NSNumber *ageNum = ageArray[ageSelected];
        [ageBtn setTitle:[NSString stringWithFormat:@"%d岁",[ageNum intValue]] forState:UIControlStateNormal];
    
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    ageSelected = row;
    NSNumber *ageNum = ageArray[ageSelected];
    return [NSString stringWithFormat:@"%d岁",[ageNum intValue]];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return ageArray.count;
}

@end
