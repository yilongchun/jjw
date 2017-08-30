//
//  ViewController3.m
//  jjw
//
//  Created by Stephen Chin on 2017/3/30.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "ViewController3.h"
#import "JZNavigationExtension.h"
#import "UIImage+Color.h"
#import "NSObject+Blocks.h"
#import "TeacherViewController.h"

@interface ViewController3 ()<UIPickerViewDelegate,UIPickerViewDataSource,UISearchBarDelegate>

@end

@implementation ViewController3{
    UIView *maskView;
    UIView *popView;
    UIPickerView *picker1;
    UIPickerView *picker2;
    UIPickerView *picker3;
    int requestNum;
    
    UIButton *btn_1;
    UIButton *btn_2;
    UIButton *btn_3;
    
    NSArray *gradeArray;
    NSArray *subjectArray;
    NSArray *chapterArray;
    NSArray *teacherArray;
    
    UITextView *textView;
    
    NSMutableArray *selectedArray;
    
    NSInteger gradeSelect;
    NSInteger subjectSelect;
    NSInteger chapterSelect;
    UIView *selectedTeacherView;
    UIView *teacherView;
    UIButton *dianboBtn;
    UIView *contentView;
    
    UISearchBar *_searchBar;
    
    UIButton *nbtn2;
    UIView *popView2;
    UIView *maskView2;
    
    int action2Tag;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.view.backgroundColor = RGB(245, 245, 245);
    
    [self showHudInView:self.view];
    
    [self loadData1];
    [self loadData2];
    
}

