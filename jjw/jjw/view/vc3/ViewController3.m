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

@interface ViewController3 ()

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.view.backgroundColor = RGB(245, 245, 245);
    [self initUI];
}

-(void)initUI{
    
    CGFloat barContentHeight = self.navigationController.navigationBar.frame.size.height - 20;
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 60, barContentHeight + 4)];
    [btn1 setTitle:@"课程" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = SYSTEMFONT(13);
    [btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(btn1, 5, 0, [UIColor whiteColor]);
    [self.navigationController.navigationBar addSubview:btn1];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame) + 10, 10, Main_Screen_Width - CGRectGetMaxX(btn1.frame) - 20, barContentHeight)];
    [self.navigationController.navigationBar addSubview:searchBar];

    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 42)];
    topLabel.backgroundColor = [UIColor whiteColor];
    topLabel.font = SYSTEMFONT(17);
    topLabel.textColor = [UIColor blackColor];
    topLabel.text = @"  我要点播";
    ViewBorderRadius(topLabel, 0, 1, RGB(223, 223, 223));
    [_myScrollView addSubview:topLabel];
    
    CGFloat maxY = 0;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topLabel.frame) + 10, Main_Screen_Width - 20, 0)];
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
    
    UIButton *btn_1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame) + 15, CGRectGetMinY(label1.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(label1.frame) - 15 - 30, CGRectGetHeight(label1.frame) + 16)];
    [btn_1 setTitle:@"高中" forState:UIControlStateNormal];
    [btn_1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_1.titleLabel.font = SYSTEMFONT(15);
    ViewBorderRadius(btn_1, 5, 1, BORDER_COLOR);
    [contentView addSubview:btn_1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label1.frame) + 25, 0, 0)];
    label2.text = @"选择学科:";
    label2.font = SYSTEMFONT(15);
    [label2 sizeToFit];
    [contentView addSubview:label2];
    
    UIButton *btn_2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame) + 15, CGRectGetMinY(label2.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(label2.frame) - 15 - 30, CGRectGetHeight(label2.frame) + 16)];
    [btn_2 setTitle:@"数学" forState:UIControlStateNormal];
    [btn_2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_2.titleLabel.font = SYSTEMFONT(15);
    ViewBorderRadius(btn_2, 5, 1, BORDER_COLOR);
    [contentView addSubview:btn_2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label2.frame) + 25, 0, 0)];
    label3.text = @"册数章节:";
    label3.font = SYSTEMFONT(15);
    [label3 sizeToFit];
    [contentView addSubview:label3];
    
    UIButton *btn_3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame) + 15, CGRectGetMinY(label3.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(label3.frame) - 15 - 30, CGRectGetHeight(label3.frame) + 16)];
    [btn_3 setTitle:@"全部" forState:UIControlStateNormal];
    [btn_3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_3.titleLabel.font = SYSTEMFONT(15);
    ViewBorderRadius(btn_3, 5, 1, BORDER_COLOR);
    [contentView addSubview:btn_3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label3.frame) + 25, 0, 0)];
    label4.text = @"点播内容:";
    label4.font = SYSTEMFONT(15);
    [label4 sizeToFit];
    [contentView addSubview:label4];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label4.frame) + 15, CGRectGetMinY(label4.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(label4.frame) - 15 - 30, 100)];
    ViewBorderRadius(textView, 5, 1, BORDER_COLOR);
    [contentView addSubview:textView];
    
    UILabel *label5 =  [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(textView.frame) + 25, 0, 0)];
    label5.text = @"讲解老师:";
    label5.font = SYSTEMFONT(15);
    [label5 sizeToFit];
    [contentView addSubview:label5];
    
    UILabel *teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label5.frame) + 15, CGRectGetMinY(label5.frame), 0, 0)];
    teacherLabel.text = @"请选择标签，最多选3个标签哦~";
    teacherLabel.font = SYSTEMFONT(15);
    teacherLabel.textColor = RGB(170, 170, 170);
    [teacherLabel sizeToFit];
    [contentView addSubview:teacherLabel];
    
    CGFloat width = 80;
    CGFloat height = 24;
    
    CGFloat x = 0,y = CGRectGetMaxY(label5.frame) + 15;
    for (int i = 0; i < 11; i++) {
        
        x = 30 + (width + 15) * (i%3);
        
        if (i!= 0 && i%3 == 0) {
            x = 30;
            y += 24 + 10;
        }
        
        DLog(@"%d %f %f",i,x,y);
        
        UIButton *tbtn1 = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [tbtn1 setBackgroundImage:[UIImage imageWithColor:RGB(225, 225, 225) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
        [tbtn1 setTitle:@"余信欢" forState:UIControlStateNormal];
        [tbtn1 setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        tbtn1.titleLabel.font = SYSTEMFONT(14);
        [contentView addSubview:tbtn1];
        
        maxY = CGRectGetMaxY(tbtn1.frame);
        DLog(@"%f",maxY);
    }
    
    UIButton *dianboBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, maxY + 20, CGRectGetWidth(contentView.frame) - 60, 35)];
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

-(void)dianbo{
    
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
