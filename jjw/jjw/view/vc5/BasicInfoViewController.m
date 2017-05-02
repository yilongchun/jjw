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

@interface BasicInfoViewController (){
    NSDictionary *data_list;
    UITextField *emailTF;
    UITextField *nameTF;
    UITextField *nicknameTF;
}

@end

@implementation BasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.title = @"基本资料";
    
    self.view.backgroundColor = RGB(245, 245, 245);
    [self initUI];
    
}

-(void)loadData{
    
    [self showHudInView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"1" forKey:@"uid"];
    
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

    
    
    
    
    CGRect frame = contentView.frame;
    frame.size.height = CGRectGetMaxY(nicknameTF.frame) + 20;
    [contentView setFrame:frame];
    
    [self loadData];
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