-(void)initUI{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
    
    CGFloat barContentHeight = self.navigationController.navigationBar.frame.size.height - 20;
    
    
    
    nbtn2 = [[UIButton alloc] initWithFrame:CGRectMake(2, 6, 60, barContentHeight + 4)];
    [nbtn2 setTitle:@"课程" forState:UIControlStateNormal];
    [nbtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nbtn2.titleLabel.font = SYSTEMFONT(13);
    [nbtn2 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [nbtn2 setImage:[UIImage imageNamed:@"down2"] forState:UIControlStateNormal];
    UIImage *imgArrow = [UIImage imageNamed:@"down2"];
    [nbtn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgArrow.size.width, 0, imgArrow.size.width)];
    [nbtn2 setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -30)];
    ViewBorderRadius(nbtn2, 5, 0, [UIColor whiteColor]);
     [nbtn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgArrow.size.width, 0, imgArrow.size.width)];
    [nbtn2 addTarget:self action:@selector(chooseType2:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:nbtn2];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nbtn2.frame) + 10, 6, Main_Screen_Width - CGRectGetMaxX(nbtn2.frame) - 28, 28)];
    ViewRadius(_searchBar, 5);
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入搜索关键词";
    [navView addSubview:_searchBar];
    
    self.navigationItem.titleView = navView;

    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 42)];
    topLabel.backgroundColor = [UIColor whiteColor];
    topLabel.font = SYSTEMFONT(17);
    topLabel.textColor = [UIColor blackColor];
    topLabel.text = @"  我要点播";
    ViewBorderRadius(topLabel, 0, 1, RGB(223, 223, 223));
    [_myScrollView addSubview:topLabel];
    
    CGFloat maxY = 0;
    contentView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topLabel.frame) + 10, Main_Screen_Width - 20, 0)];
    contentView.backgroundColor = [UIColor whiteColor];
    ViewBorderRadius(contentView, 0, 1, RGB(223, 223, 223));
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(contentView.frame) - 20, 0)];
    l.numberOfLines = 0;
    l.font = SYSTEMFONT(15);
    l.text = @"如果你在本网站没有找到学习相关知识的微课，请在点播内容输入你想学习的内容描述，并留下联系方式，我们会根据你点播内容尽快录制好微课并联系你观看";
    [contentView addSubview:l];
    [l sizeToFit];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(l.frame) + 20, 0, 0)];
    label1.text = @"选择学段:";
    label1.font = SYSTEMFONT(15);
    [label1 sizeToFit];
    [contentView addSubview:label1];
    
    btn_1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame) + 15, CGRectGetMinY(label1.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(label1.frame) - 15 - 50, CGRectGetHeight(label1.frame) + 16)];
    NSDictionary *dic = gradeArray[0];
    NSString *subjectName = [dic objectForKey:@"SUBJECT_NAME"];
    [btn_1 setTitle:subjectName forState:UIControlStateNormal];
    [btn_1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_1.titleLabel.font = SYSTEMFONT(15);
    btn_1.tag = 1;
    [btn_1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(btn_1, 5, 1, BORDER_COLOR);
    [contentView addSubview:btn_1];
    
    UILabel *right1Label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn_1.frame) + 3, CGRectGetMinY(btn_1.frame)+ 10, 0, 0)];
    right1Label.textColor = RGB(255, 101, 1);
    right1Label.text = @"(*必选)";
    right1Label.font = SYSTEMFONT(12);
    [right1Label sizeToFit];
    [contentView addSubview:right1Label];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label1.frame) + 25, 0, 0)];
    label2.text = @"选择学科:";
    label2.font = SYSTEMFONT(15);
    [label2 sizeToFit];
    [contentView addSubview:label2];
    
    btn_2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame) + 15, CGRectGetMinY(label2.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(label2.frame) - 15 - 50, CGRectGetHeight(label2.frame) + 16)];
    NSDictionary *dic2 = subjectArray[0];
    NSString *subjectName2 = [dic2 objectForKey:@"SUBJECT_NAME"];
    [btn_2 setTitle:subjectName2 forState:UIControlStateNormal];
    [btn_2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_2.titleLabel.font = SYSTEMFONT(15);
    btn_2.tag = 2;
    [btn_2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(btn_2, 5, 1, BORDER_COLOR);
    [contentView addSubview:btn_2];
    
    UILabel *right2Label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn_2.frame) + 3, CGRectGetMinY(btn_2.frame)+ 10, 0, 0)];
    right2Label.textColor = RGB(255, 101, 1);
    right2Label.text = @"(*必选)";
    right2Label.font = SYSTEMFONT(12);
    [right2Label sizeToFit];
    [contentView addSubview:right2Label];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label2.frame) + 25, 0, 0)];
    label3.text = @"册数章节:";
    label3.font = SYSTEMFONT(15);
    [label3 sizeToFit];
    [contentView addSubview:label3];
    
    btn_3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame) + 15, CGRectGetMinY(label3.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(label3.frame) - 15 - 50, CGRectGetHeight(label3.frame) + 16)];
    [btn_3 setTitle:@"全部" forState:UIControlStateNormal];
    [btn_3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_3.titleLabel.font = SYSTEMFONT(15);
    btn_3.tag = 3;
    [btn_3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(btn_3, 5, 1, BORDER_COLOR);
    [contentView addSubview:btn_3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label3.frame) + 25, 0, 0)];
    label4.text = @"点播内容:";
    label4.font = SYSTEMFONT(15);
    [label4 sizeToFit];
    [contentView addSubview:label4];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label4.frame) + 15, CGRectGetMinY(label4.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(label4.frame) - 15 - 50, 100)];
    ViewBorderRadius(textView, 5, 1, BORDER_COLOR);
    [contentView addSubview:textView];
    
    UILabel *right3Label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textView.frame) + 3, CGRectGetMinY(textView.frame)+ 10, 0, 0)];
    right3Label.textColor = RGB(255, 101, 1);
    right3Label.text = @"(*必选)";
    right3Label.font = SYSTEMFONT(12);
    [right3Label sizeToFit];
    [contentView addSubview:right3Label];
    
    UILabel *label5 =  [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(textView.frame) + 25, 0, 0)];
    label5.text = @"讲解老师:";
    label5.font = SYSTEMFONT(15);
    [label5 sizeToFit];
    [contentView addSubview:label5];
    
    selectedTeacherView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label5.frame) + 10, CGRectGetMinY(label5.frame), Main_Screen_Width - CGRectGetMaxX(label5.frame) - 40, CGRectGetHeight(label5.frame))];
