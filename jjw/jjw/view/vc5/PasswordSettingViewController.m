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

@interface PasswordSettingViewController (){
    UITextField *oldPwdTF;
    UITextField *newPwdTF;
    UITextField *newPwdTF2;
}

@end

@implementation PasswordSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.title = @"密码设置";
    
    self.view.backgroundColor = RGB(245, 245, 245);
    
    [self initUI];
}

-(void)initUI{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 64 + 10, Main_Screen_Width - 20, 0)];
    contentView.backgroundColor = [UIColor whiteColor];
    ViewBorderRadius(contentView, 0, 1, RGB(223, 223, 223));
    [self.view addSubview:contentView];
    
    //旧密码
    UILabel *oldPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 0, 0)];
    oldPwdLabel.text = @"旧密码:";
    oldPwdLabel.font = SYSTEMFONT(15);
    [oldPwdLabel sizeToFit];
    [contentView addSubview:oldPwdLabel];
    
    oldPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(oldPwdLabel.frame) + 20, CGRectGetMinY(oldPwdLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(oldPwdLabel.frame) - 50, CGRectGetHeight(oldPwdLabel.frame) + 18)];
    ViewBorderRadius(oldPwdTF, 5, 1, BORDER_COLOR);
    oldPwdTF.font = SYSTEMFONT(15);
    oldPwdTF.backgroundColor = RGB(251, 251, 251);
    UIView *leftAView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    oldPwdTF.leftView = leftAView;
    oldPwdTF.leftViewMode = UITextFieldViewModeAlways;
    [contentView addSubview:oldPwdTF];
    
    //新密码
    UILabel *newPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(oldPwdTF.frame) + 20, 0, 0)];
    newPwdLabel.text = @"新密码:";
    newPwdLabel.font = SYSTEMFONT(15);
    [newPwdLabel sizeToFit];
    [contentView addSubview:newPwdLabel];
    
    newPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(newPwdLabel.frame) + 20, CGRectGetMinY(newPwdLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(newPwdLabel.frame) - 50, CGRectGetHeight(newPwdLabel.frame) + 18)];
    ViewBorderRadius(newPwdTF, 5, 1, BORDER_COLOR);
    newPwdTF.font = SYSTEMFONT(15);
    newPwdTF.backgroundColor = RGB(251, 251, 251);
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    newPwdTF.leftView = leftView2;
    newPwdTF.leftViewMode = UITextFieldViewModeAlways;
    [contentView addSubview:newPwdTF];
    
    
    //新密码2
    UILabel *newPwd2Label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(newPwdTF.frame) + 20, 0, 0)];
    newPwd2Label.text = @"新密码:";
    newPwd2Label.font = SYSTEMFONT(15);
    [newPwd2Label sizeToFit];
    [contentView addSubview:newPwd2Label];
    
    newPwdTF2 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(newPwd2Label.frame) + 20, CGRectGetMinY(newPwd2Label.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(newPwd2Label.frame) - 50, CGRectGetHeight(newPwd2Label.frame) + 18)];
    ViewBorderRadius(newPwdTF2, 5, 1, BORDER_COLOR);
    newPwdTF2.font = SYSTEMFONT(15);
    newPwdTF2.backgroundColor = RGB(251, 251, 251);
    UIView *leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    newPwdTF2.leftView = leftView3;
    newPwdTF2.leftViewMode = UITextFieldViewModeAlways;
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