//    selectedTeacherView.backgroundColor = [UIColor grayColor];
    [contentView addSubview:selectedTeacherView];
    
    [self reloadSelectedTeacherView];
    
//    CGFloat width = 80;
//    CGFloat height = 24;
    
    teacherView = [[UIView alloc] init];
//    CGFloat x = 0,y = 0;
//    for (int i = 0; i < 11; i++) {
//        
//        x = 30 + (width + 15) * (i%3);
//        
//        if (i!= 0 && i%3 == 0) {
//            x = 30;
//            y += 24 + 10;
//        }
//        
//        UIButton *tbtn1 = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
//        [tbtn1 setBackgroundImage:[UIImage imageWithColor:RGB(225, 225, 225) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
//        [tbtn1 setTitle:@"余信欢" forState:UIControlStateNormal];
//        [tbtn1 setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
//        tbtn1.titleLabel.font = SYSTEMFONT(14);
//        [teacherView addSubview:tbtn1];
//        
//        maxY = CGRectGetMaxY(tbtn1.frame);
//    }
    
    [teacherView setFrame:CGRectMake(0, CGRectGetMaxY(label5.frame) + 20, Main_Screen_Width, 0)];
    [contentView addSubview:teacherView];
    
    dianboBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(teacherView.frame) + 20, CGRectGetWidth(contentView.frame) - 60, 35)];
    [dianboBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dianboBtn setTitle:@"我要点播" forState:UIControlStateNormal];
    dianboBtn.titleLabel.font = BOLDSYSTEMFONT(15);
    [dianboBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(dianboBtn, 5, 0, [UIColor whiteColor]);
    [dianboBtn addTarget:self action:@selector(dianbo) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:dianboBtn];
    
    maxY = CGRectGetMaxY(dianboBtn.frame);
    
    CGRect frame = contentView.frame;
    frame.size.height = maxY + 30;
    contentView.frame = frame;

    [_myScrollView addSubview:contentView];
    [_myScrollView setContentSize:CGSizeMake(Main_Screen_Width, CGRectGetMaxY(contentView.frame) + 30)];
    
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
//            maskView = nil;
//            popView = nil;
        }
    }];
}

-(void)btnClick:(UIButton *)sender{
    
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
    
    switch (sender.tag) {
        case 1:{
            if (picker1 == nil) {
                picker1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width-30, 250)];
                picker1.dataSource = self;
                picker1.delegate = self;
                picker1.tag = 1;
            }
            [popView addSubview:picker1];
            [picker1 selectRow:gradeSelect inComponent:0 animated:NO];
            [UIView animateWithDuration:0.15 animations:^{
                maskView.alpha = 1;
                [popView setFrame:CGRectMake(15, Main_Screen_Height - 300 -15, Main_Screen_Width-30, 300)];
            }];
        }
            break;
        case 2:{
            if (picker2 == nil) {
                picker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width-30, 250)];
                picker2.dataSource = self;
                picker2.delegate = self;
                picker2.tag = 2;
            }
            [popView addSubview:picker2];
            [picker2 selectRow:subjectSelect inComponent:0 animated:NO];
            [UIView animateWithDuration:0.15 animations:^{
                maskView.alpha = 1;
                [popView setFrame:CGRectMake(15, Main_Screen_Height - 300 -15, Main_Screen_Width-30, 300)];
            }];
        }
            break;
            
        case 3:{
            if (picker3 == nil) {
                picker3 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width-30, 250)];
                picker3.dataSource = self;
                picker3.delegate = self;
                picker3.tag = 3;
            }
            
            [popView addSubview:picker3];
            [picker3 selectRow:chapterSelect inComponent:0 animated:NO];
            [UIView animateWithDuration:0.15 animations:^{
                maskView.alpha = 1;
                [popView setFrame:CGRectMake(15, Main_Screen_Height - 300 -15, Main_Screen_Width-30, 300)];
            }];
            
        }
            break;
        default:
            break;
    }
    
}

-(void)reloadSelectedTeacherView{
    [[selectedTeacherView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (selectedArray && selectedArray.count > 0) {
        CGFloat x = 0;
        for (int i = 0; i < selectedArray.count; i++) {
            UILabel *teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 0, 0)];
            teacherLabel.text = [selectedArray[i] objectForKey:@"NAME"];
            teacherLabel.font = SYSTEMFONT(15);
            teacherLabel.textColor = RGB(51, 51, 51);
            teacherLabel.userInteractionEnabled = YES;
            teacherLabel.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delSelectedTeacher:)];
            [teacherLabel addGestureRecognizer:tap];
            [teacherLabel sizeToFit];
            [selectedTeacherView addSubview:teacherLabel];
            x = CGRectGetMaxX(teacherLabel.frame) + 10;
        }
    }else{
        UILabel *teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(selectedTeacherView.frame), CGRectGetHeight(selectedTeacherView.frame))];
        teacherLabel.text = @"请选择标签，最多选3个标签哦~";
        teacherLabel.font = SYSTEMFONT(15);
        teacherLabel.textColor = RGB(170, 170, 170);
        teacherLabel.adjustsFontSizeToFitWidth = YES;
        [selectedTeacherView addSubview:teacherLabel];
    }
   
    
}

-(void)selectedTeacher:(UIButton *)btn{
    if (selectedArray == nil) {
        selectedArray = [NSMutableArray array];
    }
    NSInteger tag = btn.tag;
    NSDictionary *teacherInfo = [teacherArray objectAtIndex:tag];
    if (![selectedArray containsObject:teacherInfo] && selectedArray.count < 3) {
        [selectedArray addObject:teacherInfo];
    }
    [self reloadSelectedTeacherView];
}

-(void)delSelectedTeacher:(UIGestureRecognizer *)recog{
    [selectedArray removeObjectAtIndex:recog.view.tag];
    [self reloadSelectedTeacherView];
}

-(void)dianbo{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [ud objectForKey:LOGINED_USER];
    if (user == nil) {
        [self showHintInView:self.view hint:@"请先登录"];
        [self performBlock:^{
            NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"4"}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } afterDelay:1.5];
    }else{
        
        if ([textView.text isEqualToString:@""]) {
            [self showHintInView:self.view hint:@"请填写点播内容"];
            return;
        }
        if (selectedArray.count == 0) {
            [self showHintInView:self.view hint:@"请选择至少一个讲解老师"];
            return;
        }
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[user objectForKey:@"USER_ID"] forKey:@"uid"];
        [param setObject:[gradeArray[gradeSelect] objectForKey:@"SUBJECT_ID"] forKey:@"grade"];
        [param setObject:[subjectArray[subjectSelect] objectForKey:@"SUBJECT_ID"] forKey:@"subject_id"];
        [param setObject:[chapterArray[chapterSelect] objectForKey:@"SUBJECT_ID"] forKey:@"chapter"];
        [param setObject:textView.text forKey:@"content"];
        
       
            NSMutableArray *selectedTeacher = [NSMutableArray array];
            for (int i = 0 ;i < selectedArray.count; i++) {
                NSDictionary *teacher = [selectedArray objectAtIndex:i];
                NSString *teacherid = [teacher objectForKey:@"ID"];
                [selectedTeacher addObject:teacherid];
            }
            [param setObject:[selectedTeacher componentsJoinedByString:@","] forKey:@"teacher_ids"];
        
        
        DLog(@"%@",param);
        
        [self showHudInView:self.view];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSSet *set = [NSSet setWithObject:@"text/html"];
        [manager.responseSerializer setAcceptableContentTypes:set];
        NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/question/add_on_demand"];
        DLog(@"url:%@",url);
        [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            [self hideHud];
            NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
            DLog(@"%@",dic);
            NSString *code = [dic objectForKey:@"code"];
            if ([code isEqualToString:@"200"]) {
//                NSDictionary *result = [dic objectForKey:@"result"];
                [self showHintInView:self.view hint:@"点播成功"];
                [selectedArray removeAllObjects];
                [self reloadSelectedTeacherView];
                textView.text = @"";
            }else{
                [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self hideHud];
            DLog(@"%@",error.description);
        }];
    }
    
    
    
    
    
    
}

//加载学段
-(void)loadData1{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/question/get_grade"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            gradeArray = [result objectForKey:@"data_list"];
            requestNum++;
            [self requestSuccess];
//                        DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@",error.description);
    }];
}

//加载学科
-(void)loadData2{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/question/get_subject"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            subjectArray = [result objectForKey:@"data_list"];
            requestNum++;
            [self requestSuccess];
//            DLog(@"%@",responseObject);
            [self loadData3:0];
            [self loadData4:0];
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@",error.description);
    }];
}

//加载学科下的章节
-(void)loadData3:(NSInteger)i{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/question/get_chapter"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSDictionary *dic = [subjectArray objectAtIndex:i];
    NSString *subjectId = [dic objectForKey:@"SUBJECT_ID"];
    [param setObject:subjectId forKey:@"subject_id"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            
            NSMutableDictionary *firstDic = [NSMutableDictionary dictionary];
            [firstDic setObject:@"0" forKey:@"SUBJECT_ID"];
            [firstDic setObject:@"全部" forKey:@"SUBJECT_NAME"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithObject:firstDic];
            [arr addObjectsFromArray:[result objectForKey:@"data_list"]];
            
            chapterArray = arr;
            if (picker3) {
                [picker3 reloadAllComponents];
            }
            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@",error.description);
    }];
}

//加载学科下面的老师
-(void)loadData4:(NSInteger)i{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/question/get_teacher"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSDictionary *dic = [subjectArray objectAtIndex:i];
    NSString *subjectId = [dic objectForKey:@"SUBJECT_ID"];
    [param setObject:subjectId forKey:@"subject_id"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            teacherArray= [result objectForKey:@"data_list"];
            [selectedArray removeAllObjects];
            [self reloadSelectedTeacherView];
            [teacherView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            CGFloat width = 80;
            CGFloat height = 24;
            CGFloat x = 0,y = 0;
            for (int i = 0; i < teacherArray.count; i++) {
                
                x = 30 + (width + 10) * (i%3);
                
                if (i!= 0 && i%3 == 0) {
                    x = 30;
                    y += 24 + 10;
                }
                
                UIButton *tbtn1 = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
                [tbtn1 setBackgroundImage:[UIImage imageWithColor:RGB(225, 225, 225) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
                tbtn1.tag = i;
                [tbtn1 addTarget:self action:@selector(selectedTeacher:) forControlEvents:UIControlEventTouchUpInside];
                [tbtn1 setTitle:[teacherArray[i] objectForKey:@"NAME"] forState:UIControlStateNormal];
                [tbtn1 setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
                tbtn1.titleLabel.font = SYSTEMFONT(14);
                [teacherView addSubview:tbtn1];
            }
            [teacherView setFrame:CGRectMake(0, teacherView.frame.origin.y, Main_Screen_Width, y+24 + 20)];
            CGRect frame = dianboBtn.frame;
            frame.origin.y = CGRectGetMaxY(teacherView.frame) + 10;
            [dianboBtn setFrame:frame];
            
            CGRect frame2 = contentView.frame;
            frame2.size.height = CGRectGetMaxY(dianboBtn.frame) + 30;
            contentView.frame = frame2;
            [_myScrollView setContentSize:CGSizeMake(Main_Screen_Width, CGRectGetMaxY(contentView.frame) + 30)];
            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@",error.description);
    }];
}

-(void)requestSuccess{
    if (requestNum == 2) {
        [self hideHud];
        [self initUI];
    }
}



-(void)action2:(UIButton *)btn{
    action2Tag = (int)btn.tag-1;
    [nbtn2 setTitle:btn.currentTitle forState:UIControlStateNormal];
    [self hidePopView2:nil];
}



-(void)chooseType2:(UIButton *)sender{
    if (popView2 == nil) {
        popView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 122)];
        popView2.backgroundColor = RGB(255, 255, 255);
        
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
        btn1.tag = 1;
        btn1.titleLabel.font = SYSTEMFONT(14);
        [btn1 setTitle:@"课程" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn1 addTarget:self action:@selector(action2:) forControlEvents:UIControlEventTouchUpInside];
        [popView2 addSubview:btn1];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn1.frame), Main_Screen_Width, 1)];
        line.backgroundColor = RGB(210, 210, 210);
        [popView2 addSubview:line];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, 40)];
        btn2.tag = 2;
        btn2.titleLabel.font = SYSTEMFONT(14);
        [btn2 setTitle:@"名师" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn2 addTarget:self action:@selector(action2:) forControlEvents:UIControlEventTouchUpInside];
        [popView2 addSubview:btn2];
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn2.frame), Main_Screen_Width, 1)];
        line.backgroundColor = RGB(210, 210, 210);
        [popView2 addSubview:line];
        
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, 40)];
        btn3.tag = 3;
        btn3.titleLabel.font = SYSTEMFONT(14);
        [btn3 setTitle:@"题目" forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn3 addTarget:self action:@selector(action2:) forControlEvents:UIControlEventTouchUpInside];
        [popView2 addSubview:btn3];
        
        ViewBorderRadius(popView2, 0, 0.5, RGB(160, 160, 160));
    }
    if (maskView2 == nil) {
        maskView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
        maskView2.backgroundColor = RGBA(0, 0, 0, 0.1);
        maskView2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopView2:)];
        [maskView2 addGestureRecognizer:tap];
    }
    
    [self.navigationController.view addSubview:maskView2];
    [self.navigationController.view addSubview:popView2];
}

-(void)hidePopView2:(UIGestureRecognizer *)sender{
    
    if (maskView2) {
        [maskView2 removeFromSuperview];
    }
    if (popView2) {
        [popView2 removeFromSuperview];
    }
    maskView2 = nil;
    popView2 = nil;
    
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

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    if (action2Tag == 1) {
        TeacherViewController *vc = [[TeacherViewController alloc] init];
        vc.top_search_key = _searchBar.text;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"searchValue":_searchBar.text,@"a":@"1"}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        gradeSelect = row;
        NSDictionary *dic = gradeArray[gradeSelect];
        NSString *subjectName = [dic objectForKey:@"SUBJECT_NAME"];
        [btn_1 setTitle:subjectName forState:UIControlStateNormal];
    }else if (pickerView.tag == 2){
        subjectSelect = row;
        NSDictionary *dic = subjectArray[subjectSelect];
        NSString *subjectName = [dic objectForKey:@"SUBJECT_NAME"];
        [btn_2 setTitle:subjectName forState:UIControlStateNormal];
        
        chapterSelect = 0;
        [btn_3 setTitle:@"全部" forState:UIControlStateNormal];
        [self loadData3:subjectSelect];
        
        [self loadData4:subjectSelect];
    }else if (pickerView.tag == 3){
        chapterSelect = row;
        NSDictionary *dic = chapterArray[chapterSelect];
        NSString *subjectName = [dic objectForKey:@"SUBJECT_NAME"];
        [btn_3 setTitle:subjectName forState:UIControlStateNormal];
        
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        NSDictionary *dic = gradeArray[row];
        NSString *subjectName = [dic objectForKey:@"SUBJECT_NAME"];
        return subjectName;
    }else if (pickerView.tag == 2){
        NSDictionary *dic = subjectArray[row];
        NSString *subjectName = [dic objectForKey:@"SUBJECT_NAME"];
        return subjectName;
    }else if (pickerView.tag == 3){
        NSDictionary *dic = chapterArray[row];
        NSString *subjectName = [dic objectForKey:@"SUBJECT_NAME"];
        return subjectName;
    }
    return @"";
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return gradeArray.count;
    }else if (pickerView.tag == 2){
        return subjectArray.count;
    }else if (pickerView.tag == 3){
        return chapterArray.count;
    }
    return 0;
}

@end
